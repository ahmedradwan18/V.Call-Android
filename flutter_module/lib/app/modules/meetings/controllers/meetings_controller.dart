import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_module/app/core/utils/extensions.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';
import 'package:super_tooltip/super_tooltip.dart';

import '../../../core/helpers/api_helper.dart';
import '../../../core/helpers/classroom_helper.dart';
import '../../../core/helpers/helpers.dart';
import '../../../core/helpers/meet_helper.dart';
import '../../../core/helpers/networking_service.dart';
import '../../../core/helpers/snackbar_helper.dart';
import '../../../core/helpers/widget_helper.dart';
import '../../../core/utils/date_time_utils.dart';
import '../../../core/utils/dialog_helper.dart';
import '../../../core/utils/logging_service.dart';
import '../../../core/values/app_constants.dart';
import '../../../core/values/app_images_paths.dart';
import '../../../data/enums/creation/creation_states.dart';
import '../../../data/enums/meeting_status.dart';
import '../../../data/enums/meeting_type.dart';
import '../../../data/enums/search/filter_type.dart';
import '../../../data/enums/snack_bar_type.dart';
import '../../../data/models/api_response.dart';
import '../../../data/models/checkbox_model.dart';
import '../../../data/models/meeting/classroom_meeting_model.dart';
import '../../../data/models/meeting/meeting_filter_model.dart';
import '../../../data/models/room/room_model.dart';
import '../../../data/models/search/search_filter_model.dart';
import '../../../data/models/vlc_view_arguments.dart';
import '../../../data/providers/meet_provider.dart';
import '../../../data/providers/my_meetings_provider.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/checkbox_list.dart';
import '../../../widgets/custom_svg.dart';
import '../../../widgets/date_range_picker.dart';
import '../../../widgets/text/animated_text.dart';
import '../../creation/controllers/creation_controller.dart';
import '../../creation/views/creation_view.dart';
import '../widgets/copy_widget.dart';
import '../widgets/room_checkbox_list.dart';

