import 'package:flutter/material.dart';

import '../../data/models/language_model.dart';
import 'environment.dart';

/// Terminology:
/// View: GetX View
/// Page: pageViewBody
/// Screen: Widget with it's own Scaffold
/// this will be for the constants used throughout the app
class AppConstants {
  //!=============================== Constructor ===============================
  static final AppConstants _singleton = AppConstants._internal();
  factory AppConstants() {
    return _singleton;
  }
  AppConstants._internal();
  //!============================== Environment ================================
  //TODO(1/4): Update Environment If Necessary
  static const Environment environment = Environments.development;
  //!================================ Links ====================================
  static const String vlcHomePageUrl = 'https://vconnct.me/';
  static const String shareAppDynamicLink =
      'https://variiancevlc.page.link/store';
  //!============================= Pararmeters =================================
  //TODO(2/4): Update app version for the [App Wall]
  static const String appVersion = '5.7.5';

  static const String appStoreID = '1603246524';
  static const String googlePlayStoreLink =
      'https://play.google.com/store/apps/deubtails?id=com.variiance.vlc';
  static const String appleStoreLink =
      'https://apps.apple.com/app/variiance-vlc/id$appStoreID';
  static const int meetingNeedsPasswordErrorCode = 90004;
  static const int meetingHasWaitingRoom = 90010;
  static const int meetingAlreadyProgress = 90001;
  static const int meetingDifferentEngine = 90011;
  static const LanguageModel arabic = LanguageModel(
    locale: Locale('ar', 'EG'),
    mainFontFamily: 'Noto Kufi Arabic',
    localeLangCode: 'ar_Ar',
  );
  static const LanguageModel english = LanguageModel(
    locale: Locale('en', 'US'),
    mainFontFamily: 'Poppins',
    localeLangCode: 'en_En',
  );
  // SUPPORTED LACALES
  static const int maxSearchBarResultsLength = 6;
  static const int maxCreditCardNumberLength = 16;
  static const int maxPhoneNumberLength = 11;
  static const int maxCreditCardExpiryDateLength = 4;
  static const int maxCreditCardCVCLength = 4;
  static const Curve navigationCurve = Curves.easeInOutQuad;
  static const Duration navigationDuration = shortDuration;
  static const int listToPaginationLoaderFlex = 5;
  static const int egyptCountryIndex = 64;
  //!============================= TAWK CHAT ===================================
  static const String _tawkDirectChatLinkBaseUrl =
      'https://tawk.to/chat/6318cf1837898912e967d003';
  static const String tawkEnglishDirectChatLink =
      '$_tawkDirectChatLinkBaseUrl/1gce8qo6a';
  static const String tawkArabicDirectChatLink =
      '$_tawkDirectChatLinkBaseUrl/1gcejpj9s';

  //!============================= 'variiance SSO' =============================
  static const String clientID = 'vlc_mobile';
  static const List<String> ssoScopeList = [
    'openid',
    'offline_access',
    'profile',
    'email',
    'address',
    'phone',
    'roles',
    'web-origins',
    'microprofile-jwt',
    'image'
  ];

  //!===========================================================================
  static const Duration meetingDurationEndPoint = Duration(hours: 1);
  static const Duration tabControllerAnimationDuration =
      Duration(milliseconds: 400);
  static const Duration shortDuration = Duration(milliseconds: 300);
  static const Duration subMediumDuration = Duration(milliseconds: 450);
  static const Duration mediumDuration = Duration(milliseconds: 600);
  static const Duration subLongDuration = Duration(milliseconds: 750);
  static const Duration longDuration = Duration(milliseconds: 1000);
  //!================================ Strings ==================================
  static const String somethingWentWrongText = 'something_went_wrong';
  static const String proPackageType = 'VLCPackage';
  static const String randomGenerationPool =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';

  //!===========================================================================
  //!===========================================================================
  //!===========================================================================
  //!===========================================================================

  static const categories = 'Categories';
  static const authors = 'Authors';
}
