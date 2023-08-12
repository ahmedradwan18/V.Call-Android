package org.variiance.vcall.profiles.username

import android.os.Bundle
import androidx.navigation.fragment.NavHostFragment
import org.variiance.vcall.BaseActivity
import org.variiance.vcall.R
import org.variiance.vcall.profiles.manage.UsernameEditFragmentArgs
import org.variiance.vcall.util.DynamicNoActionBarTheme
import org.variiance.vcall.util.DynamicTheme

class AddAUsernameActivity : BaseActivity() {
  private val dynamicTheme: DynamicTheme = DynamicNoActionBarTheme()
  private val contentViewId: Int = R.layout.fragment_container

  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    setContentView(contentViewId)
    dynamicTheme.onCreate(this)

    if (savedInstanceState == null) {
      supportFragmentManager.beginTransaction()
        .replace(
          R.id.fragment_container,
          NavHostFragment.create(
            R.navigation.create_username,
            UsernameEditFragmentArgs.Builder().setIsInRegistration(true).build().toBundle()
          )
        )
        .commit()
    }
  }

  override fun onResume() {
    super.onResume()
    dynamicTheme.onResume(this)
  }
}
