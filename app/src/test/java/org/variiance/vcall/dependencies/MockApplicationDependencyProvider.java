package org.variiance.vcall.dependencies;

import androidx.annotation.NonNull;

import org.signal.core.util.concurrent.DeadlockDetector;
import org.signal.libsignal.zkgroup.profiles.ClientZkProfileOperations;
import org.signal.libsignal.zkgroup.receipts.ClientZkReceiptOperations;
import org.variiance.vcall.KbsEnclave;
import org.variiance.vcall.components.TypingStatusRepository;
import org.variiance.vcall.components.TypingStatusSender;
import org.variiance.vcall.crypto.storage.SignalServiceDataStoreImpl;
import org.variiance.vcall.database.DatabaseObserver;
import org.variiance.vcall.database.PendingRetryReceiptCache;
import org.variiance.vcall.jobmanager.JobManager;
import org.variiance.vcall.megaphone.MegaphoneRepository;
import org.variiance.vcall.messages.BackgroundMessageRetriever;
import org.variiance.vcall.messages.IncomingMessageObserver;
import org.variiance.vcall.notifications.MessageNotifier;
import org.variiance.vcall.payments.Payments;
import org.variiance.vcall.push.SignalServiceNetworkAccess;
import org.variiance.vcall.recipients.LiveRecipientCache;
import org.variiance.vcall.revealable.ViewOnceMessageManager;
import org.variiance.vcall.service.DeletedCallEventManager;
import org.variiance.vcall.service.ExpiringMessageManager;
import org.variiance.vcall.service.ExpiringStoriesManager;
import org.variiance.vcall.service.PendingRetryReceiptManager;
import org.variiance.vcall.service.ScheduledMessageManager;
import org.variiance.vcall.service.TrimThreadsByDateManager;
import org.variiance.vcall.service.webrtc.SignalCallManager;
import org.variiance.vcall.shakereport.ShakeToReport;
import org.variiance.vcall.util.AppForegroundObserver;
import org.variiance.vcall.util.EarlyMessageCache;
import org.variiance.vcall.util.FrameRateTracker;
import org.variiance.vcall.video.exo.GiphyMp4Cache;
import org.variiance.vcall.video.exo.SimpleExoPlayerPool;
import org.variiance.vcall.webrtc.audio.AudioManagerCompat;
import org.whispersystems.signalservice.api.KeyBackupService;
import org.whispersystems.signalservice.api.SignalServiceAccountManager;
import org.whispersystems.signalservice.api.SignalServiceDataStore;
import org.whispersystems.signalservice.api.SignalServiceMessageReceiver;
import org.whispersystems.signalservice.api.SignalServiceMessageSender;
import org.whispersystems.signalservice.api.SignalWebSocket;
import org.whispersystems.signalservice.api.groupsv2.GroupsV2Operations;
import org.whispersystems.signalservice.api.services.CallLinksService;
import org.whispersystems.signalservice.api.services.DonationsService;
import org.whispersystems.signalservice.api.services.ProfileService;
import org.whispersystems.signalservice.internal.configuration.SignalServiceConfiguration;

import java.security.KeyStore;
import java.util.function.Supplier;

import static org.mockito.Mockito.mock;

@SuppressWarnings("ConstantConditions")
public class MockApplicationDependencyProvider implements ApplicationDependencies.Provider {
  @Override
  public @NonNull GroupsV2Operations provideGroupsV2Operations(@NonNull SignalServiceConfiguration signalServiceConfiguration) {
    return null;
  }

  @Override
  public @NonNull SignalServiceAccountManager provideSignalServiceAccountManager(@NonNull SignalServiceConfiguration signalServiceConfiguration, @NonNull GroupsV2Operations groupsV2Operations) {
    return null;
  }

  @Override
  public @NonNull SignalServiceMessageSender provideSignalServiceMessageSender(@NonNull SignalWebSocket signalWebSocket, @NonNull SignalServiceDataStore protocolStore, @NonNull SignalServiceConfiguration signalServiceConfiguration) {
    return null;
  }

  @Override
  public @NonNull SignalServiceMessageReceiver provideSignalServiceMessageReceiver(@NonNull SignalServiceConfiguration signalServiceConfiguration) {
    return null;
  }

  @Override
  public @NonNull SignalServiceNetworkAccess provideSignalServiceNetworkAccess() {
    return null;
  }

  @Override
  public @NonNull BackgroundMessageRetriever provideBackgroundMessageRetriever() {
    return null;
  }

