import 'dart:async';
import 'dart:io';
import 'dart:ui';

// import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:simple_pip_mode/simple_pip.dart';
import '../../../core/helpers/meeting_helper.dart';
import '../../../core/helpers/snackbar_helper.dart';
import '../../../core/utils/dialog_helper.dart';
import '../../../core/utils/logging_service.dart';
import '../../../core/values/app_constants.dart';
import '../../../core/values/app_images_paths.dart';
import '../../../core/values/environment.dart';
import '../../../data/enums/requestable_feature.dart';
import '../../../data/enums/snack_bar_type.dart';
import '../../../data/models/meeting/classroom_meeting_model.dart';
import '../../../data/models/vlc_view_arguments.dart';
import '../widgets/dialog_web_view.dart';
import '../widgets/enter_pip_widget.dart';
import '../widgets/meeting_floating_button.dart';
import '../widgets/tool_button.dart';

class VlcController extends GetxController with WidgetsBindingObserver {
  //!===========================================================================
  //!=========================== Controller Methods ============================
  //!===========================================================================
  @override
  void onInit() {
    super.onInit();
    arguments = Get.arguments as VlcViewArugumets;

    //! Currently not available on [IOS]
    if (Platform.isAndroid) {
      WidgetsBinding.instance.addObserver(this);
      _initializePictureInPicture();
    }

    // _initializeConnectivityListener();

    _initializeFloatingList();
  }

