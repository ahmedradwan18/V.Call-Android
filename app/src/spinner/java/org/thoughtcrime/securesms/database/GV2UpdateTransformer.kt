package org.variiance.vcall.database

import android.database.Cursor
import org.signal.core.util.CursorUtil
import org.signal.core.util.requireLong
import org.signal.spinner.ColumnTransformer
import org.signal.spinner.DefaultColumnTransformer
import org.variiance.vcall.database.model.MessageRecord
import org.variiance.vcall.database.model.UpdateDescription
import org.variiance.vcall.database.model.databaseprotos.DecryptedGroupV2Context
import org.variiance.vcall.dependencies.ApplicationDependencies
import org.variiance.vcall.util.Base64

object GV2UpdateTransformer : ColumnTransformer {
  override fun matches(tableName: String?, columnName: String): Boolean {
    return columnName == MessageTable.BODY && (tableName == null || tableName == MessageTable.TABLE_NAME)
  }

  override fun transform(tableName: String?, columnName: String, cursor: Cursor): String? {
    val type: Long = cursor.getMessageType()

    if (type == -1L) {
      return DefaultColumnTransformer.transform(tableName, columnName, cursor)
    }

    val body: String? = CursorUtil.requireString(cursor, MessageTable.BODY)

    return if (MessageTypes.isGroupV2(type) && MessageTypes.isGroupUpdate(type) && body != null) {
      val decoded = Base64.decode(body)
      val decryptedGroupV2Context = DecryptedGroupV2Context.parseFrom(decoded)
      val gv2ChangeDescription: UpdateDescription = MessageRecord.getGv2ChangeDescription(ApplicationDependencies.getApplication(), body, null)

      "${gv2ChangeDescription.spannable}<br><br>${decryptedGroupV2Context.change}"
    } else {
      body
    }
  }
}

private fun Cursor.getMessageType(): Long {
  return when {
    getColumnIndex(MessageTable.TYPE) != -1 -> requireLong(MessageTable.TYPE)
    else -> -1
  }
}
