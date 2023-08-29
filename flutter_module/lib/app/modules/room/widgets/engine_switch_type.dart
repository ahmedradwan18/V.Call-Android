import 'package:flutter/material.dart';
import 'package:flutter_module/app/core/utils/extensions.dart';
import 'package:get/get.dart';
import '../../../core/utils/design_utils.dart';
import '../../../data/models/room/room_model.dart';
import '../../../data/models/room/room_settings_model.dart';
import '../../../themes/app_colors.dart';
import '../../../widgets/text/custom_text.dart';
import '../controllers/rooms_controller.dart';

class EngineSwitchType extends GetView<RoomsController> {
  //*================================ Parameters ===============================
  final int? engineType;
  final RoomModel room;
  final List<RoomSettingsModel> settings;
  //*================================ Constructor ==============================
  const EngineSwitchType({
    this.engineType,
    required this.room,
    required this.settings,
    Key? key,
  }) : super(key: key);
  //*================================= Methods =================================

  @override
  Widget build(BuildContext context) {
    //*=============================== Parameters ==============================
    final customTheme = Theme.of(context).copyWith(
      tabBarTheme: TabBarTheme(
        // labelStyle: AppTextTheme.boldWhite15BodyText1,
        labelColor: AppColors.white,
        // unselectedLabelStyle: AppTextTheme.lightBodyText2,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          borderRadius: DesignUtils.getBorderRadius(radius: 15.0),
          color: AppColors.primaryColor,
        ),

        unselectedLabelColor: AppColors.grey,
      ),
    );

    //*=========================================================================
    return Container(
      height: 0.05.hf,
      width: 0.8.wf,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: AppColors.lightPrimaryColor,
      ),
      child: Theme(
        data: customTheme,
        child: TabBar(
          tabs: settings.map(
            (tabName) {
              return CustomText(tabName.meetingType.name);
            },
          ).toList(),
        ),
      ),
    );
  }
  //*===========================================================================
}
