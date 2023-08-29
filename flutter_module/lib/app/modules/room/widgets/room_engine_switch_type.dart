import 'package:flutter/material.dart';
import 'package:flutter_module/app/core/utils/extensions.dart';
import 'package:get/get.dart';
import '../../../data/enums/meeting_type.dart';
import '../../../data/models/room/room_model.dart';
import '../../../themes/app_text_theme.dart';
import '../../../widgets/custom_spacer.dart';
import '../../../widgets/text/custom_text.dart';
import '../controllers/rooms_controller.dart';
import 'engine_switch_buttons.dart';

class RoomEngineSwitcher extends GetView<RoomsController> {
  //*================================ Properties ===============================
  final RoomModel? room;
  //*================================ Constructor ==============================
  const RoomEngineSwitcher({
    this.room,
    super.key,
  });

  //*================================= Methods =================================

  @override
  Widget build(BuildContext context) {
    //*================================ Properties =============================
    const double customSpacerHeightFactor = 0.005;
    final horizontalPadding = (0.05).wf;
    //*=========================================================================
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Align(
            alignment: AlignmentDirectional.topStart,
            child: CustomText(
              'set_room_type'.tr,
            ),
          ),
        ),
        const CustomSpacer(
          heightFactor: customSpacerHeightFactor,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 0.02.wf),
          child: Obx(
            () => EngineSwitchButtons(
              isMeet: (room == null
                      ? controller.isDefultEngieTypeMeet
                      : (room?.engineType == MeetingType.meet))
                  .obs
                  .value,
              onClassRoomPressed: () {
                controller.onChangeRoomDefultEngieType(
                    engineType: MeetingType.classroom, room: room);
              },
              onMeetPressed: () {
                controller.onChangeRoomDefultEngieType(
                    engineType: MeetingType.meet, room: room);
              },
            ),
          ),
        ),

        //* Room Engine Type Description
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomText(
            'defult_engine_text_description'.tr,
            textAlign: TextAlign.start,
            maxFontSize: 12,
            minFontSize: 9,
            maxLines: 2,
            style: AppTextTheme.smallLightBodyText2,
          ),
        ),
      ],
    );
  }
  //*===========================================================================
}
