package org.variiance.vcall.components.settings.app.subscription.receipts.list

import io.reactivex.rxjava3.core.Single
import io.reactivex.rxjava3.schedulers.Schedulers
import org.variiance.vcall.database.SignalDatabase
import org.variiance.vcall.database.model.DonationReceiptRecord

class DonationReceiptListPageRepository {
  fun getRecords(type: DonationReceiptRecord.Type?): Single<List<DonationReceiptRecord>> {
    return Single.fromCallable {
      SignalDatabase.donationReceipts.getReceipts(type)
    }.subscribeOn(Schedulers.io())
  }
}
