import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:get/get.dart';
// import 'package:vlc/app/core/helpers/helpers.dart';
// import 'package:vlc/app/core/services/logging_service.dart';
// import 'package:vlc/app/themes/app_theme.dart';

import '../../data/models/language_model.dart';
import '../../language/arabic.dart';
import '../../language/english.dart';
import '../values/app_constants.dart';

// this will hold the strings used throughout the application and will
// also be used for translation purposes
class LocalizationService extends Translations {
  //!================================ Constructor ==============================
  //!=============================== Constructor ===============================
  static final LocalizationService _singleton = LocalizationService._internal();
  factory LocalizationService() {
    return _singleton;
  }
  LocalizationService._internal();
  //!=========================================================================
  //!================================ Properties ===============================
  //!==================================================
  @override
  Map<String, Map<String, String>> get keys => {
        'ar_EG': Arabic.text,
        'en_US': English.text,
      };

  static const String _localStorageLanguageKey = 'preferred_language';

  static final _supportedLanguages = <LanguageModel>[
    (AppConstants.arabic),
    (AppConstants.english),
  ];

  static final supportedLocales =
      _supportedLanguages.map((e) => e.locale).toList();

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = [
    // GlobalMaterialLocalizations.delegate,
    // GlobalWidgetsLocalizations.delegate,
    // GlobalCupertinoLocalizations.delegate,
  ];

  static const fallbackLanguage = (AppConstants.english);
  static final fallbackLocale = (AppConstants.english.locale);

  static String get languageCode => Get.locale != null
      ? Get.locale!.languageCode
      : Get.deviceLocale!.languageCode;

  static String get countryCode => Get.locale != null
      ? Get.locale!.countryCode ?? ''
      : Get.deviceLocale!.countryCode ?? '';

  static var appLanguage = (AppConstants.english);

  static bool get isEnglish => (appLanguage == AppConstants.english);

  static bool get isLTR => appLanguage == AppConstants.english;

  static TextDirection get textDirection =>
      appLanguage.locale == supportedLocales[1]
          ? TextDirection.ltr
          : TextDirection.rtl;

  // //!==================================================
  // static Future<void> checkForPreferredLanguage() async {
  //   try {
  //     // Read any saved data
  //     const FlutterSecureStorage localStorageDriver = FlutterSecureStorage();

  //     final jsonStringPrefferedLanguage = await localStorageDriver.read(
  //       key: _localStorageLanguageKey,
  //     );

  //     // if data != null, then the user saved a token before
  //     if (jsonStringPrefferedLanguage != null) {
  //       final jsonPrefferedLanguage = json.decode(jsonStringPrefferedLanguage);
  //       appLanguage = LanguageModel.fromJson(jsonPrefferedLanguage);
  //     }

  //     // data = null, then there isn't any token saved
  //     else {
  //       final locale = Get.deviceLocale ?? Get.fallbackLocale;

  //       appLanguage = _supportedLanguages.firstWhere(
  //         (lang) => lang.locale.languageCode == locale?.languageCode,
  //         orElse: () => fallbackLanguage,
  //       );

  //       // Save it to be used as an idicator whether or not the app has been
  //       // launched before
  //       await _saveLanguageLocally();
  //     }
  //   } catch (e) {
  //     LoggingService.error(
  //       'Error at Method:checkForPreferredLanguage -- localization_service.dart',
  //       e,
  //       StackTrace.current,
  //     );
  //     appLanguage = fallbackLanguage;
  //   }
  // }
  // //!==================================================

  // // Method Prototype is like that cuz of calling widget's restriction
  // static Future<bool?> changeAppLanguage(LanguageModel language) async {
  //   // the new locale is the same as the old .. do nothing
  //   if (Get.locale == language.locale) return null;

  //   await _changeLanguage(language);

  //   // to show the animation
  //   return true;
  // }

  // //!==================================================
  // // Method Prototype is like that cuz of calling widget's restriction
  // static Future<void> _changeLanguage(LanguageModel language) async {
  //   try {
  //     // change locally for the widget[LanguageButton] to rebuild
  //     appLanguage = language;
  //     await _saveLanguageLocally();

  //     // change the language globally
  //     await Get.updateLocale(language.locale);

  //     // Update App Theme
  //     AppTheme.updateAppTheme();

  //     // Reset App State
  //     await Helpers.restartApp();
  //   } catch (e) {
  //     LoggingService.error(
  //       'Error at Method:_changeLanguage -- localization_service.dart',
  //       e,
  //       StackTrace.current,
  //     );
  //     await Get.updateLocale(fallbackLocale);
  //   }
  // }

  // //!==================================================
  // static Future<void> _saveLanguageLocally() async {
  //   // Save the selected language in local storage
  //   // 1] get instance of local storage driver
  //   const FlutterSecureStorage localStorageDriver = FlutterSecureStorage();
  //   // 2] convert [Language] => [json]
  //   final jsonLanguage = json.encode(appLanguage);
  //   // 3] write the json object into storage
  //   await localStorageDriver.write(
  //     key: _localStorageLanguageKey,
  //     value: jsonLanguage,
  //   );
  // }

  // //!===========================================================================
}
