package org.variiance.vcall.conversation.v2.data;

import androidx.annotation.NonNull;

import org.variiance.vcall.database.SignalDatabase;
import org.variiance.vcall.database.model.MediaMmsMessageRecord;
import org.variiance.vcall.database.model.MessageId;
import org.variiance.vcall.database.model.MessageRecord;
import org.variiance.vcall.database.model.ReactionRecord;
import org.variiance.vcall.util.Util;

import java.util.Collection;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public class ReactionHelper {

  private Collection<MessageId>                messageIds           = new LinkedList<>();
  private Map<MessageId, List<ReactionRecord>> messageIdToReactions = new HashMap<>();

  public void add(MessageRecord record) {
    messageIds.add(new MessageId(record.getId()));
  }

  public void addAll(List<MessageRecord> records) {
    for (MessageRecord record : records) {
      add(record);
    }
  }

  public void fetchReactions() {
    messageIdToReactions = SignalDatabase.reactions().getReactionsForMessages(messageIds);
  }

  public @NonNull List<MessageRecord> buildUpdatedModels(@NonNull List<MessageRecord> records) {
    return records.stream()
                  .map(record -> {
                    MessageId            messageId = new MessageId(record.getId());
                    List<ReactionRecord> reactions = messageIdToReactions.get(messageId);

                    return recordWithReactions(record, reactions);
                  })
                  .collect(Collectors.toList());
  }

  public static @NonNull MessageRecord recordWithReactions(@NonNull MessageRecord record, List<ReactionRecord> reactions) {
    if (Util.hasItems(reactions)) {
      if (record instanceof MediaMmsMessageRecord) {
        return ((MediaMmsMessageRecord) record).withReactions(reactions);
      } else {
        throw new IllegalStateException("We have reactions for an unsupported record type: " + record.getClass().getName());
      }
    } else {
      return record;
    }
  }
}
