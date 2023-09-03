package org.thoughtcrime.securesms;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.ViewTreeObserver;

import io.flutter.plugin.common.MethodChannel.MethodCallHandler;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.core.content.ContextCompat;
import androidx.lifecycle.ViewModelProvider;

import com.google.android.material.dialog.MaterialAlertDialogBuilder;

import org.thoughtcrime.securesms.components.voice.VoiceNoteMediaController;
import org.thoughtcrime.securesms.components.voice.VoiceNoteMediaControllerOwner;
import org.thoughtcrime.securesms.conversationlist.RelinkDevicesReminderBottomSheetFragment;
import org.thoughtcrime.securesms.devicetransfer.olddevice.OldDeviceExitActivity;
import org.thoughtcrime.securesms.keyvalue.SignalStore;
import org.thoughtcrime.securesms.net.DeviceTransferBlockingInterceptor;
import org.thoughtcrime.securesms.registration.viewmodel.RegistrationViewModel;
import org.thoughtcrime.securesms.stories.tabs.ConversationListTabRepository;
import org.thoughtcrime.securesms.stories.tabs.ConversationListTabsViewModel;
import org.thoughtcrime.securesms.util.AppStartup;
import org.thoughtcrime.securesms.util.CachedInflater;
import org.thoughtcrime.securesms.util.CommunicationActions;
import org.thoughtcrime.securesms.util.DynamicNoActionBarTheme;
import org.thoughtcrime.securesms.util.DynamicTheme;
import org.thoughtcrime.securesms.util.SplashScreenUtil;
import org.thoughtcrime.securesms.util.WindowUtil;

