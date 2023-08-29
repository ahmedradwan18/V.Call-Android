import 'package:flutter/material.dart';
import 'package:flutter_module/app/core/utils/extensions.dart';
import 'package:flutter_module/app/widgets/text/custom_text.dart';
import 'package:flutter_module/app/widgets/textfields/read_only_text_field.dart';
import 'package:get/get.dart';
import '../core/values/app_constants.dart';
import '../data/typedefs/app_typedefs.dart';
import '../themes/app_text_theme.dart';
import 'close_icon.dart';
import 'creation_sheet_buttons.dart';
import 'custom_spacer.dart';

class MeetingCreationBottomSheet extends StatefulWidget {
  //*================================ Properties ===============================
  final dynamic meeting;
  final FutureVoidCallback onRunMeeting;
  final GlobalKey shareWidgetKey;

  //*================================ Constructor ==============================
  const MeetingCreationBottomSheet({
    required this.meeting,
    required this.onRunMeeting,
    Key? key,
    required this.shareWidgetKey,
  }) : super(key: key);
  //*================================ State ====================================
  @override
  State<MeetingCreationBottomSheet> createState() =>
      _MeetingCreationBottomSheetState();
  //*===========================================================================
}

class _MeetingCreationBottomSheetState extends State<MeetingCreationBottomSheet>
    with SingleTickerProviderStateMixin {
  //*===========================================================================
  //*============================= State  Methods ==============================
  //*===========================================================================
  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: AppConstants.longDuration,
    )..repeat(reverse: true);

    animation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeInOutQuad,
      ),
    );
  }

  //*==================================================
  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  //*===========================================================================
  //*================================= Methods =================================
  //*===========================================================================
  late final AnimationController animationController;
  late final Animation<double> animation;
  var isLoading = false;

  static const double customSpacerHeightFactor1 = 0.03;
  static const double customSpacerHeightFactor2 = 0.02;
  static const double customSpacerHeightFactor3 = 0.01;
  static const double customSpacerHeightFactor4 = 0.08;
  static const int descriptioneMaxLines = 2;
  static const bool textUseTextOverflow = true;
  static const TextAlign textAlign = TextAlign.center;
  static const int titleMaxLines = 1;

  final titleTextStyle = AppTextTheme.boldBodyText1;
  final descriptionTextStyle = AppTextTheme.w300ItalicBodyText2;
  final description = 'meeting_created_success_description'.tr;
  final title = 'meeting_created_success'.tr;
  final descriptionHorizontalPadding = (0.075).wf;
  final closeIconSize = (0.03).hf;
  //*===========================================================================
  //*================================= Methods =================================
  //*===========================================================================
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Get.back(closeOverlays: true);
        return Future.value(false);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          //* Header [Icon + Title]
          Padding(
            padding: EdgeInsetsDirectional.only(
              start: (0.04).wf,
              top: (0.02).hf,
              bottom: (0.015).hf,
            ),
            child: Align(
              alignment: const AlignmentDirectional(-1, 0),
              child: CloseIcon(
                onTap: () => Get.back(closeOverlays: true),
                size: closeIconSize,
              ),
            ),
          ),

          //* Title
          Flexible(
            child: CustomText(
              title,
              style: titleTextStyle,
              maxLines: titleMaxLines,
              useTextOverflow: true,
              textAlign: textAlign,
            ),
          ),

          //* Description
          const CustomSpacer(heightFactor: customSpacerHeightFactor1),
          Flexible(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: descriptionHorizontalPadding,
              ),
              child: CustomText(
                description,
                style: descriptionTextStyle,
                maxLines: descriptioneMaxLines,
                useTextOverflow: textUseTextOverflow,
                textAlign: textAlign,
              ),
            ),
          ),

          //* Share Field
          const CustomSpacer(heightFactor: customSpacerHeightFactor2),
          ReadOnlyTextField(
            text: widget.meeting.link,
            copyText: 'share_link'.tr,
            horizontalPadding: (0.075).wf,
          ),

          //* Buttons
          const CustomSpacer(heightFactor: customSpacerHeightFactor3),
          CreationSheetButtons(
            meeting: widget.meeting,
            onRunMeeting: () async {
              setState(() {
                isLoading = true;
              });
              Get.back();
              await widget.onRunMeeting();
              setState(() {
                isLoading = false;
              });
            },
            animation: animation,
            isLoading: isLoading,
            shareWidgetKey: widget.shareWidgetKey,
          ),
          const CustomSpacer(heightFactor: customSpacerHeightFactor4),
        ],
      ),
    );
  }
  //*=========================================================================
  //*=========================================================================
}
