import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import '../../../core/values/app_constants.dart';
import '../../../widgets/empty_error/error_page.dart';
import '../../../widgets/loader.dart';
import '../../../widgets/pagination_indicator.dart';
import '../controllers/meetings_controller.dart';
import 'meeting_list.dart';

class UpcomingMeetings extends GetView<MeetingsController> {
  //*===========================================================================
  //*================================ Constructor ==============================
  //*===========================================================================
  const UpcomingMeetings({Key? key}) : super(key: key);
  //*===========================================================================
  //*================================= Methods =================================
  //*===========================================================================
  @override
  Widget build(BuildContext context) {
    //*================================ Properties =============================
    const double errorTopPaddingFactor = 0.15;
    final emptyListText = 'no_upcoming_meetings'.tr;
    //*=========================================================================
    return Obx(
      () => RefreshIndicator(
        // TO Rebuild when the user refreshed the List.
        backgroundColor: controller.upcomingMeetingList.isEmpty ? null : null,
        onRefresh: controller.onRefreshUpcomingMeetingList,
        child: FutureBuilder<List<dynamic>?>(
          future: controller.futureUpcomingMeetingList,
          builder: (_, snapshot) {
            //* Check if I have any data
            if (snapshot.hasData) {
              // [OBX] for Modificaion,[Delete] and for Pagination
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Obx(
                      () => NotificationListener<ScrollNotification>(
                        onNotification: controller.handleUpcomingPagination,
                        child: MeetingList(
                          key: const PageStorageKey<String>('UpcomingList'),
                          meetingList: controller.upcomingMeetingList,
                          emptyListText: emptyListText,
                          onItemDismissed: controller.removeUpcomingMeeting,
                        ),
                      ),
                    ),
                  ),
                  Obx(
                    () => PaginationIndicator(
                      isFetchingMoreData: controller.isFetchingMoreData,
                    ),
                  ),
                ],
              );
            }

            //* Check if it has an error
            else if (snapshot.hasError ||
                ((snapshot.connectionState == ConnectionState.done) &&
                    (!snapshot.hasData))) {
              return ErrorPage(
                title: (AppConstants.somethingWentWrongText).tr,
                topPaddingFactor: errorTopPaddingFactor,
              );
            }

            //* By default, show a loading spinner.
            return const Center(child: Loader());
          },
        ),
      ),
    );
  }
  //*===========================================================================
  //*===========================================================================
}
