package org.variiance.vcall.database;

interface ThreadIdDatabaseReference {
  void remapThread(long fromId, long toId);
}