class MeetingsController extends GetxController
    with GetSingleTickerProviderStateMixin {
  //!===========================================================================
  //!=========================== Controller Methods ============================
  //!===========================================================================
  @override
  void onInit() {
    super.onInit();
    _initAnimationController();
    _initRecordedFilterCheckBoxList();
    _initSearchFilterList();

    // Log
    LoggingService.information('User Fetched Upcoming Meeting List');
    futureUpcomingMeetingList =
        MyMeetingsProvider().getMeetings(MeetingStatus.upcoming)
          ..then(
            (data) => reformatList(data ?? []),
          );

    LoggingService.information('User Fetched Meeting Log');
    futureMeetingLog = MyMeetingsProvider().searchWithFilter(
      filter: meetingListFilter,
      meetingStatus: MeetingStatus.log,
    )..then(
        (data) => _meetingLog.value = data ?? <dynamic>[],
      );
  }

  //*==================================================
  @override
  void onClose() {
    searchTextFieldController.dispose();
    debouncer.cancel();
    animationController.dispose();
    super.onClose();
  }

  //*==================================================
  void _initAnimationController() {
    // Setup The animation controller
    animationController = AnimationController(
      vsync: this,
      duration: AppConstants.subLongDuration,
    );
    //* ========= this will be for the opacity of the slides ===========
    // initialize the animations themselves [tweens and curves]
    // this will drive a number from [0] to [1] and will be used to controll
    // the opacity of each widget.
    animation = Tween<double>(begin: 0.1, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeInOutQuad,
        reverseCurve: Curves.easeInOutQuad,
      ),
    );
  }

  //*==================================================
  Widget _buildLeadingSVG(String path) => CustomSvg(
        svgPath: path,
        heightFactor: 0.025,
      );
  //*==================================================
  void _initSearchFilterList() {
    _searchFilterList = [
      SearchFilterModel(
        leading: _buildLeadingSVG(AppImagesPaths.meetingFilterRoomSvg),
        title: Obx(
          () => AnimatedText(
            defaultText: 'room'.tr,
            text: roomCheckboxList
                .where((checkbox) => checkbox.isSelected)
                .map((item) => item.label)
                .join(' | '),
            useDefaultText: meetingListFilter.roomList.isEmpty,
            duration: AppConstants.mediumDuration,
            minFontSize: 14.0,
          ),
        ),
        onTap: _onFilterByRoom,
        filterType: FilterType.room,
      ),
      SearchFilterModel(
        leading: _buildLeadingSVG(AppImagesPaths.meetingFilterDateSvg),
        title: Obx(
          () => AnimatedText(
            defaultText: 'date'.tr,
            text:
                '${meetingListFilter.startDate} | ${meetingListFilter.endDate}',
            useDefaultText: meetingListFilter.startDate.isEmpty,
            duration: AppConstants.mediumDuration,
          ),
        ),
        onTap: _onFilterByDate,
        filterType: FilterType.date,
      ),
      SearchFilterModel(
        leading: _buildLeadingSVG(AppImagesPaths.meetingFilterRecordingSvg),
        title: Obx(
          () => CheckboxList(
            checkBoxList: checkBoxList,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            onCheckboxChanged: _onFilterByRecording,
          ),
        ),
        showTrailingWidget: false,
        filterType: FilterType.recording,
      ),
    ].obs;
  }

  //*==================================================
  void _initRecordedFilterCheckBoxList() {
    _checkBoxList = [
      const CheckboxModel(
        isSelected: true,
        label: 'recorded',
      ),
      const CheckboxModel(
        isSelected: false,
        label: 'not_recorded',
      ),
    ].obs;
    //*==================================================
  }

  //!===========================================================================
  //!========================= [MyMeetings] Properties =========================
  //!===========================================================================

  final _isBusy = false.obs;
  final tabList = [
    'upcoming_meetings'.tr,
    'meetings_log'.tr,
  ];
  // Not Final for [Refresh Indicator]
  late Future<List<dynamic>?> futureUpcomingMeetingList;
  // [.obs] for pagination in the future.
  final _upcomingMeetingList = <dynamic>[].obs;

  late Future<List<dynamic>?> futureMeetingLog;
  // [.obs] for pagination in the future.
  final _meetingLog = <dynamic>[].obs;

  /// list with all id's of running meetings
  /// To singal that the [RunMeeting] action is being performed
  /// on a [Meeting] card, to start the [AnimatedSwitching] animation
  final _runningMeetingsIDList = <String>[].obs;

  /// To restrict UI access at necessary times.
  final _shouldIgnorePointer = false.obs;

  // To make animation for the copy widget
  final _isCopyWidgetVisible = false.obs;

  final _tabIndex = (0).obs;

  //*==================== SEARCH PROPERTIES ====================

  late final AnimationController animationController;
  late final Animation<double> animation;

  /// To Protect the server from being called after each character
  final debouncer = Debouncer(delay: AppConstants.mediumDuration);

  final searchTextFieldController = TextEditingController();
  // Used in pagination of search, as I need access to it to call the
  // API with the exact data, but increse page number
  String query = '';

  // [OBS] to replace it's items with items with updated labels, to reflect
  // the use choices
  late final List<SearchFilterModel> _searchFilterList;

  late final List<CheckboxModel> _checkBoxList;

  final _meetingListFilter = (MeetingFilterModel.empty()).obs;

  late final _roomCheckboxList = <CheckboxModel>[].obs;
  RxList<RoomModel> roomList = <RoomModel>[].obs;

  // The number of the latest page I've received information from
  int logPaginationIndex = 1;
  int upcomingListPaginationIndex = 1;

  // Whether or not the list has any more potential data.
  final _upcominglistHasMoreData = true.obs;
  final _logListHasMoreData = true.obs;
  // Whether of not the user is at the end of list
  final _isFetchingMoreData = false.obs;

  final _isClassroomLoading = false.obs;
  final _isMeetLoading = false.obs;

  //!===========================================================================
  //!======================= [MyMeetings] Getters/Setters ======================
  //!===========================================================================
  bool get isBusy => _isBusy.value;
  set isBusy(bool newValue) => _isBusy(newValue);

  List<dynamic> get upcomingMeetingList => _upcomingMeetingList.toList();
  List<dynamic> get meetingLog => _meetingLog.toList();

  List<String> get runningMeetingsIDList => _runningMeetingsIDList.toList();

  bool get shouldIgnorePointer => _shouldIgnorePointer.value;
  set shouldIgnorePointer(bool newValue) => _shouldIgnorePointer(newValue);

  bool get isClassRoomLoading => _isClassroomLoading.value;
  set isClassRoomLoading(bool newValue) => _isClassroomLoading(newValue);

  bool get isMeetLoading => _isMeetLoading.value;
  set isMeetLoading(bool newValue) => _isMeetLoading(newValue);

  bool get isCopyWidgetVisible => _isCopyWidgetVisible.value;
  set isCopyWidgetVisible(bool newValue) => _isCopyWidgetVisible(newValue);

  bool get inMeetingLog => _tabIndex.value == 1;

  //!================== SEARCH Getters/Setters ===============
  List<SearchFilterModel> get searchFilterList => _searchFilterList.toList();
  List<CheckboxModel> get checkBoxList => _checkBoxList.toList();

  MeetingFilterModel get meetingListFilter => _meetingListFilter.value;

  List<CheckboxModel> get roomCheckboxList => _roomCheckboxList.toList();

  bool get isFetchingMoreData => _isFetchingMoreData.value;
  set isFetchingMoreData(bool newValue) => _isFetchingMoreData(newValue);

  bool get upcomingListHasMoreData => _upcominglistHasMoreData.value;
  set upcomingListHasMoreData(bool newValue) =>
      _upcominglistHasMoreData(newValue);

  bool get logListHasMoreData => _logListHasMoreData.value;
  set logListHasMoreData(bool newValue) => _logListHasMoreData(newValue);

  //!===========================================================================
  //!======================== Repository Interfact Layer =======================
  //!===========================================================================
  Future<void> onRefreshUpcomingMeetingList() async {
    try {
      // Log
      LoggingService.information('User Refreshed Upcoming Meeting List');
      _clearFilter();

      // Clear running Meeting List
      _runningMeetingsIDList.clear();

      // Brain
      await Future.wait(
        [
          futureUpcomingMeetingList =
              MyMeetingsProvider().getMeetings(MeetingStatus.upcoming)
                ..then(
                  (data) {
                    print(data);
                    return reformatList(data ?? []);
                  },
                ),
        ],
      );
    } catch (e) {
      LoggingService.error(
        'Error at Method:onRefreshUpcomingMeetingList'
        ' -- my_meetings_controller.dart',
        e,
        StackTrace.current,
      );
    }
  }

  //!==================================================
  List<dynamic> reformatList(List<dynamic> list) {
    List<dynamic> temp = [];
    for (var element in list) {
      if (element.meetingStatus == MeetingStatus.started) {
        temp.insert(0, element);
      } else {
        temp.add(element);
      }
    }
    return _upcomingMeetingList.value = temp;
  }

  //!==================================================
  Future<void> onRefreshMeetingLog() async {
    try {
      LoggingService.information('User Refreshed Meeting Log');
      _clearFilter();

      await Future.wait(
        [
          futureMeetingLog = MyMeetingsProvider().getMeetings(MeetingStatus.log)
            ..then(
              (data) {
                return _meetingLog.value = data ?? <dynamic>[];
              },
            ),
        ],
      );
    } catch (e) {
      LoggingService.error(
        'Error at Method:onRefreshMeetingLog'
        ' -- my_meetings_controller.dart',
        e,
        StackTrace.current,
      );
    }
  }

  //!==================================================
  Future<void> onPreviewRecording(String link) async {
    return NetworkingService().openInAppBrowser(link);
  }

  //!==================================================
  void insertUpcomingMeeting(int index, dynamic meeting) {
    _upcomingMeetingList.insert(
      index,
      meeting,
    );
  }

  //!===========================================================================
  //!========================== Meeting Options/Actions ========================
  //!===========================================================================
  Future<void> onTabBarPressed(int newPageIndex) async {
    _tabIndex(newPageIndex);
    Helpers.hideKeyboard();

    final newScreenName = '${Routes.meetings}/${tabList[newPageIndex]}';

    // return AnalyticsService.logCustomScreenViewEvent(
    //   newScreenName,
    // );
  }

  //!==================================================
  Future<void> onRemoveMeeting({
    required dynamic meeting,
  }) async {
    final shouldDelete = await DialogHelper.showDeletePrompt(
      title: meeting.meetingTitle,
      itemType: 'meeting',
    );

    if (!shouldDelete) return;

    meeting.meetingStatus == MeetingStatus.upcoming
        ? await removeUpcomingMeeting(meeting)
        : await removeLogMeeting(meeting);
  }

  //!==================================================
  Future<void> removeUpcomingMeeting(dynamic meeting) async {
    // save the index of the [Meeting]
    var meetingIndex = _upcomingMeetingList.indexOf(meeting);

    // remove the meeting locally [Optimistic Delete]
    _upcomingMeetingList.remove(meeting);

    // call the api
    var apiResponse =
        await MyMeetingsProvider().deleteMeeting(meeting.meetingDataBaseID);

    // if API calling was NOT a success, restore the meeting if it's not the
    // list already, as I don't know when exactly the error happened
    if (!apiResponse.succeeded && !_upcomingMeetingList.contains(meeting)) {
      _upcomingMeetingList.insert(meetingIndex, meeting);
    }

    // show appropriate snackbar
    APIHelper.showAPIResponseSnackbar(apiResponse);
  }

  //!==================================================
  Future<void> removeLogMeeting(dynamic meeting) async {
    // save the index of the [Meeting]
    var meetingIndex = _meetingLog.indexOf(meeting);

    // remove the meeting locally [Optimistic Delete]
    _meetingLog.remove(meeting);

    // call the api
    var apiResponse =
        await MyMeetingsProvider().deleteMeeting(meeting.meetingDataBaseID);

    if (!apiResponse.succeeded && !_meetingLog.contains(meeting)) {
      _meetingLog.insert(meetingIndex, meeting);
    }

    // show appropriate snackbar
    APIHelper.showAPIResponseSnackbar(apiResponse);
  }

  //!==================================================
  /// Runs the meeting after it's been created at the [ERP] level
  Future<void> onRunClassRoom(dynamic meeting) async {
    try {
      // 1] Log
      LoggingService.information(
        'User runned a meeting with Title: ${meeting.meetingTitle}',
      );

      // if the [Meeting]'s [Settings] are null, fetch them from the Database.
      // else, it's a meeting i've just created and just use it's settings
      if (meeting.settingList == null) {
        final meetingSettings = await ClassroomHelper.getMeetingSettings(
          meeting.meetingDataBaseID,
        );
        // Failure
        if (!(meetingSettings != null)) {
          _runningMeetingsIDList.remove(meeting.meetingDataBaseID);
          return;
        }

        _runningMeetingsIDList.insert(0, meeting.meetingDataBaseID);
        _upcomingMeetingList.remove(meeting);
        _upcomingMeetingList.insert(0, meeting);

        // All Is Good
        // Put the Settings into the Meeting

        meeting = ClassroomMeetingModel.fromOld(
          oldMeeting: meeting,
          newStatus: meeting.meetingStatus,
          settingList: meetingSettings,
        );
      }

      // Call the [RUN Meeting] API
      final runningSucceeded = await ClassroomHelper.runMeeting(meeting);
      if (!runningSucceeded) {
        // Remove the Meeting from the List to show the [Not Running] Acitons
        _runningMeetingsIDList.removeAt(0);
      }
    } catch (e) {
      LoggingService.error(
        'Error at Method:onRunClassRoom -- meetings_controller.dart',
        e,
        StackTrace.current,
      );
    }
  }

  //!==================================================
  /// Runs the meeting after it's been created at the [ERP] level
  Future<void> onRunMeet(dynamic meeting) async {
    try {
      // 1] Log
      LoggingService.information(
        'User runned a meeting with Title: ${meeting.meetingTitle}',
      );

      final apiResponse =
          await MeetProvider().runMeetOnSchedule(meeting.meetingDataBaseID);
      if (!(apiResponse.succeeded)) {
        SnackBarHelper.showSnackBar(
          message: (AppConstants.somethingWentWrongText).tr,
          type: SnackBarType.error,
        );
        return;
      }
      _runningMeetingsIDList.insert(0, meeting.meetingDataBaseID);
      _upcomingMeetingList.remove(meeting);
      _upcomingMeetingList.insert(0, apiResponse.data);

      final runningSucceeded =
          await MeetHelper.runMeet(meetingData: apiResponse.data);

      if (!runningSucceeded) {
        // Remove the Meeting from the List to show the [Not Running] Acitons
        _runningMeetingsIDList.removeAt(0);
      }
    } catch (e) {
      LoggingService.error(
        'Error at Method:onRunMeet -- meetings_controller.dart',
        e,
        StackTrace.current,
      );
    }
  }

  //!==================================================

  Future<void> onEditMeeting(dynamic meeting) async {
    try {
      // Log
      LoggingService.information(
        'User went to edit a meeting with Title: [${meeting.meetingTitle}]',
      );

      Get.put(() => CreationController());
      final creationController = Get.find<CreationController>();
      // Send the [Meeting] to use it's values as inital values.
      creationController.meetingBeingEdited = meeting;
      // Change the state of the [CreationView]

      creationController.onRefreshCreationView(
        newState: CreationStates.edit,
      );

      Get.to(() => const ScheduleView());
      // Navigate to the [CreationView]
    } catch (e) {
      LoggingService.error(
        'Error at Method:editMeetingLocally -- meetings_controller.dart',
        e,
        StackTrace.current,
      );
    }
  }

  //!==================================================
  Future<void> onJoinMeetingAsModerator({
    required dynamic meeting,
  }) async {
    //LOG
    LoggingService.information('User joined meeting as a moderator');

    _shouldIgnorePointer(true);
    // put the meeting's id as the first in the [RunningMeetinglist] to check
    // at the [UI] level and show the [spinning] indicator only at the
    // chosen meetingCard
    _runningMeetingsIDList
      ..remove(meeting.meetingDataBaseID)
      ..insert(0, meeting.meetingDataBaseID);
    if (meeting.engineType == MeetingType.classroom) {
      final apiResponse = await MyMeetingsProvider()
          .joinMeetingAsModerator(meeting.meetingDataBaseID);

      // added to check as in this success case, the [Message] from api is not
      // empty, it contains the link i'm going to hit.
      if (apiResponse.succeeded) {
        _shouldIgnorePointer(false);

        // pushes the vlc page onto the UI. [opens VLC]
        await ClassroomHelper.navigateToMeeting(
          VlcViewArugumets(
            url: apiResponse.data,
            meeting: meeting,
          ),
        );
      }
      // else as I use the [_apiResponse.data] and it won't be empty
      else {
        APIHelper.showAPIResponseSnackbar(apiResponse);
      }
    } else {
      final apiResponse = await MeetProvider().joinMeetWithMeetingId(
        meetingID: meeting.meetingDataBaseID,
        isModerator: 'moderator',
      );
      // added to check as in this success case, the [Message] from api is not
      // empty, it contains the link i'm going to hit.
      if (apiResponse.succeeded) {
        _shouldIgnorePointer(false);
        MeetHelper.runMeet(meetingData: apiResponse.data);
      } else {
        APIHelper.showAPIResponseSnackbar(apiResponse);
      }
    }
    _shouldIgnorePointer(false);
  }

  //!==================================================
  void editMeetingLocally(dynamic editedMeeting) {
    try {
      final index = _upcomingMeetingList.indexWhere(
        (element) =>
            element.meetingDataBaseID == editedMeeting.meetingDataBaseID,
      );
      _upcomingMeetingList.replaceRange(
        index,
        index + 1,
        [editedMeeting],
      );
    } catch (e) {
      LoggingService.error(
        'Error at Method:editMeetingLocally -- meetings_controller.dart',
        e,
        StackTrace.current,
      );
    }
  }

  //!==================================================
  void showCopyWidget({
    required String meetingTitle,
    required String meetingLink,
    required String meetingID,
    required BuildContext context,
    String? password,
  }) {
    WidgetHelper.showToolTip(
      context: context,
      arrowLength: (0.015).hf,
      child: Obx(
        () => CopyWidget(
          meetingID: meetingID,
          meetingTitle: meetingTitle,
          meetingLink: meetingLink,
          password: password,
          isVisible: isCopyWidgetVisible,
        ),
      ),
      onClose: () {
        // to restart the animation
        isCopyWidgetVisible = false;
      },
      onOpen: () {
        Future.delayed(
          const Duration(milliseconds: 100),
          () {
            isCopyWidgetVisible = true;
          },
        );
      },
    );
  }

  //!===========================================================================
  //!============================== SEARCH METHODS =============================
  //!===========================================================================
  bool handleLogPagination(ScrollNotification? scrollNotification) {
    if (!isBusy &&
        (scrollNotification?.metrics.pixels ==
            scrollNotification?.metrics.maxScrollExtent) &&
        logListHasMoreData) {
      isBusy = true;
      // update the number, to be used in calling the [API]
      logPaginationIndex++;

      LoggingService.information(
        'User is fetching more MeetingLogs in [MeetingsView] '
        'with Pagination Index = $logPaginationIndex',
      );

      // show the indicator
      isFetchingMoreData = true;

      MyMeetingsProvider()
          .searchWithFilter(
        filter: meetingListFilter,
        query: query,
        paginationIndex: logPaginationIndex,
        meetingStatus: MeetingStatus.log,
      )
          .then(
        (data) {
          if (data != null) {
            for (var meeting in data) {
              _meetingLog.addIf(!meetingLog.contains(meeting), meeting);
            }
            if (data.isEmpty) {
              logListHasMoreData = false;
            }
          }

          // hide the indicator
          isFetchingMoreData = false;
          isBusy = false;
        },
      );
    }
    // Return false to allow the notification bubbling up the tree
    // to reach the refresh indicator if necessary
    return false;
  }

