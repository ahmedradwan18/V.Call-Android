class AppImagesPaths {
  //!=============================== Constructor ===============================
  static final AppImagesPaths _singleton = AppImagesPaths._internal();
  factory AppImagesPaths() {
    return _singleton;
  }
  AppImagesPaths._internal();

  ///*============================= [GLOBAL] ===================================
  static const String defaultUserImagePath = 'assets/images/global/user.png';
  static const String launchImagePath = 'assets/images/global/launch_image.png';
  static const String logoPath = 'assets/images/global/logo.png';

  /// the location for the assets used as the error image.
  static const String errorSvgPath = 'assets/images/global/error.svg';

  static const String placeHolderLottie =
      'assets/lotties/global/placeHolder.json';
  static const String successLottie =
      'assets/lotties/contacts/check-okey-done.json';
  static const String loaderLottie = 'assets/lotties/global/loader.json';
  static const String whiteLoaderLottie =
      'assets/lotties/global/white_loader.json';
  static const String errorLottie = 'assets/lotties/global/error.json';

  static const String offerSuccessLottie =
      'assets/lotties/global/offer_success.json';
  static const String filterSvg = 'assets/images/global/filter.svg';

  static const String vconnctLogoSvg = 'assets/images/global/logo_text.svg';
  static const String drawerIconSvg = 'assets/images/global/menu.svg';

  static const String playIcon = 'assets/images/global/play_icon.svg';
  static const String deleteIcon = 'assets/images/global/delete_icon.svg';
  static const String copyIcon = 'assets/images/global/copy_icon.svg';
  static const String editIcon = 'assets/images/global/edit_icon.svg';
  static const String emptyData = 'assets/images/global/empty_data.svg';
  static const String classroomIcon = 'assets/images/global/classroom_icon.svg';
  static const String meetIcon = 'assets/images/global/meet_icon.svg';
  static const String createMeet = 'assets/images/global/create_meet.svg';
  static const String scheduleMeet = 'assets/images/global/schedule_meet.svg';
  static const String createClassroom =
      'assets/images/global/create_classroom.svg';
  static const String scheduleClassroom =
      'assets/images/global/schedule_classroom.svg';

  ///*=========================== [Home View] ==================================
  static const String homeViewImagePath = 'assets/images/home/home_image.png';

  ///*=========================== [Vol View] ==================================
  static const String placeHolderScreen = 'assets/images/learning/screen.png';

  ///*========================= [V.Connct/Tool View] ===========================
  static const String exitMeetingSvg = 'assets/images/tool/exit_meeting.svg';
  static const String pipModeSvg = 'assets/images/tool/pip.svg';
  static const String refreshSvg = 'assets/images/tool/refresh.svg';
  static const String microphoneSvg = 'assets/images/tool/microphone.svg';
  static const String cameraSvg = 'assets/images/tool/camera.svg';
  static const String shareSvg = 'assets/images/tool/share.svg';

  ///*========================= [My Meetings View] =============================
  static const String guestSvgPath = 'assets/images/meeting/guestViewSVG.png';

  static const String noRoomSvgPath =
      'assets/images/meeting/restrict_meeting.svg';

  static const String copyLinkSvgPath = 'assets/images/meeting/link.svg';

  static const String copyCodeSvg = 'assets/images/meeting/code-signs.svg';

  static const String meetingFilterRoomSvg =
      'assets/images/meeting/meeting_filter_1.svg';
  static const String meetingFilterDateSvg =
      'assets/images/meeting/meeting_filter_2.svg';
  static const String meetingFilterRecordingSvg =
      'assets/images/meeting/meeting_filter_3.svg';
  static const String endMeeting = 'assets/images/meeting/end_meeting.svg';

  ///*========================= [roomView] =====================================

  static const String regenerateRoomLinksSvgPath =
      'assets/images/room/regenerate_room_links.svg';
  static const String editRoomSvgPath = 'assets/images/room/edit_room.svg';
  static const String lightBulb = 'assets/images/room/light_bulb.svg';
  static const String attendeeIcon = 'assets/images/room/attendee_icon.svg';
  static const String moderatorIcon = 'assets/images/room/moderator_icon.svg';
  static const String roomSettingsSvgPath =
      'assets/images/room/room_settings.svg';

  ///*========================= [PaymentView] ==================================
  static const String fawryLogo = 'assets/images/payment/fawry.svg';
  static const String mastercardLogo = 'assets/images/payment/mastercard.svg';
  static const String visaLogo = 'assets/images/payment/visa.svg';
  static const String masaryLogo = 'assets/images/payment/masary.png';
  static const String countDownLottie =
      'assets/lotties/payment/count_down.json';
  static const String percent = 'assets/images/payment/percent.svg';
  static const String error = 'assets/lotties/payment/error.json';
  static const String success = 'assets/lotties/payment/success.json';
  static const String gift = 'assets/images/payment/gift.png';
  static const String streamlineSetting =
      'assets/lotties/payment/streamlineSetting.svg';
  static const String scan = 'assets/images/payment/scan.svg';
  static const String backgroundCard =
      'assets/images/payment/backgroundcard.png';
  static const String share = 'assets/images/payment/share.png';
  static const String correctBuy = 'assets/images/payment/correctBuy.svg';
  static const String errorBuy = 'assets/images/payment/errorBuy.svg';
  static const String warning = 'assets/images/payment/warning.png';

  ///*========================= [SettingView] ==================================
  static const String googleTranslateIconSvgPath =
      'assets/images/settings/translate.svg';
  static const String logoutIconSvgPath = 'assets/images/settings/logout.svg';
  static const String packageSvgPath = 'assets/images/home/package.svg';

  ///*========================= [Delete Account] ===============================
  static const String variianceLogoSvg =
      'assets/images/settings/account_settings/delete_account/variiance_logo.svg';
  static const String volLogoSvg =
      'assets/images/settings/account_settings/delete_account/vol_logo.svg';

  static const String addImage =
      'assets/images/settings/account_settings/delete_account/add_image.svg';

  ///*======================= [Account Information] ============================
  static const String editAccountImage =
      'assets/images/settings/account_settings/account_information'
      '/change_user_image.svg';

  ///*============================ [Drawer Icons] ==============================
  static const String arrowIcon = 'assets/images/drawer/arrow.png';
  static const String contactUsIcon = 'assets/images/drawer/contact_us.svg';
  static const String packagesIcon = 'assets/images/drawer/packages.svg';
  static const String settingsIcon = 'assets/images/drawer/settings.svg';
  static const String subscriptionIcon =
      'assets/images/drawer/subscription.svg';
  static const String logoutIcon = 'assets/images/drawer/exit.png';

  ///*======================= [Bottom Navigation Bar] ==========================
  static const String homeIconSvg = 'assets/images/bottom_nav/home.svg';
  static const String invitationsIconSvg =
      'assets/images/bottom_nav/invitations.svg';
  static const String meetingsIconSvg = 'assets/images/bottom_nav/meetings.svg';
  static const String profileIconSvg = 'assets/images/bottom_nav/profile.svg';
  static const String scheduleIconSvg = 'assets/images/bottom_nav/schedule.svg';
  static const String newEventIconSvg =
      'assets/images/bottom_nav/new_event.svg';
  static const String supportIconSvg = 'assets/images/bottom_nav/Supprt.svg';
  static const String learningIconSvg =
      'assets/images/bottom_nav/learning_videos.svg';

  ///*========================= [Contact Us Page] ==============================
  static const String whatsapp = 'assets/images/contact_us/whatsapp.svg';
  static const String telegram = 'assets/images/contact_us/telegram.svg';
  static const String messenger = 'assets/images/contact_us/messenger.svg';
  static const String instagram = 'assets/images/contact_us/instagram.svg';
  static const String email = 'assets/images/contact_us/mail.svg';

  ///*=========================== [Waiting Room] ===============================
  static const String waitingRoom =
      'assets/images/waiting_room/waiting_room.png';

  ///*=========================== [Learning Videos] ===============================
  static const String placeHolder = 'assets/images/learning/screen.png';
  static const String videoPlaceHolder =
      'assets/lotties/video_learning/videoplaceholder.json';

  ///*======================== [ Boarding Screens ] ============================
  static const String boarding1En = 'assets/images/boarding/boarding_1_en.png';
  static const String boarding2En = 'assets/images/boarding/boarding_2_en.png';
  static const String boarding3En = 'assets/images/boarding/boarding_3_en.png';
  static const String boarding4En = 'assets/images/boarding/boarding_4_en.png';
  static const String boarding1Ar = 'assets/images/boarding/boarding_1_ar.png';
  static const String boarding2Ar = 'assets/images/boarding/boarding_2_ar.png';
  static const String boarding3Ar = 'assets/images/boarding/boarding_3_ar.png';
  static const String boarding4Ar = 'assets/images/boarding/boarding_4_ar.png';
  //!===========================================================================
  //!===========================================================================
}