  //!==================================================
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state != AppLifecycleState.resumed && !isLoadingInternally) {
      onPipModeRequested();
    }
  }

  //!==================================================
  void _initializePictureInPicture() {
    // pipManager = SimplePip();

    // futureIsPipAvailable = SimplePip.isPipAvailable.then(
    //   (isAvailable) => isPipAvailable = isAvailable,
    // );
  }

  //*==================================================
  // void _initializeConnectivityListener() {
  //   _connectivitySubscription =
  //       _connectivity.onConnectivityChanged.listen(_onConnectionStatusChanged);
  // }

  // //*==================================================
  // void _onConnectionStatusChanged( event) {
  //   // Only handle that at first-run, otherwise let the server handle any
  //   // connection drop.
  //   if (!isLoadingInternally && !forceReload) return;

  //   if (event == ConnectivityResult.none) {
  //     forceReload = true;
  //   } else {
  //     Future.delayed(const Duration(seconds: 3)).whenComplete(
  //       () => reloadVlc().whenComplete(() => forceReload = false),
  //     );
  //   }
  // }

  //*==================================================
  // UI is rendered on the main isolate, while download events come from the
  // background isolate (in other words, code in callback is run in the
  // background isolate), so you have to handle the communication between
  // two isolates

  //!==================================================
  void _initializeFloatingList() async {
    var camera = await Permission.camera.isGranted;

    var mic = await Permission.microphone.isGranted;

    floatingButtonIconList = [
      if (!camera)
        ToolButton(
          onPressed: () async =>
              await enableFeature(RequestableFeatures.camera),
          svgPath: AppImagesPaths.cameraSvg,
          tooltip: 'enable_camera'.tr,
        ),
      if (!mic)
        ToolButton(
          onPressed: () async =>
              await enableFeature(RequestableFeatures.microphone),
          svgPath: AppImagesPaths.microphoneSvg,
          tooltip: 'enable_microphone'.tr,
        ),
      ToolButton(
        onPressed: () async => await reloadVlc(),
        svgPath: AppImagesPaths.refreshSvg,
        tooltip: 'reload_vlc'.tr,
      ),
      if (Platform.isAndroid)
        EnterPIPWidget(
          isPipAvailable: futureIsPipAvailable,
          onPressed: onPipModeRequested,
        ),
      ToolButton(
        onPressed: () async => await onShareMeeting(
          meeting: arguments.meeting!,
        ),
        svgPath: AppImagesPaths.shareSvg,
        tooltip: 'share_meeting'.tr,
      ),
      ToolButton(
        onPressed: () async {
          await exitVlcView();
        },
        svgPath: AppImagesPaths.exitMeetingSvg,
        tooltip: 'exit'.tr,
      ),
    ];
  }

  //!==================================================
  @override
  void onClose() {
    hideFloatingButton();
    if (Platform.isAndroid) {
      WidgetsBinding.instance.removeObserver(this);
    }
    // _connectivitySubscription.cancel();
    super.onClose();
  }

  //*===========================================================================
  //*================================ Properties ===============================
  //*===========================================================================
  late final VlcViewArugumets arguments;

  // Picture in picutre [pip] properties
  // late final SimplePip pipManager;
  // For [PIP] Widget
  late final Future<bool> futureIsPipAvailable;
  late bool isPipAvailable;

  // not final to use [Expand] feture
  late final InAppWebViewController inAppWebViewController;

  final shareWidgetKey = GlobalKey();

  late final List<Widget> floatingButtonIconList;

  /// Used to identify when the [Load Balancer] has finished calling it's
  /// API(s)
  final _isLoadingInternally = true.obs;

  /// so that if the network goes out during loading, re-load on re-connection
  // final Connectivity _connectivity = Connectivity();
  // late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  late String meetingUrl;
  bool forceReload = false;

  // the loadbalancer redirects me multiple times(2) until I reach my last url
  // which has the built-in loader, so until I reach it I should keep my
  // custom loader
  int androidKeepInternalLoaderCount =
      AppConstants.environment == Environments.production ? 2 : 1;

  final _hasLoadingError = false.obs;

  OverlayEntry? overlayEntry;

  //*===========================================================================
  //*============================= Setters/Getters =============================
  //*===========================================================================
  final _downloadPercentage = (0).obs;
  int get downloadPercentage => _downloadPercentage.value;
  set downloadPercentage(int newValue) => _downloadPercentage(newValue);

  bool get isLoadingInternally => _isLoadingInternally.value;
  set isLoadingInternally(bool newValue) => _isLoadingInternally(newValue);

  bool get hasLoadingError => _hasLoadingError.value;
  set hasLoadingError(bool newValue) => _hasLoadingError(newValue);

  //*===========================================================================
  //*================================= Methods =================================
  //*===========================================================================

  Future<bool> exitVlcView({bool shouldAlert = true}) async {
    try {
      if (shouldAlert) {
        if (!await alertVlcExit()) return false;
      }

      hideFloatingButton();

      // clear everything, this is the way to [disponse] of the
      // inAppWebViewController, the [Webview] itself is a widget, so it's
      // life time is handled by [Navigator.push/pop]
      await inAppWebViewController.stopLoading();
      await inAppWebViewController.clearFocus();

      // return to the calling Navigator [Nested Navigation]
      // If I can pop, then i'm in the miniView [NestedView], just pop
      Get.back();

      return true;
    } catch (e) {
      LoggingService.error(
        'Error at Method:exitVlcView -- video_details_controller.dart',
        e,
        StackTrace.current,
      );
      Get.back(closeOverlays: true);
      return false;
    }
  }

  //*==================================================
  Future<bool> alertVlcExit() async {
    bool shouldExit = false;
    await DialogHelper.confirmDialog(
      content: 'exit_vlc_dialog_title'.tr,
      onApply: () {
        Get.back();
        shouldExit = true;
      },
      dismissText: 'cancel'.tr,
      applyText: 'exit'.tr,
    );
    return shouldExit;
  }

  //*=================================================
  Future<void> reloadVlc() async {
    try {
      //LOG
      LoggingService.information(
        'User Reloaded VlcView',
      );

      //show snackbar
      SnackBarHelper.showSnackBar(
        message: 'reloading'.tr,
        type: SnackBarType.action,
      );

      // reload
      // show my layer on top of the url's loading indicator
      hasLoadingError = false;
      isLoadingInternally = true;
      if (forceReload) {
        await inAppWebViewController.loadUrl(
          urlRequest: URLRequest(
            url: Uri.tryParse(meetingUrl),
          ),
        );
      } else {
        await inAppWebViewController.reload();
      }
    } catch (e) {
      LoggingService.error(
        'Error at Method:reloadVlc -- video_details_controller.dart',
        e,
        StackTrace.current,
      );
    }
  }

  //*==================================================
  Future<void> enableAllFeatures() async {
    try {
      //* Dont request multiple permisisons at the same time with Future.wait
      //* the package has it's own way of doing that
      await enableFeature(RequestableFeatures.camera);
      await enableFeature(RequestableFeatures.microphone);
    } catch (e) {
      LoggingService.error(
        'Error at Method:enableAllFeatures -- video_details_controller.dart',
        e,
        StackTrace.current,
      );
    }
  }
  //*==================================================

  /// [Camera], [Mic] etc...
  Future<PermissionStatus> enableFeature(RequestableFeatures feature) async {
    try {
      // Decide on which feature i'm currently requesting.
      final PermissionStatus featureStatus = await _getFeatureStatus(feature);

      // Decide on what string to show at snackbar.
      var snackBarMessage = '';
      var snackBarType = SnackBarType.error;

      switch (featureStatus) {
        // The user denied access to the requested feature.
        case PermissionStatus.denied:
          snackBarMessage = '${feature.featureName}_access_deined'.tr;
          break;

        // The user granted access to the requested feature.
        case PermissionStatus.granted:
        //User has authorized this application for limited access.
        // *Only supported on iOS (iOS14+).*
        case PermissionStatus.limited:
          snackBarType = SnackBarType.action;
          break;

        // The OS denied access to the requested feature. The user cannot
        // change this app's status, possibly due to active restrictions such
        // as parental controls being in place.
        // *Only supported on iOS.*
        case PermissionStatus.restricted:
          snackBarMessage = '${feature.featureName}_access_restricted'.tr;
          break;

        default:
      }

      if (snackBarMessage.isNotEmpty) {
        SnackBarHelper.showSnackBar(
          message: snackBarMessage,
          type: snackBarType,
        );
      }
      return featureStatus;
    } catch (e) {
      LoggingService.error(
        'Error at Method:enableFeature -- video_details_controller.dart',
        e,
        StackTrace.current,
      );
      return PermissionStatus.denied;
    }
  }

  //*==================================================
  /// Decide on which feature i'm currently requesting access to.
  Future<PermissionStatus> _getFeatureStatus(
      RequestableFeatures feature) async {
    switch (feature) {
      case RequestableFeatures.camera:
        return Permission.camera.request();
      case RequestableFeatures.microphone:
        return Permission.microphone.request();
      case RequestableFeatures.storage:
        return Permission.storage.request();
      default:
        return Permission.camera.request();
    }
  }

  //*==================================================
  Future<void> onPipModeRequested() async {
    try {
      if (Platform.isIOS || !isPipAvailable) return;

      // await pipManager.enterPipMode(
      //   seamlessResize: true,
      //   aspectRatio: [3, 2],
      // );
    } catch (e) {
      LoggingService.error(
        'Error at Method:onPipModeChanged -- video_details_controller.dart',
        e,
        StackTrace.current,
      );
      isPipAvailable = false;
    }
  }

  //*==================================================
  void openInAppWebBottomSheet({
    required Uri uri,
    required BuildContext context,
  }) {
    inAppWebViewController.stopLoading();
    DialogHelper.showCupertinoPopup(
      context: context,
      child: DialogWebView(uri: uri),
    );
  }

  //*==================================================
  void onWebViewCreated({
    required InAppWebViewController controller,
    required String url,
  }) {
    inAppWebViewController = controller;
    meetingUrl = url;
  }

