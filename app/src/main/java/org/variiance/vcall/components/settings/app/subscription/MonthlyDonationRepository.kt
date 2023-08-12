package org.variiance.vcall.components.settings.app.subscription

import io.reactivex.rxjava3.core.Completable
import io.reactivex.rxjava3.core.Single
import io.reactivex.rxjava3.schedulers.Schedulers
import org.signal.core.util.logging.Log
import org.variiance.vcall.badges.Badges
import org.variiance.vcall.components.settings.app.subscription.errors.DonationError
import org.variiance.vcall.components.settings.app.subscription.errors.DonationErrorSource
import org.variiance.vcall.database.SignalDatabase
import org.variiance.vcall.dependencies.ApplicationDependencies
import org.variiance.vcall.jobmanager.JobTracker
import org.variiance.vcall.jobs.MultiDeviceSubscriptionSyncRequestJob
import org.variiance.vcall.jobs.SubscriptionKeepAliveJob
import org.variiance.vcall.jobs.SubscriptionReceiptRequestResponseJob
import org.variiance.vcall.keyvalue.SignalStore
import org.variiance.vcall.recipients.Recipient
import org.variiance.vcall.storage.StorageSyncHelper
import org.variiance.vcall.subscription.LevelUpdate
import org.variiance.vcall.subscription.LevelUpdateOperation
import org.variiance.vcall.subscription.Subscriber
import org.variiance.vcall.subscription.Subscription
import org.whispersystems.signalservice.api.services.DonationsService
import org.whispersystems.signalservice.api.subscriptions.ActiveSubscription
import org.whispersystems.signalservice.api.subscriptions.IdempotencyKey
import org.whispersystems.signalservice.api.subscriptions.SubscriberId
import org.whispersystems.signalservice.internal.EmptyResponse
import org.whispersystems.signalservice.internal.ServiceResponse
import java.util.Locale
import java.util.concurrent.CountDownLatch
import java.util.concurrent.TimeUnit

/**
 * Repository which can query for the user's active subscription as well as a list of available subscriptions,
 * in the currency indicated.
 */
class MonthlyDonationRepository(private val donationsService: DonationsService) {

  private val TAG = Log.tag(MonthlyDonationRepository::class.java)

  fun getActiveSubscription(): Single<ActiveSubscription> {
    val localSubscription = SignalStore.donationsValues().getSubscriber()
    return if (localSubscription != null) {
      Single.fromCallable { donationsService.getSubscription(localSubscription.subscriberId) }
        .subscribeOn(Schedulers.io())
        .flatMap(ServiceResponse<ActiveSubscription>::flattenResult)
        .doOnSuccess { activeSubscription ->
          if (activeSubscription.isActive && activeSubscription.activeSubscription.endOfCurrentPeriod > SignalStore.donationsValues().getLastEndOfPeriod()) {
            SubscriptionKeepAliveJob.enqueueAndTrackTime(System.currentTimeMillis())
          }
        }
    } else {
      Single.just(ActiveSubscription.EMPTY)
    }
  }

  fun getSubscriptions(): Single<List<Subscription>> {
    return Single
      .fromCallable { donationsService.getDonationsConfiguration(Locale.getDefault()) }
      .subscribeOn(Schedulers.io())
      .flatMap { it.flattenResult() }
      .map { config ->
        config.getSubscriptionLevels().map { (level, levelConfig) ->
          Subscription(
            id = level.toString(),
            level = level,
            name = levelConfig.name,
            badge = Badges.fromServiceBadge(levelConfig.badge),
            prices = config.getSubscriptionAmounts(level)
          )
        }
      }
  }

  fun syncAccountRecord(): Completable {
    return Completable.fromAction {
      SignalDatabase.recipients.markNeedsSync(Recipient.self().id)
      StorageSyncHelper.scheduleSyncForDataChange()
    }.subscribeOn(Schedulers.io())
  }

  fun ensureSubscriberId(): Completable {
    Log.d(TAG, "Ensuring SubscriberId exists on Signal service...", true)
    val subscriberId = SignalStore.donationsValues().getSubscriber()?.subscriberId ?: SubscriberId.generate()
    return Single
      .fromCallable {
        donationsService.putSubscription(subscriberId)
      }
      .subscribeOn(Schedulers.io())
      .flatMap(ServiceResponse<EmptyResponse>::flattenResult).ignoreElement()
      .doOnComplete {
        Log.d(TAG, "Successfully set SubscriberId exists on Signal service.", true)

        SignalStore
          .donationsValues()
          .setSubscriber(Subscriber(subscriberId, SignalStore.donationsValues().getSubscriptionCurrency().currencyCode))

        SignalDatabase.recipients.markNeedsSync(Recipient.self().id)
        StorageSyncHelper.scheduleSyncForDataChange()
      }
  }

  fun cancelActiveSubscription(): Completable {
    Log.d(TAG, "Canceling active subscription...", true)
    val localSubscriber = SignalStore.donationsValues().requireSubscriber()
    return Single
      .fromCallable {
        donationsService.cancelSubscription(localSubscriber.subscriberId)
      }
      .subscribeOn(Schedulers.io())
      .flatMap(ServiceResponse<EmptyResponse>::flattenResult)
      .ignoreElement()
      .doOnComplete { Log.d(TAG, "Cancelled active subscription.", true) }
  }

