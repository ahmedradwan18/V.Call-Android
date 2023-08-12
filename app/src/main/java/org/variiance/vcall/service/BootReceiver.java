package org.variiance.vcall.service;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;

import org.variiance.vcall.dependencies.ApplicationDependencies;
import org.variiance.vcall.jobs.PushNotificationReceiveJob;

public class BootReceiver extends BroadcastReceiver {

  @Override
  public void onReceive(Context context, Intent intent) {
    ApplicationDependencies.getJobManager().add(new PushNotificationReceiveJob());
  }
}
