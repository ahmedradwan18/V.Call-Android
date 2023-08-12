package org.variiance.vcall.database.model;

import org.variiance.vcall.database.MessageTable;
import org.variiance.vcall.database.MessageTypes;

final class StatusUtil {
  private StatusUtil() {}

  static boolean isDelivered(long deliveryStatus, int deliveryReceiptCount) {
    return (deliveryStatus >= MessageTable.Status.STATUS_COMPLETE &&
            deliveryStatus < MessageTable.Status.STATUS_PENDING) || deliveryReceiptCount > 0;
  }

  static boolean isPending(long type) {
    return MessageTypes.isPendingMessageType(type) &&
           !MessageTypes.isIdentityVerified(type) &&
           !MessageTypes.isIdentityDefault(type);
  }

  static boolean isFailed(long type, long deliveryStatus) {
    return MessageTypes.isFailedMessageType(type) ||
           MessageTypes.isPendingSecureSmsFallbackType(type) ||
           deliveryStatus >= MessageTable.Status.STATUS_FAILED;
  }

  static boolean isVerificationStatusChange(long type) {
    return MessageTypes.isIdentityDefault(type) || MessageTypes.isIdentityVerified(type);
  }
}
