import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// To store different informatino about each [langauage] that this
/// application supports
class LanguageModel extends Equatable {
  //*================================ Properties ===============================
  final Locale locale;
  final String localeLangCode;
  final String mainFontFamily;
  //*================================ Constructor ==============================
  const LanguageModel({
    required this.locale,
    required this.mainFontFamily,
    required this.localeLangCode,
  });
  //*================================== Methods ================================
  factory LanguageModel.fromJson(dynamic jsonLanguage) => LanguageModel(
        locale: Locale(
          jsonLanguage['locale']['languageCode'],
          jsonLanguage['locale']['countryCode'],
        ),
        mainFontFamily: jsonLanguage['mainFontFamily'],
        localeLangCode: jsonLanguage['locale']['languageCode'],
      );
  //*==================================================
  Map<String, dynamic> toJson() => {
        'locale': {
          'countryCode': locale.countryCode,
          'languageCode': locale.languageCode,
        },
        'mainFontFamily': mainFontFamily,
      };
  //*===========================================================================
  @override
  List<Object?> get props => [
        locale,
        mainFontFamily,
      ];
  //*===========================================================================
  //*===========================================================================
}
