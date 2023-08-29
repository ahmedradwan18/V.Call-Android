import 'package:flutter/material.dart';

import '../../routes/app_pages.dart';

class AppKeys {
  //!=============================== Constructor ===============================
  static final AppKeys _singleton = AppKeys._internal();
  factory AppKeys() {
    return _singleton;
  }
  AppKeys._internal();
  //!=============================== Properties ================================
  /// give each route in the 'Apppages.routes' list it's own 'NavigationKey'
  /// to achieve the 'Independent navigator stack'
  static final customNavigatorsKeysMap = {
    for (var element in AppPages.routes)
      element.name: GlobalKey<NavigatorState>(
        debugLabel: element.name,
      )
  };

  /// [contactView] FormKey for the form with 'Add Contact' FormTextField
  ///  in  [Addcontact bottom sheet]
  static final GlobalKey<FormState> contactViewFormKey =
      GlobalKey<FormState>(debugLabel: DateTime.now().millisecond.toString());

  /// [roomView] key for the form that contains two textfields
  ///  'room title' and 'room description'
  static final GlobalKey<FormState> roomViewFormKey =
      GlobalKey<FormState>(debugLabel: DateTime.now().millisecond.toString());

  /// [creditCardFormKey] key for the form that contains multiple textfields
  ///  at [PaymentView]
  static final GlobalKey<FormState> creditCardFormKey =
      GlobalKey<FormState>(debugLabel: DateTime.now().millisecond.toString());

  //!===========================================================================
}
