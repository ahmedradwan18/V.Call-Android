import 'package:flutter/material.dart';
import 'package:flutter_module/app/core/utils/extensions.dart';
import 'package:get/get.dart';
import '../../../core/utils/design_utils.dart';
import '../../../data/enums/search/filter_type.dart';
import '../../../data/models/search/search_filter_model.dart';
import '../../../widgets/search/filtered_search_bar.dart';

import '../controllers/meetings_controller.dart';

class SliverSearchFilterBar extends GetView<MeetingsController> {
  //*===========================================================================
  //*================================ Properties ===============================
  //*===========================================================================

  //*===========================================================================
  //*================================ Constructor ==============================
  //*===========================================================================
  const SliverSearchFilterBar({
    super.key,
  });

  //*===========================================================================
  //*================================= Methods =================================
  //*===========================================================================
  @override
  Widget build(BuildContext context) {
    //*================================ Properties =============================

    final searchBarHorizontalPadding = (0.075).wf;
    //*=========================================================================
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsetsDirectional.only(
          top: (0.03).hf,
          bottom: (0.03).hf,
          start: searchBarHorizontalPadding,
          end: searchBarHorizontalPadding,
        ),
        child: AnimatedBuilder(
          animation: controller.animation,
          builder: (_, child) => Container(
            decoration: BoxDecoration(
              borderRadius: DesignUtils.getBorderRadius(radius: 8.0),
              border: controller.animationController.isAnimating
                  ? Border.all(
                      color: Theme.of(context).primaryColor,
                      width: 4.0 * controller.animation.value,
                    )
                  : null,
            ),
            child: child,
          ),
          child: Obx(
            () {
              final recordingFilter = controller.searchFilterList.firstWhere(
                (filter) => filter.filterType == FilterType.recording,
              );

              final disabledRecordingFilter = SearchFilterModel.fromOld(
                oldItem: recordingFilter,
                visible: false,
              );

              final filterListWithDisabledRecording =
                  controller.searchFilterList
                    ..replaceRange(
                      2,
                      3,
                      [disabledRecordingFilter],
                    );

              final filterList = controller.inMeetingLog
                  ? controller.searchFilterList
                  : filterListWithDisabledRecording;

              return FilteredSearchBar(
                hintText: '${'search'.tr}...',
                textFieldController: controller.searchTextFieldController,
                searchFilterList: filterList,
                onSearchQueryChanged: controller.onSearchQueryChanged,
                onSearchFieldCleared: controller.onClearSearchTextField,
                onSearchFieldSubmitted: controller.onSearchQueryChanged,
                animation: controller.animation,
              );
            },
          ),
        ),
      ),
    );
  }
  //*===========================================================================
  //*===========================================================================
}
