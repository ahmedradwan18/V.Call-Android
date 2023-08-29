import 'package:flutter/material.dart';
import 'package:flutter_module/app/core/utils/extensions.dart';
import 'package:get/get.dart';

import '../../../core/helpers/auth_service.dart';
import '../../../core/utils/design_utils.dart';
import '../../../themes/app_colors.dart';
import '../../../widgets/text/custom_text.dart';
import '../controllers/rooms_controller.dart';
import 'my_rooms_page.dart';

class RoomChart extends GetView<RoomsController> {
  //*================================ Parameters ===============================
  final double heightFactor;
  final double cardElevation;
  final double cardHorizontalPaddingFactor;
  final double cardVerticalPaddingFactor;
  final double indicatorVerticalPaddingFactor;
  final double indicatorStrokeSize;
  //*================================ Constructor ==============================
  const RoomChart({
    Key? key,
    this.heightFactor = 0.1,
    this.cardElevation = 5,
    this.cardHorizontalPaddingFactor = 0.03,
    this.cardVerticalPaddingFactor = 0.02,
    this.indicatorVerticalPaddingFactor = 0.018,
    this.indicatorStrokeSize = 2,
  }) : super(key: key);
  //*================================ Methods ==================================
  @override
  Widget build(BuildContext context) {
    //*================================ Properties =============================
    const int textMaxLines = 2;
    const TextAlign textAlign = TextAlign.center;
    final userRoomCount = AuthService().userRoomsCount;
    final roomCountText = ('you_have_x_rooms'.tr).replaceFirst(
      '{x}',
      userRoomCount.toString(),
    );
    //*=========================================================================
    return Hero(
      tag: 'RoomCard',
      child: Card(
        shape: DesignUtils.getRoundedRectangleBorder(radius: 14.0),
        elevation: cardElevation,
        margin: EdgeInsets.symmetric(
          horizontal: (cardHorizontalPaddingFactor).hf,
          vertical: (cardVerticalPaddingFactor).hf,
        ),
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: (indicatorVerticalPaddingFactor).hf,
            horizontal: (0.06).wf,
          ),
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                child: Obx(
                  () => Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      SizedBox(
                        height: heightFactor.hf,
                        width: heightFactor.hf,
                        child: CircularProgressIndicator(
                          color: controller.isLoading
                              ? AppColors.green
                              : AppColors.grey,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.primaryColor,
                          ),
                          value:
                              userRoomCount / AuthService().userMaxRoomsCount,
                          backgroundColor: AppColors.lightGrey,
                          strokeWidth: indicatorStrokeSize,
                        ),
                      ),
                      CustomText(
                        '${AuthService().userRoomsCount} / '
                        '${AuthService().userMaxRoomsCount}\n'
                        '${AuthService().roomText}',
                        maxLines: textMaxLines,
                        textAlign: textAlign,
                      ),
                    ],
                  ),
                ),
              ),
              Flexible(
                child: CustomText(
                  roomCountText,
                ),
              ),
              InkWell(
                onTap: () {
                  controller.onCreateRoomButtonPressed();
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: AppColors.primaryColor,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(0.02.wf),
                    child: const Icon(
                      Icons.add,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
              if (!Get.currentRoute.contains('MyRoomsPage'))
                InkWell(
                  onTap: () {
                    Get.to(() => const MyRoomsPage());
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: AppColors.primaryColor,
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(0.02.wf),
                      child: const Icon(
                        Icons.next_plan_outlined,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
  //*===========================================================================
}
