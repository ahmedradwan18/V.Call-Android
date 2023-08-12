package org.variiance.vcall.search

import org.variiance.vcall.recipients.Recipient

data class ContactSearchResult(val results: List<Recipient>, val query: String)
