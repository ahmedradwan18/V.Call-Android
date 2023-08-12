package org.variiance.vcall.main

import android.widget.ImageView
import org.variiance.vcall.components.Material3SearchToolbar
import org.variiance.vcall.util.views.Stub

interface SearchBinder {
  fun getSearchAction(): ImageView

  fun getSearchToolbar(): Stub<Material3SearchToolbar>

  fun onSearchOpened()

  fun onSearchClosed()
}
