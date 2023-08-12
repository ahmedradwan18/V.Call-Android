package org.variiance.vcall.badges.gifts

import org.variiance.vcall.R
import org.variiance.vcall.badges.models.Badge
import org.variiance.vcall.badges.models.BadgeDisplay112
import org.variiance.vcall.components.settings.DSLConfiguration
import org.variiance.vcall.components.settings.DSLSettingsText
import org.variiance.vcall.database.model.databaseprotos.GiftBadge
import org.variiance.vcall.keyvalue.SignalStore
import org.variiance.vcall.util.adapter.mapping.MappingAdapter

/**
 * Contains shared DSL layout for expired gifts, creatable using a GiftBadge or a Badge.
 */
object ExpiredGiftSheetConfiguration {
  fun register(mappingAdapter: MappingAdapter) {
    BadgeDisplay112.register(mappingAdapter)
  }

  fun DSLConfiguration.forExpiredBadge(badge: Badge, onMakeAMonthlyDonation: () -> Unit, onNotNow: () -> Unit) {
    customPref(BadgeDisplay112.Model(badge, withDisplayText = false))
    expiredSheet(onMakeAMonthlyDonation, onNotNow)
  }

  fun DSLConfiguration.forExpiredGiftBadge(giftBadge: GiftBadge, onMakeAMonthlyDonation: () -> Unit, onNotNow: () -> Unit) {
    customPref(BadgeDisplay112.GiftModel(giftBadge))
    expiredSheet(onMakeAMonthlyDonation, onNotNow)
  }

  private fun DSLConfiguration.expiredSheet(onMakeAMonthlyDonation: () -> Unit, onNotNow: () -> Unit) {
    textPref(
      title = DSLSettingsText.from(
        stringId = R.string.ExpiredGiftSheetConfiguration__your_badge_has_expired,
        DSLSettingsText.CenterModifier,
        DSLSettingsText.TitleLargeModifier
      )
    )

    textPref(
      title = DSLSettingsText.from(
        stringId = R.string.ExpiredGiftSheetConfiguration__your_badge_has_expired_and_is,
        DSLSettingsText.CenterModifier
      )
    )

    if (SignalStore.donationsValues().isLikelyASustainer()) {
      primaryButton(
        text = DSLSettingsText.from(
          stringId = android.R.string.ok
        ),
        onClick = {
          onNotNow()
        }
      )
    } else {
      textPref(
        title = DSLSettingsText.from(
          stringId = R.string.ExpiredGiftSheetConfiguration__to_continue,
          DSLSettingsText.CenterModifier
        )
      )

      primaryButton(
        text = DSLSettingsText.from(
          stringId = R.string.ExpiredGiftSheetConfiguration__make_a_monthly_donation
        ),
        onClick = {
          onMakeAMonthlyDonation()
        }
      )

      secondaryButtonNoOutline(
        text = DSLSettingsText.from(
          stringId = R.string.ExpiredGiftSheetConfiguration__not_now
        ),
        onClick = {
          onNotNow()
        }
      )
    }
  }
}
