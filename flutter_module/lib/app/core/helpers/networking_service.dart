import 'dart:async';

// import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:get/get.dart';

import '../../data/enums/snack_bar_type.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_theme.dart';
import '../helpers/snackbar_helper.dart';
import '../utils/logging_service.dart';
import '../values/app_constants.dart';
import 'api_helper.dart';

/// this will store all the things conserned with 'Networking'
class NetworkingService extends DisposableInterface {
  //*==================================================
  @override
  void onClose() {
    // _connectivitySubscription.cancel();
    super.onClose();
  }

  //!===========================================================================
  //!=============================== Constructor ===============================
  //!===========================================================================
  // to have only one(1) Authentication class [Singelton]
  static final NetworkingService _singleton = NetworkingService._internal();
  factory NetworkingService() {
    return _singleton;
  }
  NetworkingService._internal() {
    LoggingService.information(
      '----- Initializing NetworkingService -----',
    );
    // _connectivitySubscription =
    //     _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  //!===========================================================================
  //!================================ Parameters ===============================
  //!===========================================================================

  // final Connectivity _connectivity = Connectivity();
  // late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  static const String _networkRestoredText = 'network_restored';
  static const String _networkLostText = 'network_lost';
  static const SnackBarType _netwrokRestoredState = SnackBarType.information;
  static const SnackBarType _networkLostState = SnackBarType.error;

  String _netwrokState = '';
  SnackBarType _snackbarType = SnackBarType.action;
  // Skip the first two entries, they are unnecessary and may cause an error.
  int _skipCounter = 2;

  final _hasNetwork = true.obs;
  //!===========================================================================
  //!============================ Getters/Setters ==============================
  //!===========================================================================

  bool get hasNetwork => _hasNetwork.value;
  set hasNetwork(bool newValue) => _hasNetwork(newValue);
  //!===========================================================================
  //!================================= Methods =================================
  //!===========================================================================
  // void _updateConnectionStatus( status) {
  //   hasNetwork = (status != ConnectivityResult.none);

  //   _netwrokState = hasNetwork ? _networkRestoredText : _networkLostText;
  //   _snackbarType = hasNetwork ? _netwrokRestoredState : _networkLostState;

  //   if (_skipCounter != 0) {
  //     _skipCounter--;
  //     return;
  //   }

  //   SnackBarHelper.showSnackBar(
  //     message: _netwrokState.tr,
  //     type: _snackbarType,
  //     duration:
  //         hasNetwork ? const Duration(seconds: 3) : const Duration(minutes: 3),
  //     borderRadius: 2.0,
  //     horizontalMarginFactor: 0,
  //   );
  // }

  //*==================================================
  Future<void> inAppBrowserLauncher({
    required String url,
  }) async {
    try {
      // in app brows∏er to enable google sign in on android
      // as it doesn't work on webview
      // await launch(
      //   url,
      //   customTabsOption: CustomTabsOption(
      //     toolbarColor: AppTheme.appTheme.primaryColor,
      //     enableDefaultShare: false,
      //     enableUrlBarHiding: true,
      //     showPageTitle: false,
      //     extraCustomTabs: const <String>[
      //       'org.mozilla.firefox',
      //       'com.microsoft.emmx',
      //     ],
      //     animation: CustomTabsSystemAnimation.slideIn(),
      //   ),
      //   safariVCOption: SafariViewControllerOption(
      //     preferredBarTintColor: AppTheme.appTheme.primaryColor,
      //     preferredControlTintColor: AppColors.white,
      //     barCollapsingEnabled: true,
      //     entersReaderIfAvailable: false,
      //     dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
      //   ),
      // );
    } catch (e) {
      LoggingService.error(
        'Error at Method:inAppBrowserLauncher -- Networking_service.dart',
        [e, StackTrace.current],
      );
    }
  }

  //*==================================================
  Future<void> openInAppBrowser(
    String url,
  ) async {
    const String errorCode = '${APIHelper.timeoutExceptionCode}';
    try {
      if (hasNetwork) {
        await inAppBrowserLauncher(
          url: url,
        );

        // device is not online
      } else {
        throw PlatformException(
          code: errorCode,
          message: 'network_lost'.tr,
        );
      }
    } catch (e) {
      LoggingService.error(
        'Error at Method:openInAppBrowser -- Networking_service.dart',
        e,
        StackTrace.current,
      );
      // something went wrong
      SnackBarHelper.showSnackBar(
        message: e is PlatformException
            ? e.message!
            : (AppConstants.somethingWentWrongText).tr,
        type: SnackBarType.error,
        errorCode: errorCode,
      );
    }
  }

  //*============================================================================
  //*============================================================================
}