  @Override
  public @NonNull LiveRecipientCache provideRecipientCache() {
    return null;
  }

  @Override
  public @NonNull JobManager provideJobManager() {
    return mock(JobManager.class);
  }

  @Override
  public @NonNull FrameRateTracker provideFrameRateTracker() {
    return null;
  }

  @Override
  public @NonNull MegaphoneRepository provideMegaphoneRepository() {
    return null;
  }

  @Override
  public @NonNull EarlyMessageCache provideEarlyMessageCache() {
    return null;
  }

  @Override
  public @NonNull MessageNotifier provideMessageNotifier() {
    return null;
  }

  @Override
  public @NonNull IncomingMessageObserver provideIncomingMessageObserver() {
    return null;
  }

  @Override
  public @NonNull TrimThreadsByDateManager provideTrimThreadsByDateManager() {
    return null;
  }

  @Override
  public @NonNull ViewOnceMessageManager provideViewOnceMessageManager() {
    return null;
  }

  @Override
  public @NonNull ExpiringStoriesManager provideExpiringStoriesManager() {
    return null;
  }

  @Override
  public @NonNull ExpiringMessageManager provideExpiringMessageManager() {
    return null;
  }

  @Override
  public @NonNull DeletedCallEventManager provideDeletedCallEventManager() {
    return null;
  }

  @Override
  public @NonNull TypingStatusRepository provideTypingStatusRepository() {
    return null;
  }

  @Override
  public @NonNull TypingStatusSender provideTypingStatusSender() {
    return null;
  }

  @Override
  public @NonNull DatabaseObserver provideDatabaseObserver() {
    return mock(DatabaseObserver.class);
  }

  @Override
  public @NonNull Payments providePayments(@NonNull SignalServiceAccountManager signalServiceAccountManager) {
    return null;
  }

  @Override
  public @NonNull ShakeToReport provideShakeToReport() {
    return null;
  }

  @Override
  public @NonNull AppForegroundObserver provideAppForegroundObserver() {
    return mock(AppForegroundObserver.class);
  }

  @Override
  public @NonNull SignalCallManager provideSignalCallManager() {
    return null;
  }

  @Override
  public @NonNull PendingRetryReceiptManager providePendingRetryReceiptManager() {
    return null;
  }

  @Override
  public @NonNull PendingRetryReceiptCache providePendingRetryReceiptCache() {
    return null;
  }

  @Override
  public @NonNull SignalWebSocket provideSignalWebSocket(@NonNull Supplier<SignalServiceConfiguration> signalServiceConfigurationSupplier) {
    return null;
  }

  @Override
  public @NonNull SignalServiceDataStoreImpl provideProtocolStore() {
    return null;
  }

  @Override
  public @NonNull GiphyMp4Cache provideGiphyMp4Cache() {
    return null;
  }

  @Override
  public @NonNull SimpleExoPlayerPool provideExoPlayerPool() {
    return null;
  }

  @Override
  public @NonNull AudioManagerCompat provideAndroidCallAudioManager() {
    return null;
  }

  @Override
  public @NonNull DonationsService provideDonationsService(@NonNull SignalServiceConfiguration signalServiceConfiguration, @NonNull GroupsV2Operations groupsV2Operations) {
    return null;
  }

  @NonNull @Override public CallLinksService provideCallLinksService(@NonNull SignalServiceConfiguration signalServiceConfiguration, @NonNull GroupsV2Operations groupsV2Operations) {
    return null;
  }

  @Override
  public @NonNull ProfileService provideProfileService(@NonNull ClientZkProfileOperations profileOperations, @NonNull SignalServiceMessageReceiver signalServiceMessageReceiver, @NonNull SignalWebSocket signalWebSocket) {
    return null;
  }

  @Override
  public @NonNull DeadlockDetector provideDeadlockDetector() {
    return null;
  }

  @Override
  public @NonNull ClientZkReceiptOperations provideClientZkReceiptOperations(@NonNull SignalServiceConfiguration signalServiceConfiguration) {
    return null;
  }

  @Override
  public @NonNull KeyBackupService provideKeyBackupService(@NonNull SignalServiceAccountManager signalServiceAccountManager, @NonNull KeyStore keyStore, @NonNull KbsEnclave enclave) {
    return null;
  }

  @Override
  public @NonNull ScheduledMessageManager provideScheduledMessageManager() {
    return null;
  }
}