import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.FlutterEngineCache;
import io.flutter.embedding.engine.dart.DartExecutor;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends PassphraseRequiredActivity implements VoiceNoteMediaControllerOwner {

  public static final int RESULT_CONFIG_CHANGED = Activity.RESULT_FIRST_USER + 901;

  private final DynamicTheme  dynamicTheme = new DynamicNoActionBarTheme();
  private final MainNavigator navigator    = new MainNavigator(this);
  private RegistrationViewModel viewModel;
  private VoiceNoteMediaController      mediaController;
  private ConversationListTabsViewModel conversationListTabsViewModel;
  FlutterEngine flutterEngine;
  private boolean onFirstRender = false;

  public static @NonNull Intent clearTop(@NonNull Context context) {
    Intent intent = new Intent(context, MainActivity.class);

    intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP |
                    Intent.FLAG_ACTIVITY_NEW_TASK |
                    Intent.FLAG_ACTIVITY_SINGLE_TOP);

    return intent;
  }

  @Override
  protected void onCreate(Bundle savedInstanceState, boolean ready) {
    AppStartup.getInstance().onCriticalRenderEventStart();
    super.onCreate(savedInstanceState, ready);

    setContentView(R.layout.main_activity);


    flutterEngine = new FlutterEngine(getBaseContext());

// Start executing Dart code in the FlutterEngine.
    flutterEngine.getDartExecutor().executeDartEntrypoint(
        DartExecutor.DartEntrypoint.createDefault()
    );

// Cache the pre-warmed FlutterEngine to be used later by FlutterFragment.

    if (!FlutterEngineCache.getInstance().contains("flutter_engine")) {
      FlutterEngineCache
          .getInstance()
          .put("flutter_engine", flutterEngine);

      Log.d("Flutter_Engine", "onCreate: Flutter Engine Cached");
    }


//    if(viewModel!=null){
//      if(viewModel.getNumber().isValid()){
//
//        System.out.println("radwan=> "+viewModel.getNumber());
//
//      }
//      else{
//        System.out.println("radwan=> not valid number");
//
//      }
//
//    }
//

    var testChannel = new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), "channel_radwan");

    testChannel.invokeMethod("getRadwan", "yaaarb");




    final View content = findViewById(android.R.id.content);
    content.getViewTreeObserver().addOnPreDrawListener(
        new ViewTreeObserver.OnPreDrawListener() {
          @Override
          public boolean onPreDraw() {
            // Use pre draw listener to delay drawing frames till conversation list is ready
            if (onFirstRender) {
              content.getViewTreeObserver().removeOnPreDrawListener(this);
              return true;
            } else {
              return false;
            }
          }
        });


    mediaController = new VoiceNoteMediaController(this, true);

    ConversationListTabRepository         repository = new ConversationListTabRepository();
    ConversationListTabsViewModel.Factory factory    = new ConversationListTabsViewModel.Factory(repository);

    handleGroupLinkInIntent(getIntent());
    handleProxyInIntent(getIntent());
    handleSignalMeIntent(getIntent());
    handleCallLinkInIntent(getIntent());

    CachedInflater.from(this).clear();

    conversationListTabsViewModel = new ViewModelProvider(this, factory).get(ConversationListTabsViewModel.class);
    updateTabVisibility();
  }




  @Override
  public Intent getIntent() {
    return super.getIntent().setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP |
                                      Intent.FLAG_ACTIVITY_NEW_TASK |
                                      Intent.FLAG_ACTIVITY_SINGLE_TOP);
  }

  @Override
  protected void onNewIntent(Intent intent) {
    super.onNewIntent(intent);
    handleGroupLinkInIntent(intent);
    handleProxyInIntent(intent);
    handleSignalMeIntent(intent);
    handleCallLinkInIntent(intent);
  }

  @Override
  protected void onPreCreate() {
    super.onPreCreate();
    dynamicTheme.onCreate(this);
  }

  @Override
  protected void onResume() {
    super.onResume();
    dynamicTheme.onResume(this);
    if (SignalStore.misc().isOldDeviceTransferLocked()) {
      new MaterialAlertDialogBuilder(this)
          .setTitle(R.string.OldDeviceTransferLockedDialog__complete_registration_on_your_new_device)
          .setMessage(R.string.OldDeviceTransferLockedDialog__your_signal_account_has_been_transferred_to_your_new_device)
          .setPositiveButton(R.string.OldDeviceTransferLockedDialog__done, (d, w) -> OldDeviceExitActivity.exit(this))
          .setNegativeButton(R.string.OldDeviceTransferLockedDialog__cancel_and_activate_this_device, (d, w) -> {
            SignalStore.misc().clearOldDeviceTransferLocked();
            DeviceTransferBlockingInterceptor.getInstance().unblockNetwork();
          })
          .setCancelable(false)
          .show();
    }

    if (SignalStore.misc().getShouldShowLinkedDevicesReminder()) {
      SignalStore.misc().setShouldShowLinkedDevicesReminder(false);
      RelinkDevicesReminderBottomSheetFragment.show(getSupportFragmentManager());
    }

    updateTabVisibility();
  }

  @Override
  protected void onStop() {
    super.onStop();
    SplashScreenUtil.setSplashScreenThemeIfNecessary(this, SignalStore.settings().getTheme());
  }

  @Override
  public void onBackPressed() {
    if (!navigator.onBackPressed()) {
      super.onBackPressed();
    }
  }

  @Override
  protected void onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
    super.onActivityResult(requestCode, resultCode, data);
    if (requestCode == MainNavigator.REQUEST_CONFIG_CHANGES && resultCode == RESULT_CONFIG_CHANGED) {
      recreate();
    }
  }

  private void updateTabVisibility() {
    findViewById(R.id.conversation_list_tabs).setVisibility(View.VISIBLE);
    WindowUtil.setNavigationBarColor(this, ContextCompat.getColor(this, R.color.signal_colorSurface2));
  }

  public @NonNull MainNavigator getNavigator() {
    return navigator;
  }

  private void handleGroupLinkInIntent(Intent intent) {
    Uri data = intent.getData();
    if (data != null) {
      CommunicationActions.handlePotentialGroupLinkUrl(this, data.toString());
    }
  }

  private void handleProxyInIntent(Intent intent) {
    Uri data = intent.getData();
    if (data != null) {
      CommunicationActions.handlePotentialProxyLinkUrl(this, data.toString());
    }
  }

  private void handleSignalMeIntent(Intent intent) {
    Uri data = intent.getData();
    if (data != null) {
      CommunicationActions.handlePotentialSignalMeUrl(this, data.toString());
    }
  }

  private void handleCallLinkInIntent(Intent intent) {
    Uri data = intent.getData();
    if (data != null) {
      CommunicationActions.handlePotentialCallLinkUrl(this, data.toString());
    }
  }

  public void onFirstRender() {
    onFirstRender = true;
  }

  @Override
  public @NonNull VoiceNoteMediaController getVoiceNoteMediaController() {
    return mediaController;
  }
}
