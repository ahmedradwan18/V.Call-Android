import 'package:flutter/material.dart';
import '../../../data/enums/meeting_status.dart';
import 'meeting_actions.dart';
import 'running_meeting_actions.dart';

class CustomMeetingActions extends StatelessWidget {
  //*================================ Properties ===============================
  final dynamic meeting;
  final List<String> runningMeetingsIDList;
  //*================================ Constructor ==============================
  const CustomMeetingActions({
    required this.meeting,
    required this.runningMeetingsIDList,
    Key? key,
  }) : super(key: key);
  //*================================= Methods =================================
  @override
  Widget build(BuildContext context) {
    //*================================ Properties =============================
    const int animationDurationinMilli = 500;
    const Curve curve = Curves.easeInOutQuad;
    const Curve reverseCurve = Curves.easeInOutQuad;
    const double iconSize = 0.0129;

    //*=========================================================================
    return AnimatedSwitcher(
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: const Offset(0, 0),
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: const Interval(0.3, 1, curve: curve),
              reverseCurve: reverseCurve,
            ),
          ),
          child: child,
        ),
      ),
      duration: const Duration(milliseconds: animationDurationinMilli),
      child: meeting.meetingStatus == MeetingStatus.log
          ? const SizedBox()
          : (meeting.meetingStatus == MeetingStatus.started) ||
                  (runningMeetingsIDList.contains(meeting.meetingDataBaseID))
              ? RunningMeetingActions(
                  meeting: meeting,
                  iconSizeFactor: iconSize,
                )
              : MeetingActions(
                  meeting,
                  iconSizeFactor: iconSize,
                ),
    );
  }
  //*===========================================================================
}
