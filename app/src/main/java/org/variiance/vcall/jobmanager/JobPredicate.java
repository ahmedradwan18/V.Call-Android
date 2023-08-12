package org.variiance.vcall.jobmanager;

import androidx.annotation.NonNull;

import org.variiance.vcall.jobmanager.persistence.JobSpec;

public interface JobPredicate {
  JobPredicate NONE = jobSpec -> true;

  boolean shouldRun(@NonNull JobSpec jobSpec);
}
