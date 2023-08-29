import 'package:flutter/material.dart';
import 'package:flutter_module/app/core/utils/extensions.dart';
import 'package:get/get.dart';
import '../../../core/values/app_constants.dart';
import '../../../themes/app_theme.dart';
import '../../../widgets/custom_sliver_app_bar.dart';
import '../../room/controllers/rooms_controller.dart';
import '../controllers/meetings_controller.dart';
import '../widgets/meetings_log.dart';
import '../widgets/sliver_search_filter_bar.dart';
import '../widgets/upcoming_meetings.dart';

class MeetingsView extends GetView<MeetingsController> {
  //*===========================================================================
  //*================================ Constructor ==============================
  //*===========================================================================
  const MeetingsView({Key? key}) : super(key: key);
  //*===========================================================================
  //*================================= Methods =================================
  //*===========================================================================
  Future<void> _prepareRoomList() async {
    if (controller.roomList.isNotEmpty) return;

    final roomsController = Get.find<RoomsController>();

    controller.roomList = roomsController.roomList;

    // if the user room list is empty, get it.
    // No await as it's OBS, when the [Room List] value changes at
    // [RoomController], it will also change at [MeetingsController]
    roomsController.onRefreshRooms();
  }

  @override
  Widget build(BuildContext context) {
    _prepareRoomList();
    //*================================ Properties =============================
    final theme = AppTheme.disabledSplashAppTheme;
    final viewHorizontalPadding = (0.035).wf;
    //*=========================================================================
    return Theme(
      key: key,
      data: theme,
      child: DefaultTabController(
        length: controller.tabList.length,
        animationDuration: AppConstants.tabControllerAnimationDuration,
        child: Scaffold(
          body: NestedScrollView(
            headerSliverBuilder: (_, innerBoxIsScrolled) {
              return <Widget>[
                CustomSliverAppBar(
                  tabList: controller.tabList,
                  onTap: controller.onTabBarPressed,
                ),
                //* SearchBar
                const SliverSearchFilterBar(),
              ];
            },
            floatHeaderSlivers: true,
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: viewHorizontalPadding),
              child: const TabBarView(
                children: [
                  UpcomingMeetings(),
                  MeetingsLog(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  //*===========================================================================
  //*===========================================================================
}
