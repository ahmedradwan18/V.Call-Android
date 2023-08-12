package org.variiance.vcall.jobmanager.migrations;

import androidx.annotation.NonNull;
import androidx.annotation.VisibleForTesting;

import org.signal.core.util.logging.Log;
import org.variiance.vcall.database.GroupTable;
import org.variiance.vcall.database.model.GroupRecord;
import org.variiance.vcall.database.SignalDatabase;
import org.variiance.vcall.groups.GroupId;
import org.variiance.vcall.jobmanager.JsonJobData;
import org.variiance.vcall.jobmanager.JobMigration;
import org.variiance.vcall.jobs.FailingJob;

import java.util.Optional;

/**
 * We removed the messageId property from the job data and replaced it with a serialized envelope,
 * so we need to take jobs that referenced an ID and replace it with the envelope instead.
 */
public class SenderKeyDistributionSendJobRecipientMigration extends JobMigration {

  private static final String TAG = Log.tag(SenderKeyDistributionSendJobRecipientMigration.class);

  private final GroupTable groupDatabase;

  public SenderKeyDistributionSendJobRecipientMigration() {
    this(SignalDatabase.groups());
  }

  @VisibleForTesting
  SenderKeyDistributionSendJobRecipientMigration(GroupTable groupDatabase) {
    super(9);
    this.groupDatabase = groupDatabase;
  }

  @Override
  protected @NonNull JobData migrate(@NonNull JobData jobData) {
    if ("SenderKeyDistributionSendJob".equals(jobData.getFactoryKey())) {
      return migrateJob(jobData, groupDatabase);
    } else {
      return jobData;
    }
  }

  private static @NonNull JobData migrateJob(@NonNull JobData jobData, @NonNull GroupTable groupDatabase) {
    JsonJobData data = JsonJobData.deserialize(jobData.getData());

    if (data.hasString("group_id")) {
      GroupId               groupId = GroupId.pushOrThrow(data.getStringAsBlob("group_id"));
      Optional<GroupRecord> group   = groupDatabase.getGroup(groupId);

      if (group.isPresent()) {
        return jobData.withData(data.buildUpon()
                                    .putString("thread_recipient_id", group.get().getRecipientId().serialize())
                                    .serialize());

      } else {
        return jobData.withFactoryKey(FailingJob.KEY);
      }
    } else if (!data.hasString("thread_recipient_id")) {
      return jobData.withFactoryKey(FailingJob.KEY);
    } else {
      return jobData;
    }
  }
}
