import 'package:flutter/material.dart';
import 'package:flutter_module/app/core/utils/extensions.dart';
import 'package:flutter_module/app/modules/room/widgets/room_chart.dart';
import 'package:flutter_module/app/widgets/simple_app_bar.dart';
import 'package:get/get.dart';
import '../../../core/values/app_constants.dart';
import '../../../widgets/empty_error/error_page.dart';
import '../../../widgets/loader.dart';
import '../controllers/rooms_controller.dart';
import 'room_list.dart';

class MyRoomsPage extends GetView<RoomsController> {
  //*================================ Properties ===============================

  //*================================ Constructor ==============================
  const MyRoomsPage({Key? key}) : super(key: key);

  //*================================= Methods =================================

  @override
  Widget build(BuildContext context) {
    //*================================ Properties =============================
    const double errorTopPaddingFactor = 0.07;
    const double errorImageHeightFactor = 0.22;
    const double emptyImageHeightFactor = (0.35);

    final emptyDataTitle = 'no_rooms'.tr;
    //*=========================================================================
    return Scaffold(
      appBar: SimpleAppBar(title: 'rooms'.tr),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: (0.01).hf,
              ),
              child: const RoomChart(),
            ),
            Expanded(
              child: Obx(
                () => RefreshIndicator(
                  key: controller.roomList.isEmpty ? null : null,
                  onRefresh: controller.onRefreshRooms,
                  child: FutureBuilder(
                    future: controller.futureRoomList,
                    builder: (_, snapshot) {
                      //* Check if I have any data
                      if (snapshot.hasData) {
                        return Obx(
                          () => RoomList(
                            controller.roomList.toList(),
                            emptyDataTitle: emptyDataTitle,
                            emptyImageHeightFactor: emptyImageHeightFactor,
                          ),
                        );
                      }

                      //* Check if it has an error
                      else if (snapshot.hasError ||
                          ((snapshot.connectionState == ConnectionState.done) &&
                              (!snapshot.hasData))) {
                        return ErrorPage(
                          title: (AppConstants.somethingWentWrongText.tr),
                          topPaddingFactor: errorTopPaddingFactor,
                          errorImageHeightFactor: errorImageHeightFactor,
                        );
                      }

                      //* By default, show a loading spinner.
                      return const Center(child: Loader());
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  //*===========================================================================
}