//*==================================================
  bool handleUpcomingPagination(ScrollNotification? scrollNotification) {
    if (!isBusy &&
        (scrollNotification?.metrics.pixels ==
            scrollNotification?.metrics.maxScrollExtent) &&
        upcomingListHasMoreData) {
      isBusy = true;
      // update the number, to be used in calling the [API]
      upcomingListPaginationIndex++;

      LoggingService.information(
        'User is fetching more UpcomingMeetings in [MeetingsView] '
        'with Pagination Index = $upcomingListPaginationIndex',
      );

      // show the indicator
      isFetchingMoreData = true;

      MyMeetingsProvider()
          .searchWithFilter(
        filter: meetingListFilter,
        query: query,
        paginationIndex: upcomingListPaginationIndex,
      )
          .then(
        (data) {
          if (data != null) {
            for (var meeting in data) {
              _upcomingMeetingList.addIf(
                  !meetingLog.contains(meeting), meeting);
            }
            if (data.isEmpty) {
              upcomingListHasMoreData = false;
            }
          }

          // hide the indicator
          isFetchingMoreData = false;
          isBusy = false;
        },
      );
    }
    // Return false to allow the notification bubbling up the tree
    // to reach the refresh indicator if necessary
    return false;
  }

  //*==================================================
  Future<void> searchWithFilter({
    String query = '',

    /// Pagination Page
    int paginationIndex = 1,
    MeetingStatus? meetingStatus,
  }) async {
    debugPrint('Searching for \'$query\'\nFiltering by $meetingListFilter');

    // show loading spinner
    animationController.repeat(reverse: true);

    final meetingStatus =
        inMeetingLog ? MeetingStatus.log : MeetingStatus.upcoming;

    final resultList = await MyMeetingsProvider().searchWithFilter(
      filter: meetingListFilter,
      query: query,
      meetingStatus: meetingStatus,
      paginationIndex: paginationIndex,
    );

    // show loading spinner
    animationController.reverse();

    if (resultList == null) return;

    meetingStatus == MeetingStatus.upcoming
        ? reformatList(resultList)
        : _meetingLog.value = resultList;

    // Is busy is set = true, when the calling filter is pressed
    isBusy = false;
  }

  //*==================================================
  Future<void> onSearchQueryChanged(String inputQuery) async {
    if (inputQuery == query) return;
    debouncer.call(
      () async {
        _resetFilterPagination();
        await searchWithFilter(
          query: inputQuery,
        );
        query = inputQuery;
      },
    );
  }

  //*==================================================
  Future<void> onClearSearchTextField() async {
    searchTextFieldController.clear();
    await onSearchQueryChanged('');
  }

  //*==================================================
  void _onFilterByRoom(
    BuildContext context,
  ) {
    if (isBusy) return;
    isBusy = true;
    _resetFilterPagination();

    // Update the roomList with any new values that possible was added
    // at [RoomController]
    for (var room in roomList) {
      // Check if this room has already been added to the check list
      final existsInCheckList = _roomCheckboxList.any(
        (checkbox) => checkbox.value == room.id,
      );
      if (existsInCheckList) continue;

      // Add any newly added rooms
      _roomCheckboxList.add(
        CheckboxModel(
          isSelected: true,
          label: room.title,
          value: room.id,
        ),
      );
    }

    // Show toolTip
    WidgetHelper.showToolTip(
      context: context,
      arrowLength: 0.0,
      horizontalMargin: (0.175).wf,
      backgroundColor: Colors.white,
      hasShadow: true,
      child: Obx(
        () => RoomCheckboxList(
          roomCheckboxList: roomCheckboxList,
          onCheckboxChanged: _onFilterRoomListChanged,
          shrinkWrap: true,
        ),
      ),
      onClose: _onApplyRoomsFilter,
    );
  }

  //*==================================================
  Future<void> _onApplyRoomsFilter() async {
    final roomList = <String>[];
    for (var checkbox in roomCheckboxList) {
      if (!checkbox.isSelected) continue;
      roomList.add(checkbox.value!);
    }

    if (listEquals(roomList, meetingListFilter.roomList)) {
      isBusy = false;
      return;
    }

    _meetingListFilter.update(
      (oldItem) {
        oldItem?.roomList = roomList;
      },
    );

    await searchWithFilter();
  }

  //*==================================================
  void _onFilterRoomListChanged({
    required int index,
    required bool newValue,
  }) {
    final item = roomCheckboxList[index];
    _roomCheckboxList[index] = CheckboxModel.toggle(item);

    // I want to modify the [Recorded] checkbox, make sure that the other
    // checkbox is selected as I can not have both [recorded/not-recorded]
    // not selected
    final atleastOneSelected =
        _roomCheckboxList.any((element) => element.isSelected == true);
    if (!atleastOneSelected) {
      _roomCheckboxList[0] = CheckboxModel.toggle(_roomCheckboxList[0]);
    }
  }

  //*==================================================
  Future<void> _onFilterByDate(BuildContext context) async {
    if (isBusy) return;
    isBusy = true;
    _resetFilterPagination();

    // Show toolTip
    final toolTipHandler = WidgetHelper.showToolTip(
      context: context,
      arrowLength: 0.0,
      bottomMargin: (0.2).hf,
      horizontalMargin: (0.065).wf,
      child: DateRangePicker(
        onSelectionChanged: _onDateRangeChanged,
      ),
    );

    // Check if a date has been selected to manually dismiss the tooltip
    // downside to the package
    _checkIfDateSelected(toolTipHandler);
    isBusy = false;
  }

  //*==================================================
  Future<void> _checkIfDateSelected(SuperTooltip? toolTipHandler) async {
    try {
      final oldStartDate = meetingListFilter.startDate;
      final oldEndDate = meetingListFilter.endDate;

      Future.doWhile(() async {
        await Future.delayed(AppConstants.subMediumDuration);
        final hasNewStartDate = (meetingListFilter.startDate != oldStartDate);
        final hasNewEndDate = (meetingListFilter.endDate != oldEndDate);

        if (hasNewStartDate || hasNewEndDate) {
          if (toolTipHandler?.isOpen ?? false) {
            toolTipHandler?.close();
          }
          return false;
        }
        return true;
      });
    } catch (e) {
      LoggingService.error(
        'Error at Method:_checkIfSelectedDate -- meetings_controller.dart',
        e,
        StackTrace.current,
      );
    }
  }

  //*==================================================
  Future<void> _onDateRangeChanged(dynamic dateRange) async {
    if (dateRange == null) return;

    final startDate = DateTimeUtils.getStringFromDate(
      dateRange.startDate,
      seperator: '-',
    );

    final endDate = (dateRange.endDate == null)
        ? startDate
        : DateTimeUtils.getStringFromDate(dateRange.endDate);

    if (meetingListFilter.startDate == startDate &&
        meetingListFilter.endDate == endDate) return;

    // Update the Filter Variable
    _meetingListFilter.update(
      (oldItem) {
        oldItem?.startDate = startDate;
        oldItem?.endDate = endDate;
      },
    );

    Helpers.dismissOverlays();

    await searchWithFilter();
  }

  //*==================================================
  Future<void> _onFilterByRecording({
    required bool newValue,
    required int index,
  }) async {
    if (isBusy) return;
    isBusy = true;
    _resetFilterPagination();

    // Update the UI
    _checkBoxList[index] = CheckboxModel.toggle(_checkBoxList[index]);

    // I want to modify the [Recorded] checkbox, make sure that the other
    // checkbox is selected as I can not have both [recorded/not-recorded]
    // not selected
    final atleastOneSelected =
        checkBoxList.any((element) => element.isSelected == true);
    if (!atleastOneSelected) {
      _checkBoxList[0] = CheckboxModel.toggle(_checkBoxList[0]);
    }

    // Update the Filter Variable
    _meetingListFilter.update((oldItem) {
      oldItem?.showRecorded = checkBoxList.first.isSelected;
      oldItem?.showNotRecorded = checkBoxList.last.isSelected;
    });

    await searchWithFilter();
  }

  //*==================================================
  void _resetFilterPagination() {
    inMeetingLog ? _resetLogPagination() : _resetUpcomingPagination();
  }

  //*==================================================
  /// for new filtering options reset the pagination ability
  void _resetLogPagination() {
    logListHasMoreData = true;
    logPaginationIndex = 1;
  }

  //*==================================================
  void _resetUpcomingPagination() {
    upcomingListHasMoreData = true;
    upcomingListPaginationIndex = 1;
  }

  //*==================================================
  void _clearFilter() {
    // Clear textField
    searchTextFieldController.clear();
    query = '';

    // Reset the filter
    _meetingListFilter.value = MeetingFilterModel.empty();

    // Reset roomList Selection
    for (var i = 0; i < _roomCheckboxList.length; i++) {
      if (_roomCheckboxList[i].isSelected) continue;
      _roomCheckboxList[i] = CheckboxModel.toggle(_roomCheckboxList[i]);
    }

    // Reset Recording Checkbox List
    for (var i = 0; i < _checkBoxList.length; i++) {
      if (_checkBoxList[i].isSelected) continue;
      _checkBoxList[i] = CheckboxModel.toggle(_checkBoxList[i]);
    }

    // Reset Pagination Index
    _resetLogPagination();
    _resetUpcomingPagination();
  }

  //*==================================================
  void shouldEndMeeting(dynamic meeting) {
    DialogHelper.confirmDialog(
      content: 'end_meeting_content'.tr,
      onApply: () {
        _endMeeting(meeting);
        Get.back();
      },
    );
  }

  //*==================================================

  void _endMeeting(dynamic meeting) async {
    try {
      final APIResponseModel apiResponse;
      if (meeting.engineType == MeetingType.classroom) {
        apiResponse = await MyMeetingsProvider()
            .endClassroomMeeting(meeting.meetingDataBaseID);
      } else {
        apiResponse = await MyMeetingsProvider().endMeetMeeting(
            meetingID: meeting.meetingDataBaseID, domain: meeting.domain);
      }

      _runningMeetingsIDList.remove(meeting);

      if (apiResponse.succeeded) {
        //? All is Good
        await onRefreshUpcomingMeetingList();
        await onRefreshMeetingLog();
      }
      //? Something Went wrong
      else {
        SnackBarHelper.showSnackBar(
          message: apiResponse.data,
          type: SnackBarType.error,
        );
      }
    } catch (e) {
      LoggingService.error(
        'Error at Method:endMeeting -- meetings_controller.dart',
        e,
        StackTrace.current,
      );
    }
  }

  //*==================================================
  void onRunMeeting(meeting) async {
    if (meeting.engineType == MeetingType.classroom) {
      await onRunClassRoom(meeting);
    } else {
      await onRunMeet(meeting);
    }
  }
  //!===========================================================================
  //!===========================================================================
}