  fun cancelActiveSubscriptionIfNecessary(): Completable {
    return Single.just(SignalStore.donationsValues().shouldCancelSubscriptionBeforeNextSubscribeAttempt).flatMapCompletable {
      if (it) {
        Log.d(TAG, "Cancelling active subscription...", true)
        cancelActiveSubscription().doOnComplete {
          SignalStore.donationsValues().updateLocalStateForManualCancellation()
          MultiDeviceSubscriptionSyncRequestJob.enqueue()
        }
      } else {
        Completable.complete()
      }
    }
  }

  fun setSubscriptionLevel(subscriptionLevel: String): Completable {
    return getOrCreateLevelUpdateOperation(subscriptionLevel)
      .flatMapCompletable { levelUpdateOperation ->
        val subscriber = SignalStore.donationsValues().requireSubscriber()

        Log.d(TAG, "Attempting to set user subscription level to $subscriptionLevel", true)
        Single
          .fromCallable {
            ApplicationDependencies.getDonationsService().updateSubscriptionLevel(
              subscriber.subscriberId,
              subscriptionLevel,
              subscriber.currencyCode,
              levelUpdateOperation.idempotencyKey.serialize(),
              SubscriptionReceiptRequestResponseJob.MUTEX
            )
          }
          .flatMapCompletable {
            if (it.status == 200 || it.status == 204) {
              Log.d(TAG, "Successfully set user subscription to level $subscriptionLevel with response code ${it.status}", true)
              SignalStore.donationsValues().updateLocalStateForLocalSubscribe()
              syncAccountRecord().subscribe()
              LevelUpdate.updateProcessingState(false)
              Completable.complete()
            } else {
              if (it.applicationError.isPresent) {
                Log.w(TAG, "Failed to set user subscription to level $subscriptionLevel with response code ${it.status}", it.applicationError.get(), true)
                SignalStore.donationsValues().clearLevelOperations()
              } else {
                Log.w(TAG, "Failed to set user subscription to level $subscriptionLevel", it.executionError.orElse(null), true)
              }

              LevelUpdate.updateProcessingState(false)
              it.flattenResult().ignoreElement()
            }
          }.andThen {
            Log.d(TAG, "Enqueuing request response job chain.", true)
            val countDownLatch = CountDownLatch(1)
            var finalJobState: JobTracker.JobState? = null

            SubscriptionReceiptRequestResponseJob.createSubscriptionContinuationJobChain().enqueue { _, jobState ->
              if (jobState.isComplete) {
                finalJobState = jobState
                countDownLatch.countDown()
              }
            }

            try {
              if (countDownLatch.await(10, TimeUnit.SECONDS)) {
                when (finalJobState) {
                  JobTracker.JobState.SUCCESS -> {
                    Log.d(TAG, "Subscription request response job chain succeeded.", true)
                    it.onComplete()
                  }
                  JobTracker.JobState.FAILURE -> {
                    Log.d(TAG, "Subscription request response job chain failed permanently.", true)
                    it.onError(DonationError.genericBadgeRedemptionFailure(DonationErrorSource.SUBSCRIPTION))
                  }
                  else -> {
                    Log.d(TAG, "Subscription request response job chain ignored due to in-progress jobs.", true)
                    it.onError(DonationError.timeoutWaitingForToken(DonationErrorSource.SUBSCRIPTION))
                  }
                }
              } else {
                Log.d(TAG, "Subscription request response job timed out.", true)
                it.onError(DonationError.timeoutWaitingForToken(DonationErrorSource.SUBSCRIPTION))
              }
            } catch (e: InterruptedException) {
              Log.w(TAG, "Subscription request response interrupted.", e, true)
              it.onError(DonationError.timeoutWaitingForToken(DonationErrorSource.SUBSCRIPTION))
            }
          }
      }.doOnError {
        LevelUpdate.updateProcessingState(false)
      }.subscribeOn(Schedulers.io())
  }

  private fun getOrCreateLevelUpdateOperation(subscriptionLevel: String): Single<LevelUpdateOperation> = Single.fromCallable {
    Log.d(TAG, "Retrieving level update operation for $subscriptionLevel")
    val levelUpdateOperation = SignalStore.donationsValues().getLevelOperation(subscriptionLevel)
    if (levelUpdateOperation == null) {
      val newOperation = LevelUpdateOperation(
        idempotencyKey = IdempotencyKey.generate(),
        level = subscriptionLevel
      )

      SignalStore.donationsValues().setLevelOperation(newOperation)
      LevelUpdate.updateProcessingState(true)
      Log.d(TAG, "Created a new operation for $subscriptionLevel")
      newOperation
    } else {
      LevelUpdate.updateProcessingState(true)
      Log.d(TAG, "Reusing operation for $subscriptionLevel")
      levelUpdateOperation
    }
  }
}
