import 'package:flutter/material.dart';

class AppColors {
  //!=============================== Constructor ===============================
  static const AppColors _singleton = AppColors._internal();
  factory AppColors() {
    return _singleton;
  }
  const AppColors._internal();
  //!=============================== Properties ================================
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color grey = Color(0xff7B8491);
  static const Color darkGrey = Color(0xff6B798E);
  static const Color lightBlack = Color(0xff7B8491);

  static const Color lightGrey = Color(0xffEEF1F5);
  static const Color veryLightGrey = Color.fromARGB(255, 244, 242, 238);
  static const Color primaryColor = Color(0xff00969E);
  static const Color secondaryColor = Color(0xffe18022);
  static const Color lightSecondaryColor = Color(0xffFFF1E3);

  static const Color scaffoldBackgroundColor = Color(0xffF9FAFF);
  static const Color meetingBackgroundColor = Color(0xFF1A1A1A);

  // static const Color primaryColor = Color(0xff00969E);
  // static const Color lightPrimaryColor = Color(0xffD9EFF1);
  static final primaryColorAlpha80 = primaryColor.withAlpha(80);
  static final lightPrimaryColor = primaryColor.withOpacity(0.2);
  static const lightPrimary = Color(0xffBBEAED);
  static final veryLightPrimaryColor = primaryColor.withOpacity(0.3);
  static final promoCodeGradientColor = primaryColor.withOpacity(0.15);
  static const Color lime = Color(0xFFbdca33);
  static const Color red400 = Color(0xFFEF5350);
  static final Color lightBlue = Colors.blue.shade50;
  static final Color lightGreen = Colors.green.shade50;
  static final Color lightOrange = Colors.orange.shade50;

  static final Color lightErrorColor = Colors.red.shade500;
  static final Color shadowColor = Colors.grey.withOpacity(0.3);
  static const Color errorColor = Colors.red;
  static const Color dangerColor = Color(0xffD04646);
  static const Color heartColor = Color(0xffFA2D00);
  static const Color orangeColor = Color(0xffF68A21);
  static const Color lightGreyColor = Color(0xffE2E2E3);
  static const Color lightBlackColor = Color(0xff303030);
  static const Color greyColor = Color(0xffA8A3A3);
  static const Color lightGreyColor2 = Color(0xffCECFD0);
  static const Color lightGreyColor3 = Color(0xff9D9FA0);
  static const Color terquazColor = Color(0xff0C857B);

  static const Color hazardColor = Color(0xFF9e0e00);

  static const Color transparent = Colors.transparent;
  static const Color upcomingMeetingColor = Colors.purple;
  static const Color sharedMeetingColor = Colors.orange;
  static final Color blue = Colors.blue.shade600;
  static const Color green = Color(0xff42A566);

  static final Color snackBarActionColor = Colors.green.shade500;
  static final Color snackBarInformationColor = Colors.blue.shade500;

  static const Color lightBorderColor = Color(0xffE6E6E6);
  static const Color basicEnterprisePackageContainerColor = Color(0xffFFF6EB);
  static const Color premiumPackageContainerColor = primaryColor;

  static const Color packageFeatureListTileColor = Color(0xff737373);

  static const Color greyTileColor = Color(0xffF4F5F7);
  static const Color roomSettingsBackground =
      Color.fromARGB(255, 229, 229, 230);

  //!===========================================================================
  //!===========================================================================
}
