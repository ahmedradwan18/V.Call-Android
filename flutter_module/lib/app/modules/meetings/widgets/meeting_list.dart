import 'package:flutter/material.dart';
import '../../../widgets/custom_animated_switcher.dart';
import '../../../widgets/empty_error/empty_data.dart';

import 'meeting_card.dart';

/// Body of each tab of [MyMeetings]'s pageView
class MeetingList extends StatelessWidget {
  //*================================ Properties ===============================
  final String emptyListText;
  final Function onItemDismissed;
  final List<dynamic> meetingList;
  final ScrollController? scrollController;
  final bool? primary;
  //*================================ Constructor ==============================
  const MeetingList({
    required this.emptyListText,
    required this.onItemDismissed,
    required this.meetingList,
    Key? key,
    this.scrollController,
    this.primary,
  }) : super(key: key);
  //*================================= Methods =================================
  @override
  Widget build(BuildContext context) {
    //*================================ Properties =============================
    const double emptyImageHeightFactor = 0.3;
    //*=========================================================================
    return CustomAnimatedSwitcher(
      child: meetingList.isEmpty
          ? EmptyData(
              title: emptyListText,
              emptyImageHeightFactor: emptyImageHeightFactor,
            )
          : ListView.builder(
              key: key,
              padding: EdgeInsets.zero,
              primary: primary,
              controller: scrollController,
              itemCount: meetingList.length,
              itemBuilder: (_, index) => MeetingCard(
                meeting: meetingList[index],
                onDismissed: onItemDismissed,
              ),
            ),
    );
  }
  //*===========================================================================
  //*===========================================================================
}
