import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:get/get_utils/src/extensions/string_extensions.dart';
import 'package:get/get_utils/src/get_utils/get_utils.dart';

class ValidationService {
  //*===========================================================================
  //*=============================== Constructor ===============================
  //*===========================================================================
  static const ValidationService _singleton = ValidationService._internal();
  factory ValidationService() {
    return _singleton;
  }
  const ValidationService._internal();
  //*===========================================================================
  //*=============================== Properties ================================
  //*===========================================================================

  //*===========================================================================
  //*================================ Methods ==================================
  //*===========================================================================
  static String cleanUpText(String text) {
    return text.trim().removeAllWhitespace;
  }

  //*==================================================
  static String? roomValidation({
    String? inputText,
    String? label,
    bool allowEmpty = false,
    bool allowNumbers = true,
    bool allowSpace = false,
  }) {
    // the validator of [TextFormField] wants [null] if the String is
    // acceptable, and a string to display if it's not acceptable.
    if (inputText == null) return null;
    final text = allowSpace ? inputText.trim() : cleanUpText(inputText);

    if (text.isEmpty && !allowEmpty) {
      return '$label ${'no_empty_field'.tr}';
    }
    if (text.length < 3 && !allowEmpty) {
      return '$label ${'too_small_3_char_min'.tr}';
    }

    // // Allow English and Arabic characters
    // const String alphabetsWithNumbers = r'^[a-zA-Z٠-٩ا-ي0-9\s]+$';
    // const String alphabetsOnly = r'^[a-zA-Zا-ي\s]+$';

    // final regex = allowNumbers ? alphabetsWithNumbers : alphabetsOnly;

    // final isDigitsOnly = GetUtils.hasMatch(text, r'^[\p{Arabic}\s\p{٠-٩}]+$') ||
    //     GetUtils.isNumericOnly(text);

    // if (!allowEmpty && (!GetUtils.hasMatch(text, regex) || isDigitsOnly)) {
    //   return '${'invalid_input_field'.tr} $label';
    // }

    // All is good.
    return null;
  }

  //*==================================================
  static String? alphaNumeral({
    String? inputText,
    String? label,
    bool allowEmpty = false,
    bool allowNumbers = true,
    bool allowSpace = false,
  }) {
    // the validator of [TextFormField] wants [null] if the String is
    // acceptable, and a string to display if it's not acceptable.
    if (inputText == null) return null;
    final text = allowSpace ? inputText.trim() : cleanUpText(inputText);

    if (text.isEmpty && !allowEmpty) {
      return '$label ${'no_empty_field'.tr}';
    }
    if (text.length < 3 && !allowEmpty) {
      return '$label ${'too_small_3_char_min'.tr}';
    }

    // Allow English and Arabic characters
    const String alphabetsWithNumbers = r'^[a-zA-Z٠-٩ا-ي0-9\s]+$';
    const String alphabetsOnly = r'^[a-zA-Zا-ي\s]+$';

    final regex = allowNumbers ? alphabetsWithNumbers : alphabetsOnly;

    final isDigitsOnly = GetUtils.hasMatch(text, r'^[\p{Arabic}\s\p{٠-٩}]+$') ||
        GetUtils.isNumericOnly(text);

    if (!allowEmpty && (!GetUtils.hasMatch(text, regex) || isDigitsOnly)) {
      return '${'invalid_input_field'.tr} $label';
    }

    // All is good.
    return null;
  }

  //*==================================================
  static String? validateMeetingID(String? inputText) {
    if (inputText == null) return null;
    final text = cleanUpText(inputText);

    if (text.isEmpty) {
      return '${'meeting_id'.tr} ${'no_empty_field'.tr}';
    }
    if (text.length < 3) {
      return '${'meeting_id'.tr} ${'too_small_3_char_min'.tr}';
    }
    if (!GetUtils.hasMatch(
      text,
      r'^[A-Za-z0-9_]+$',
    )) return 'invalid_meeting_id'.tr;

    return null;
  }

  //*==================================================
  /// validate the [Meeting's Title] formTextField in [createMeetingView]
  static String? validateMeetingTitle(String? inputText) {
    if (inputText == null) return null;
    final text = cleanUpText(inputText);

    if (text.isEmpty) return '${'title'.tr} ${'no_empty_field'.tr}';
    if (text.length < 3) {
      return '${'title'.tr} ${'too_small_3_char_min'.tr}';
    }
    return null;
  }

  //*==================================================
  /// validate the [Meeting's Password] formTextField
  static String? validatePassword(String? inputText) {
    if (inputText == null) return null;
    final text = cleanUpText(inputText);

    if (text.isEmpty) {
      return '${'password'.tr} ${'no_empty_field'.tr}';
    }

    if (text.length < 3) {
      return '${'password'.tr} ${'too_small_3_char_min'.tr}';
    }

    return null;
  }

  //*==================================================
  static String? validateConfrimPassword({
    required String inputPassword,
    required String inputConfrimPassword,
  }) {
    final passwordValidation = validatePassword(inputConfrimPassword);
    if (passwordValidation != null) return passwordValidation;

    final password = cleanUpText(inputPassword);
    final confrimPassword = cleanUpText(inputConfrimPassword);

    if (password != confrimPassword) {
      return 'Password_Not_Matching'.tr;
    }
    return null;
  }

  //*==================================================
  static String? validatePhoneNumber(String? inputText) {
    if (inputText == null) return null;
    final text = cleanUpText(inputText);

    if (text.isEmpty) {
      return '${'phone_number_label'.tr} ${'no_empty_field'.tr}';
    }

    if (!GetUtils.isNumericOnly(text)) {
      return '${'invalid_input_field'.tr} ${'phone_number_label'.tr}';
    }
    if (!GetUtils.hasMatch(text, r'^(01|00201|\+201|201)[0|1|2|5]{1}\d{8}$') ||
        !GetUtils.isPhoneNumber(text)) {
      return '${'invalid_input_field'.tr} ${'phone_number_label'.tr}';
    }
    return null;
  }
  //*==================================================

  static String? validateEmailAddress(String? inputText) {
    if (inputText == null) return null;
    final text = cleanUpText(inputText);

    if (text.isEmpty) {
      return '${'email_address_label'.tr} ${'no_empty_field'.tr}';
    }

    if (!GetUtils.isEmail(text)) {
      return 'not_valid_email'.tr;
    }

    return null;
  }
  //*==================================================

  static String? validateCreatMeetingPassword(String? inputText) {
    if (inputText == null) return null;
    final text = cleanUpText(inputText);

    if (text.isEmpty) {
      return null;
    }

    if (text.length < 3) {
      return '${'password'.tr} ${'too_small_3_char_min'.tr}';
    }

    return null;
  }
  //*==================================================

  //*===========================================================================
  //*===========================================================================
}
