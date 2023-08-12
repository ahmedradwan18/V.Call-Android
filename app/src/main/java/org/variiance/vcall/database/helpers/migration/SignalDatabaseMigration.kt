package org.variiance.vcall.database.helpers.migration

import android.app.Application
import net.zetetic.database.sqlcipher.SQLiteDatabase

/**
 * Simple interface for allowing database migrations to live outside of [org.variiance.vcall.database.helpers.SignalDatabaseMigrations].
 */
interface SignalDatabaseMigration {
  fun migrate(context: Application, db: SQLiteDatabase, oldVersion: Int, newVersion: Int)
}
