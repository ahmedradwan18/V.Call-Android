package org.thoughtcrime.securesms.compose

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.compose.runtime.Composable
import androidx.compose.ui.platform.ComposeView
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.platform.ViewCompositionStrategy
import androidx.compose.ui.tooling.preview.Preview
import org.signal.core.ui.theme.SignalTheme
import org.thoughtcrime.securesms.LoggingFragment
import org.thoughtcrime.securesms.util.DynamicTheme

/**
 * Generic ComposeFragment which can be subclassed to build UI with compose.
 */
abstract class ComposeFragment : LoggingFragment() {
  override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {
    return ComposeView(requireContext()).apply {
      setViewCompositionStrategy(ViewCompositionStrategy.DisposeOnViewTreeLifecycleDestroyed)
      setContent {
        SignalTheme(
          isDarkMode = DynamicTheme.isDarkTheme(LocalContext.current)
        ) {
          FragmentContent()
        }
      }
    }
  }

  @Composable
  @Preview
  abstract fun FragmentContent()
}
