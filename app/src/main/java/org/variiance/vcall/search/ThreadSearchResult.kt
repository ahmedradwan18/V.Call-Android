package org.variiance.vcall.search

import org.variiance.vcall.database.model.ThreadRecord

data class ThreadSearchResult(val results: List<ThreadRecord>, val query: String)
