import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_common/get_reset.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';
// import 'package:share_plus/share_plus.dart';

import '../../data/enums/snack_bar_type.dart';
import '../../data/models/room/room_settings_model.dart';

import '../../routes/app_pages.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_theme.dart';
import '../../widgets/custom_bottom_sheet.dart';
import '../../widgets/loader.dart';
import '../utils/app_keys.dart';
import '../utils/design_utils.dart';
import '../utils/dialog_helper.dart';
import '../utils/localization_service.dart';
import '../utils/logging_service.dart';
import '../values/app_constants.dart';
import 'snackbar_helper.dart';

class Helpers {
  //!===========================================================================
  //!================================ Constructor ==============================
  //!===========================================================================
  static final Helpers _singleton = Helpers._internal();
  factory Helpers() {
    return _singleton;
  }
  Helpers._internal();
  //!===========================================================================
  //!================================ Parameters ===============================
  //!===========================================================================
  //!===========================================================================
  //!================================= Methods =================================
  //!===========================================================================
  static Future<void> initApp() async {
    // Make sure the Flutter Engine is fully initialized
    WidgetsFlutterBinding.ensureInitialized();

    // await Future.wait(
    //   [
    //     Firebase.initializeApp(),

    //     // to avoid unnecessary initializtions at [NotificationService]
    //     AuthService().onHasLaunchedAppBefore(),

    //     AppsFlyerService.init()
    //   ],
    // );

    final futureList = [
      // LocalizationService.checkForPreferredLanguage(),
      // To Decide where to send the user
      // AuthService().readRefreshToken(),
      // the below line restricts my app to ONLY USE PORTRAIT MODE.
      setAppOrientation(Orientation.portrait),
      // Prevent screen sleeping onAndroid and iOS.
      // Wakelock.enable(),
      // NotificationService.init(
      //   AuthService().hasLaunchedAppBefore,
      // ),
      // File Downloader
      // FlutterDownloader.initialize(),
      _registerGoogleFontsLicences(),
    ];

    await Future.wait(futureList);

    // if (!kDebugMode) {
    //   CrashlyticsService.init();
    // }

    // Helpers.changeSystemUIColor();

    // setting up the app theme
    AppTheme.updateAppTheme();
  }

  // //!==================================================
  static Future<void> _registerGoogleFontsLicences() async {
    for (var i = 0; i < 2; i++) {
      LicenseRegistry.addLicense(() async* {
        final license =
            await rootBundle.loadString('assets/google_fonts/OFL_$i.txt');
        yield LicenseEntryWithLineBreaks(['google_fonts'], license);
      });
    }
  }

  //!==================================================
  static Future<void> setAppOrientation(
      [Orientation? desiredOrientation]) async {
    switch (desiredOrientation) {
      case Orientation.portrait:
        // the below line restricts my app to ONLY USE PORTRAIT MODE.
        await SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
        break;
      case Orientation.landscape:
        // the below line restricts my app to ONLY USE LANDSCAPE MODE.
        await SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
        break;
      default:
        // if (desiredOrientation) is null, then I want full access.
        await SystemChrome.setPreferredOrientations(
          DeviceOrientation.values,
        );
    }
  }