//*==================================================
  Future<void> injectedNavigationFunction({
    required Uri uri,
    required BuildContext context,
  }) async {
    // Check if the user is going to the 'Redirect Url'
    final exitString1 = AppConstants.environment.exitMeetingRedirectUrl;
    const String exitString2 = 'sso';

    final link = uri.toString().toLowerCase();
    if (link.contains(exitString1) || link.contains(exitString2)) {
      await exitVlcView(shouldAlert: false);
    }

    // Open the breakout room in an external tab.
    else if (link.contains('isBreakout=true') ||
        link.contains('vconnct.me/help') ||
        link.contains('learning-analytics-dashboard')) {
      openInAppWebBottomSheet(
        uri: uri,
        context: context,
      );
    }
  }

  //*==================================================
  /// Used to identify when the [Load Balancer] has finished calling it's
  /// API(s), and the loading of the actual meeting link has begun, to give
  /// the user a visual re-presentation of what's happening
  void onLoadStopped(
    InAppWebViewController controller,
    Uri? uri,
    BuildContext? context,
  ) {
    if (androidKeepInternalLoaderCount != 0 && Platform.isAndroid) {
      androidKeepInternalLoaderCount--;
      return;
    }
    isLoadingInternally = false;
    if (!hasLoadingError) {
      showFloatingButton(
        context: context!,
      );
    }
  }

  //*==================================================
  void onLoadError(
    InAppWebViewController controller,
    Uri? url,
    int code,
    String message,
  ) {
    LoggingService.error(
      '[$code] Error at Method:onLoadError -- video_details_controller.dart\n$message',
      null,
      StackTrace.current,
    );
    isLoadingInternally = false;
    hasLoadingError = true;
  }

  //*==================================================
  Future<void> onShareMeeting({
    required ClassroomMeetingModel meeting,
  }) async =>
      await MeetingHelper.onShareMeeting(
        meeting: meeting,
      );
  //*==================================================
  void showFloatingButton({
    required BuildContext context,
  }) {
    if (overlayEntry != null) return;

    overlayEntry = OverlayEntry(
      builder: (_) => MeetingFloatingButton(
        iconList: floatingButtonIconList,
      ),
    );

    Overlay.of(context).insert(overlayEntry!);
  }

  //*==================================================
  void hideFloatingButton() {
    overlayEntry?.remove();
    overlayEntry = null;
  }
  //!===========================================================================
  //!===========================================================================
}
