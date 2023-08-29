import 'package:flutter/material.dart';
import 'package:flutter_module/app/core/utils/extensions.dart';
import 'package:flutter_module/app/modules/room/widgets/room_links.dart';
import 'package:get/get.dart';
import '../../../core/values/app_images_paths.dart';
import '../../../data/enums/meeting_type.dart';
import '../../../data/models/room/room_model.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_text_theme.dart';
import '../../../widgets/custom_card.dart';
import '../../../widgets/custom_selectable_text.dart';
import '../../../widgets/custom_spacer.dart';
import '../../../widgets/custom_svg.dart';
import '../../../widgets/disabled_overlay.dart';
import '../../../widgets/text/custom_text.dart';
import '../controllers/rooms_controller.dart';

class RoomCard extends GetView<RoomsController> {
  //*=============================== Properties ================================
  final RoomModel room;
  //*=============================== Constructor ===============================
  const RoomCard(
    this.room, {
    Key? key,
  }) : super(key: key);
  //*================================ Methods ==================================
  @override
  Widget build(BuildContext context) {
    //*================================ Properties =============================
    const double customSpacerHeight2 = 18.0;
    const double contentHorizontalPaddingFactor = 0.055;
    const double contentVerticalPaddingFactor = 0.015;
    final cardHorizontalMargin = (0.08).wf;
    // My Formula for dynamically deciding the [MaxLines] or [Height] of the
    // description field
    final maxLines = ((room.description.length) ~/ 50) + 2;
    final titleTextStyle = AppTextTheme.boldBodyText2;

    //*=========================================================================
    return CustomCard(
      cardBorderRadius: 13,
      contentHorizontalPaddingFactor: contentHorizontalPaddingFactor,
      contentVerticalPaddingFactor: contentVerticalPaddingFactor,
      hoizontalMargin: cardHorizontalMargin,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  //* Title
                  Flexible(
                    child: Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: CustomText(
                        room.title,
                        style: titleTextStyle,
                      ),
                    ),
                  ),
                  const CustomSpacer(widthFactor: 0.006),
                  //* Action Button
                  IconButton(
                    padding: EdgeInsets.zero,
                    color: AppColors.grey,
                    constraints: const BoxConstraints(),
                    icon: const Icon(Icons.more_vert),
                    onPressed: () {
                      controller.onRoomActionPressed(room);
                    },
                  ),
                ],
              ),
              //* Room Engine Type
              Row(
                children: [
                  CustomSvg(
                    svgPath: room.engineType == MeetingType.classroom
                        ? AppImagesPaths.classroomIcon
                        : AppImagesPaths.meetIcon,
                    heightFactor: 0.015,
                    color: AppColors.primaryColor,
                  ),
                  const CustomSpacer(
                    widthFactor: 0.008,
                  ),
                  CustomText(
                    room.engineType.name,
                    style: AppTextTheme.smallPrimaryBodyText2,
                  ),
                ],
              ),

              //* Description
              const CustomSpacer(height: customSpacerHeight2),
              CustomSelectableText(
                room.description,
                maxLines: maxLines,
              ),

              //* Room Links
              const CustomSpacer(height: customSpacerHeight2),
              RoomLinks(
                attendeeLink: room.attendeeLink,
                moderatorLink: room.moderatorLink,
                roomTitle: room.title,
              ),
            ],
          ),

          //* Locking Widget
          if (!room.isActive) const DisabledOverlay(),
        ],
      ),
    );
  }
  //*===========================================================================
  //*===========================================================================
}
