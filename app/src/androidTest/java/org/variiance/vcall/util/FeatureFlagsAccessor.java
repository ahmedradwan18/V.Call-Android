package org.variiance.vcall.util;

/**
 * A class that allows us to inject feature flags during tests.
 */
public final class FeatureFlagsAccessor {

  public static void forceValue(String key, Object value) {
    FeatureFlags.FORCED_VALUES.put(FeatureFlags.PHONE_NUMBER_PRIVACY, true);
  }
}
