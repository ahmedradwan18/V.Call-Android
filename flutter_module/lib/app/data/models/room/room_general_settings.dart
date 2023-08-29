import 'package:get/get.dart';

import '../../enums/meeting_type.dart';

class GeneralSettings {
  //*================================ Properties ===============================
  final String titleAr;
  final String titleEn;
  final String? descriptionEn;
  final String? descriptionAr;
  final bool isEditable;
  final String key;
  final RxBool isOn;
  final bool? isGeneral;
  final MeetingType? engineType;

  //*================================ Constructor ==============================
  const GeneralSettings({
    required this.titleAr,
    required this.titleEn,
    required this.descriptionEn,
    required this.descriptionAr,
    required this.isOn,
    required this.isEditable,
    required this.key,
    this.isGeneral,
    this.engineType,
  });
  //*================================= Methods =================================
  factory GeneralSettings.fromJson(Map<String, dynamic> json) =>
      GeneralSettings(
          titleAr: json['setting_title']['ar'],
          titleEn: json['setting_title']['en'],
          descriptionEn: json['setting_description']['en'],
          descriptionAr: json['setting_description']['ar'],
          isOn: (json['setting_value'] == true).obs,
          isEditable: json['editable'],
          key: json['setting_key'],
          isGeneral: false,
          engineType: MeetingType.meet);
  //*=================================================
  Map<String, dynamic> toJson() => {
        'setting_title': {
          'en': titleEn,
          'ar': titleAr,
        },
        'setting_description': {
          'en': descriptionEn,
          'ar': descriptionAr,
        },
        'setting_value': isOn.value,
        'editable': isEditable,
        'setting_key': key,
      };
}
