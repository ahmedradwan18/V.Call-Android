import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/validation_service.dart';
import '../../../widgets/custom_drop_down_menu.dart';
import '../../../widgets/custom_spacer.dart';
import '../../../widgets/textfields/custom_text_field.dart';
import '../controllers/creation_controller.dart';
import 'meeting_date_picker copy.dart';
import 'time_picker.dart';

/// Contains some information about the [Meeting] .. [Title],[Time], etc..
class MeetingInfo extends GetView<CreationController> {
  //*================================ Properties ===============================
  final bool isCreate;
  //*================================ Constructor ==============================
  const MeetingInfo({
    this.isCreate = false,
    Key? key,
  }) : super(key: key);
  //*================================= Methods =================================

  @override
  Widget build(BuildContext context) {
    //*================================ Properties =============================
    const double customSpacerHeightFactor1 = (0.007);
    const double customSpacerHeightFactor2 = (0.014);
    const TextInputAction passwordFieldTextInputAction = TextInputAction.done;
    //*=========================================================================
    return SingleChildScrollView(
      child: Form(
        key: controller.createMeetingFormKey,
        child: Column(
          children: [
            CustomTextField(
              headerText: 'title'.tr,
              hintText: 'meeting_title_placeholder'.tr,
              onValidateHandler: ValidationService.validateMeetingTitle,
              // [val] is passed back from the [FormTextField], and with it I
              // call the appropriate function
              onChangedHandler: (val) =>
                  controller.editMeetingTemplate(title: val),
              textEditingController: controller.meetingTitleTextFieldController,
              onClearIconPressed: () {
                controller.editMeetingTemplate(title: '');
                controller.meetingTitleTextFieldController.clear();
              },
            ),
            // //* Password TextField
            // PasswordTextField(
            //   onChangedHandler: (val) =>
            //       controller.editMeetingTemplate(password: val),
            //   textEditingController:
            //       controller.meetingPasswordTextFieldController,
            //   textInputAction: passwordFieldTextInputAction,
            //   hintText: 'enter_meeting_password'.tr,
            //   onClearIconPressed: () {
            //     controller.editMeetingTemplate(password: '');
            //     controller.meetingPasswordTextFieldController.clear();
            //   },
            //   onValidateHandler: ValidationService.validateCreatMeetingPassword,
            //   isOptional: true,
            // ),
            const CustomSpacer(heightFactor: customSpacerHeightFactor1),

            //* Room List
            const CustomDropDownMenu(),
            const CustomSpacer(heightFactor: customSpacerHeightFactor2),

            if (!isCreate)
              const Column(
                children: [
                  //* DatePicker
                  MeetingDatePicker(),
                  CustomSpacer(heightFactor: customSpacerHeightFactor1),

                  //* TimePicker
                  TimePicker(),
                ],
              )
          ],
        ),
      ),
    );
  }
  //*===========================================================================
  //*===========================================================================
}
