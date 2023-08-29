// some parameters and methods regarding the Dialogs

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_module/app/core/utils/extensions.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../themes/app_colors.dart';
import '../../themes/app_text_theme.dart';
import '../../widgets/animated_slide_scale.dart';
import '../../widgets/buttons/custom_button.dart';
import '../../widgets/custom_animated_switcher.dart';
import '../../widgets/custom_asset_image.dart';
import '../../widgets/custom_spacer.dart';
import '../../widgets/pop_up/delete_prompt.dart';
import '../../widgets/text/custom_rich_text.dart';
import '../../widgets/text/custom_text.dart';
import '../values/app_constants.dart';
import '../values/app_images_paths.dart';
import 'localization_service.dart';
import 'logging_service.dart';

class DialogHelper {
  //!=============================== Constructor ===============================
  static final DialogHelper _singleton = DialogHelper._internal();

  factory DialogHelper() {
    return _singleton;
  }

  DialogHelper._internal();
  //!===========================================================================
  static Future<void> showAlertDialog({
    required String subTitle,
    required VoidCallback onApply,
    VoidCallback? onDismiss,
    String? title,
    bool isDismissible = true,
    String? applyText,
    String? dismissText,
    TextStyle? subtitleStyle,
    TextStyle? titleStyle,
    String? specialText,
    bool isDismissActionDangerous = false,
    bool isDismissActionPreferred = false,
    bool isApplyActionPreferred = false,
    bool isApplyActionDangerous = false,
  }) async {
    title ??= 'are_you_sure'.tr;
    dismissText ??= 'cancel'.tr;
    applyText ??= 'confirm'.tr;
    final textColor = Get.context?.theme.primaryColor;
    final textStyle = Get.context?.theme.textTheme.bodyLarge?.copyWith(
      color: textColor,
    );
    try {
      return showCupertinoDialog(
        context: Get.context!,
        barrierDismissible: isDismissible,
        builder: (context) => CupertinoAlertDialog(
          title: Text(title!),
          content: CustomRichText(
            // '.' to ensure splitting
            content: '$subTitle.',
            specialText: specialText,
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              isDestructiveAction: isDismissActionDangerous,
              isDefaultAction: isDismissActionPreferred,
              onPressed: onDismiss,
              textStyle: isDismissActionDangerous ? null : textStyle,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: (0.035).wf),
                child: Text(
                  dismissText!,
                ),
              ),
            ),
            CupertinoDialogAction(
              isDefaultAction: isApplyActionPreferred,
              isDestructiveAction: isApplyActionDangerous,
              onPressed: onApply,
              textStyle: isApplyActionDangerous ? null : textStyle,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: (0.01).wf),
                child: Text(
                  applyText!,
                ),
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      LoggingService.error(
        'Error at Method:showAlertDialog -- dialog_helper.dart',
        e,
        null,
      );
    }
  }

  //!==========================================================================
  // to keep things clean at the UI level, instead of calling it there
  // and also because I call it multiple times at various places.
  /// to override physical back button / gestures
  static Future<bool> confirmDialog({
    String? content,
    bool exitAppAlert = false,
    Color? dismissColor,
    String? applyText,
    String? dismissText,
    bool isDismissActionDangerous = false,
    bool isApplyActionDangerous = true,
    bool isApplyActionPreferred = false,
    VoidCallback? onDismiss,
    VoidCallback? onApply,
    String? specialText,
    bool isDismissActionPreferred = true,
  }) async {
    var willPop = false;
    content ??= 'delete_this'.tr;
    content = '$content\n';

    if (exitAppAlert) {
      content = 'exit_app_dialog_title'.tr;
      applyText = 'exit'.tr;
    }
    await DialogHelper.showAlertDialog(
      title: 'are_you_sure'.tr + _addNewLine(),
      onApply: onApply ??
          () {
            Get.back(closeOverlays: true);
            willPop = true;
          },
      subTitle: content,
      dismissText: dismissText,
      specialText: specialText,
      applyText: applyText,
      onDismiss: onDismiss ?? () => Get.back(),
      isDismissActionDangerous: isDismissActionDangerous,
      isApplyActionPreferred: isApplyActionPreferred,
      isApplyActionDangerous: isApplyActionDangerous,
      isDismissActionPreferred: isDismissActionPreferred,
    );
    return willPop;
  }

  //!=========================================================================