  //!==================================================
  static void changeSystemUIColor({
    Color? statusBarColor,
    Color? systemNavigationBarColor,
  }) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: statusBarColor ?? AppColors.transparent,
        systemNavigationBarColor:
            systemNavigationBarColor ?? AppColors.primaryColor,
      ),
    );
  }

  // [Methods] that are globally used.
  static void throwError({
    String code = 'ERROR',
    String message = '',
  }) {
    throw PlatformException(
      code: code,
      message: message == '' ? 'something_went_wrong_text'.tr : message,
    );
  }

  //!==================================================
  static void hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  //!==================================================
  static Future<void> copyTextToClipboard(
    String copyText, {
    String? message,
  }) async {
    try {
      // copy the text to clipboard
      await Clipboard.setData(ClipboardData(text: copyText));
      message ??= 'text_copied_to_clipboard'.tr;
      // notify the user
      SnackBarHelper.showSnackBar(
        message: message,
        type: SnackBarType.action,
        borderRadius: 25.0,
        horizontalMarginFactor: 0.03,
      );
    } catch (e) {
      LoggingService.error(
        'Error at Method:copyTextToClipboard -- helpers.dart',
        e,
        StackTrace.current,
      );
    }
  }

  //!==================================================
  static Future<dynamic> openBottomSheet({
    Widget? firstBottomSheetChild,
    Widget? secondBottomSheetChild,
    RxBool? isSecondChildVisible,
    Duration enterAnimationDuration = const Duration(milliseconds: 200),
    Duration exitAnimationDuration = const Duration(milliseconds: 200),
    double elevation = 4.0,
    Color backgroundColor = AppColors.white,
    bool isDismissible = false,
    Widget? bottomSheet,
    ShapeBorder? shape,
    bool isScrollControlled = false,
    bool enableDrag = false,
  }) async {
    await Get.bottomSheet(
      bottomSheet ??
          Obx(
            () => CustomBottomSheet(
              firstBottomSheetChild: firstBottomSheetChild!,
              secondBottomSheetChild: secondBottomSheetChild!,
              isSecondChildVisible: isSecondChildVisible!.value,
            ),
          ),
      isScrollControlled: isScrollControlled,
      enableDrag: enableDrag,
      backgroundColor: backgroundColor,
      elevation: elevation,
      shape: shape ?? DesignUtils.getRoundedRectangleBorder(),
      isDismissible: isDismissible,
      enterBottomSheetDuration: enterAnimationDuration,
      exitBottomSheetDuration: exitAnimationDuration,
    );
  }

  //!============================================
  static Future<void> dismissSuccessBottomSheet() async {
    try {
      Get.back();
      // to not show the first bottom sheet child to the user while
      //  the bottom childs are being changed.
      await Future.delayed(const Duration(milliseconds: 300));
    } catch (e) {
      LoggingService.error(
        'Error at Method:dismissSuccessBottomSheet -- Helpersdart',
        e,
        StackTrace.current,
      );
    }
  }

  //!============================================
  static EdgeInsets get paymentViewPadding => EdgeInsets.symmetric(
        horizontal: DesignUtils.getDesignFactor(0.032),
      );

  //!==================================================
  static Future<void> lockUI({
    double sizeFactor = 0.16,
  }) async {
    await Get.dialog(
      // I need [Center] for the SizeFactor to have an effect
      Center(
        child: Loader(
          sizeFactor: sizeFactor,
        ),
      ),
      barrierDismissible: false,
    );
  }

  //!==================================================
  static void dismissOverlays({
    bool closeOverlays = false,
  }) {
    Get.back(
      closeOverlays: closeOverlays,
    );
  }

  //*==================================================

  static Future<void> onShareData(
    String text, {
    String? subject,
    Rect? sharePositionOrigin,
  }) async {
    try {
      // await Share.share(
      //   text,
      //   subject: subject,
      //   sharePositionOrigin: sharePositionOrigin,
      // );
    } catch (e) {
      LoggingService.error(
        'Error at Method:onShareData -- helpers.dart',
        e,
        StackTrace.current,
      );
    }
  }

  //*==================================================
  static void exitView({required String routeName}) {
    AppKeys.customNavigatorsKeysMap[routeName]?.currentState?.pop();
  }

  //*==================================================
  static Future<bool> onCancelPrompt({
    required bool hasChanges,
    required String baseRouteName,
  }) async {
    bool isSure = true;

    if (hasChanges) {
      isSure = await DialogHelper.confirmDialog(
        content: 'if_you_dont_save_any_changes_will_be_discarded'.tr,
        applyText: 'discard_changes'.tr,
        dismissText: 'keep_editing'.tr,
      );
    }

    if (isSure) {
      Helpers.exitView(routeName: baseRouteName);
    }
    return isSure;
  }

  //*==================================================
  static void logAndShowError({
    required dynamic error,
    required String methodName,

    /// Without the [.dart]
    required String fileName,
  }) {
    LoggingService.error(
      'Error at Method:$methodName -- $fileName.dart',
      error,
      StackTrace.current,
    );

    final errorMessage = (error is PlatformException || error is StateError
        ? error.message!
        : (AppConstants.somethingWentWrongText.tr));

    SnackBarHelper.showSnackBar(
      message: errorMessage,
      type: SnackBarType.error,
    );
  }

  //*==================================================
  static String getLinkSharingMessage({
    String? roomTitle,
    String? role,
    String? meetingTitle,
    String? meetingID,
    String? password,
    String? link,
  }) {
    final header = '${'Come_join_me_at_my_V.Connct_meeting'.tr}\n\n';

    final passwordText =
        (password?.isEmpty ?? true) ? '' : ('${'password'.tr}: $password\n');

    final body = (role != null)
        ? '${'room_title'.tr}: $roomTitle\n'
            '${'role'.tr}: $role\n'
        : '${'meeting_title'.tr}: $meetingTitle\n'
            '${'meeting_code'.tr}: $meetingID\n'
            '$passwordText';

    final footer = '\n${'Join_V.Connct_Meeting'.tr}\n'
        '$link';

    return header + body + footer;
  }

  //*==================================================
  static String getSharingVideoMessage({
    String? videoTitle,
    String? link,
  }) {
    final header = '${'Check_out_this_insightful_video_on'.tr}\n';

    final body = '"$videoTitle"\n';
    final footer = '${'from_vconnct_vid'.tr}\n'
        '$link';

    return header + body + footer;
  }

  //*==================================================
  /// To Get Room Settings
  static List<RoomSettingsModel>? extractRoomSettingsFromJson(
      apiMeetingSettingList) {
    if (apiMeetingSettingList == null) return null;

    return apiMeetingSettingList.map<RoomSettingsModel>(
      (jsonSetting) {
        var test = RoomSettingsModel.fromJson(jsonSetting);
        return test;
      },
    ).toList();
  }

  //*==================================================
  /// To Get The Meeting Settings For Edite
  static RoomSettingsModel? extractMeetingSettingsFromJson(
      apiMeetingSettingList, String engineType) {
    if (apiMeetingSettingList == null) return null;

    var jsonSetting = {
      'engine': engineType,
      'settings': apiMeetingSettingList,
    };
    return RoomSettingsModel.fromJson(jsonSetting);
  }

  //*==================================================
  static Future<bool> exitApp() async {
    var shouldExit = await DialogHelper.confirmDialog(
      exitAppAlert: true,
    );
    if (shouldExit) {
      await SystemNavigator.pop();
      if (Platform.isAndroid) exit(0);
      return true;
    }
    return false;
  }

  //!==================================================
  static Future<void> restartApp() async {
    try {
      await Get.deleteAll(
        force: true,
      );
      Get.reset();
    } catch (e) {
      LoggingService.error(
        'Error at Method:restartApp -- authenticatoin_service.dart',
        e,
        StackTrace.current,
      );
      // push the error screen if logout is unsuccessful
      await Get.offAllNamed(
        Routes.error,
      );
    }
  }

  //!==================================================
  bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 650;
  bool isTab(BuildContext context) =>
      MediaQuery.of(context).size.width < 1300 &&
      MediaQuery.of(context).size.width >= 600;
  //!==================================================
  static String formatPrice({required price}) {
    NumberFormat formatPrice = NumberFormat.decimalPattern(
        LocalizationService.appLanguage.localeLangCode);
    return formatPrice.format(price);
  }

  //!===========================================================================
}
