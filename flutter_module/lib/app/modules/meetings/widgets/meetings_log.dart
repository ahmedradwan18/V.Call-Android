import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import '../../../core/values/app_constants.dart';
import '../../../widgets/empty_error/error_page.dart';
import '../../../widgets/loader.dart';
import '../../../widgets/pagination_indicator.dart';
import '../controllers/meetings_controller.dart';
import 'meeting_list.dart';

class MeetingsLog extends GetView<MeetingsController> {
  //*===========================================================================
  //*================================ Constructor ==============================
  //*===========================================================================
  const MeetingsLog({Key? key}) : super(key: key);
  //*===========================================================================
  //*================================= Methods =================================
  //*===========================================================================
  @override
  Widget build(BuildContext context) {
    //*================================ Properties =============================
    const double errorTopPaddingFactor = 0.15;
    final emptyListText = 'no_log_meetings'.tr;
    //*=========================================================================
    return Obx(
      () => RefreshIndicator(
        // TO Rebuild when the user refreshed the List.
        backgroundColor: controller.meetingLog.isEmpty ? null : null,
        onRefresh: controller.onRefreshMeetingLog,
        child: FutureBuilder<List<dynamic>?>(
          key: key,
          future: controller.futureMeetingLog,
          builder: (_, snapshot) {
            //* Check if I have any data
            if (snapshot.hasData) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Obx(
                      () => NotificationListener<ScrollNotification>(
                        onNotification: controller.handleLogPagination,
                        child: MeetingList(
                          key: const PageStorageKey<String>('MeetingLogList'),
                          meetingList: controller.meetingLog,
                          emptyListText: emptyListText,
                          onItemDismissed: controller.removeLogMeeting,
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