  static Future<void> showPopUp({
    Widget? header,
    Widget? content,
    Widget? child,
    Rx<bool>? isCelebration,
    EdgeInsetsGeometry headerPadding = EdgeInsets.zero,
    EdgeInsetsGeometry contentPadding = EdgeInsets.zero,
    Color? buttonColor,
    List<Widget>? actions,
    Color barrierColor = const Color(0x80000000),
    bool barrierDismissible = false,
    Color? backgroundColor,
    AlignmentGeometry? alignment,
    EdgeInsetsGeometry actionsPadding = EdgeInsets.zero,
    VerticalDirection? actionsOverflowDirection,
    MainAxisAlignment? actionsAlignment,
    OverflowBarAlignment? actionsOverflowAlignment,
    double? actionsOverflowButtonSpacing,
    Rx<String>? successText,
  }) async {
    return Get.generalDialog(
      barrierLabel: 'Choose',
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) => SafeArea(
        child: AnimatedSlideScaleWidget(
          animation: animation,
          startOffset: const Offset(1, 0),
          child: child ??
              Obx(
                () => CustomAnimatedSwitcher(
                  child: isCelebration!.value
                      ? AlertDialog(
                          title: Text(
                            successText!.value,
                            textAlign: TextAlign.center,
                            style: AppTextTheme.boldBodyText1,
                          ),
                          content: Lottie.asset(
                            AppImagesPaths.offerSuccessLottie,
                          ),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(16),
                            ),
                          ),
                          actions: [
                            Center(
                              child: SizedBox(
                                height: (0.06).hf,
                                width: (0.6).wf,
                                child: Padding(
                                  padding: EdgeInsetsDirectional.only(
                                      bottom: (0.01).hf),
                                  child: CustomButton(
                                    buttonStyle: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      backgroundColor: buttonColor,
                                    ),
                                    onPressed: () {
                                      Get.back();
                                      Future.delayed(
                                        const Duration(milliseconds: 100),
                                      ).then(
                                          (v) => isCelebration.value = false);
                                    },
                                    label: 'done'.tr,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : WillPopScope(
                          onWillPop: () => Future.value(false),
                          child: AlertDialog(
                            actionsAlignment: actionsAlignment,
                            actionsOverflowAlignment: actionsOverflowAlignment,
                            actionsOverflowButtonSpacing:
                                actionsOverflowButtonSpacing,
                            actionsOverflowDirection: actionsOverflowDirection,
                            actionsPadding: actionsPadding,
                            alignment: alignment,
                            content: content,
                            contentPadding: contentPadding,
                            title: header,
                            titlePadding: headerPadding,
                            insetPadding:
                                EdgeInsets.symmetric(horizontal: (0.06).wf),
                            actions: actions,
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16)),
                            ),
                            backgroundColor: backgroundColor,
                          ),
                        ),
                ),
              ),
        ),
      ),
    );
  }

  //!===========================================================================
  static Future<void> showCupertinoPopup({
    required BuildContext context,
    required Widget child,
    bool isbarrierDismissible = true,
  }) {
    return showCupertinoModalPopup(
      context: context,
      barrierDismissible: isbarrierDismissible,
      builder: (context) => child,
    );
  }

  //!===========================================================================

  static Future<void> goToUpCommingMeetings() {
    return confirmDialog(
      content: 'meeting_running_dialog_content'.tr,
      isApplyActionDangerous: false,
      isDismissActionDangerous: true,
      isDismissActionPreferred: false,
      isApplyActionPreferred: true,
      onApply: () {
        // const newPage = AppViews.meeting;
        // final pageViewController =
        //     Get.find<HomeController>().pageViewController;
        // Get.find<HomeController>().currentAppView = newPage;
        // pageViewController.jumpToPage(newPage.index);
        // Get.back(closeOverlays: true);
      },
      applyText: 'meeting_running_dialog_apply_text'.tr,
    );
  }

  //!===========================================================================
  static Future<T?> showDeletePrompt<T>({
    required String title,
    required String itemType,
  }) {
    return Get.generalDialog(
      barrierDismissible: true,
      // Required if I want the [BarrierDismissible] to be true
      barrierLabel: '',
      transitionDuration: AppConstants.shortDuration,
      pageBuilder: (_, animation, __) =>
          // use the provided animation, to animate the page into view.
          AnimatedSlideScaleWidget(
        animation: animation,
        startOffset: const Offset(1, 0),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: (0.1).wf,
            vertical: (0.285).hf,
          ),
          child: DeletePrompt(
            title: title,
            itemType: itemType,
          ),
        ),
      ),
    );
  }

  //!===========================================================================
  static Future<bool> cancleSubscriptionDialog(BuildContext context) async {
    bool isSure = false;
    await DialogHelper.showCupertinoPopup(
      context: context,
      isbarrierDismissible: true,
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 0.05.wf, vertical: 0.05.hf),
          // height: 0.45.hf,
          width: 0.9.wf,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: AppColors.white,
          ),
          child: Material(
            color: AppColors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CustomAssetImage(AppImagesPaths.warning),
                const CustomSpacer(
                  heightFactor: 0.01,
                ),
                CustomText(
                  'are_you_sure'.tr,
                  style: AppTextTheme.bold500BodyText1,
                ),
                const CustomSpacer(
                  heightFactor: 0.01,
                ),
                CustomText(
                  'please_keep_in_mind_that_if_you_take_this_action_your_current_package_will_no_longer_be_available'
                      .tr,
                  style: AppTextTheme.smallBodyText2,
                  textAlign: TextAlign.center,
                ),
                const CustomSpacer(
                  heightFactor: 0.01,
                ),
                CustomButton(
                  onPressed: () {
                    isSure = true;
                    Get.back();
                  },
                  label: 'yes_Im_sure'.tr,
                  backgroundColor: AppColors.primaryColor,
                  width: 0.6.wf,
                ),
                SizedBox(
                  width: 0.6.wf,
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    child: CustomText('cancel'.tr),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
    return isSure;
  }

  // Arabic font is bigger than english .. so this was added to adjust
  // the layout
  static String _addNewLine() =>
      (LocalizationService.languageCode == 'en' ? '\n' : '');
  //!===========================================================================
  //!===========================================================================
}
