import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/values/app_constants.dart';
import '../../../data/enums/creation/creation_states.dart';
import '../../../data/enums/meeting_type.dart';
import '../../../widgets/empty_error/error_page.dart';
import '../../../widgets/loader.dart';
import '../../../widgets/simple_app_bar.dart';
import '../controllers/creation_controller.dart';
import 'creation_body.dart';

class ScheduleView extends GetView<CreationController> {
  //*================================ Properties ===============================

  final bool? isCreate;
  final String? appBarTitle;
  final MeetingType? meetingType;
  //*================================ Constructor ==============================
  const ScheduleView({
    this.isCreate,
    this.appBarTitle,
    this.meetingType,
    Key? key,
  }) : super(key: key);
  //*================================= Methods =================================
  @override
  Widget build(BuildContext context) {
    //*================================ Properties =============================
    const double errorPageTopPaddingFactor = 0.185;
    //*=========================================================================
    return WillPopScope(
      onWillPop: () {
        // Get.delete<CreationController>();
        return Future.value(true);
      },
      child: Scaffold(
        appBar: SimpleAppBar(
          title: appBarTitle ?? controller.createMeetingPageState.pageTitle,
          onBackPressed: () {
            Get.back();
            // Get.delete<CreationController>();
          },
        ),
        body: RefreshIndicator(
          onRefresh: controller.onRefreshCreationView,
          child: Obx(
            () => SizedBox(
              key: controller.createMeetingPageState == CreationStates.create
                  ? null
                  : null,
              child: FutureBuilder(
                future: controller.futureInitCreationView,
                builder: (_, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Obx(
                      () => Container(
                        child: (!controller.hasFetchingError &&
                                snapshot.hasData &&
                                snapshot.data == true)
                            ? CreationBody(
                                isCreate: isCreate,
                                meetingType: meetingType,
                              )
                            : ErrorPage(
                                title: AppConstants.somethingWentWrongText.tr,
                                topPaddingFactor: errorPageTopPaddingFactor,
                              ),
                      ),
                    );
                  } else {
                    return const Center(child: Loader());
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
  //*===========================================================================
}
