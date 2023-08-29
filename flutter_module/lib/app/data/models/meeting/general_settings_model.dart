class GeneralSettingsModel {
  //*===========================================================================
  //*================================ Parameters ===============================
  //*===========================================================================
  final bool isUserNameMandatory;
  final bool isMeetingNameMandatory;
  final bool isSelectEngineMandatory;
  //*===========================================================================
  //*================================ Constructor ==============================
  //*===========================================================================
  const GeneralSettingsModel({
    required this.isMeetingNameMandatory,
    required this.isSelectEngineMandatory,
    required this.isUserNameMandatory,
  });
  //*===========================================================================
  //*================================= Methods =================================
  //*===========================================================================
  factory GeneralSettingsModel.fromJson(Map<String, dynamic> json) =>
      GeneralSettingsModel(
        isMeetingNameMandatory: json['meeting_name']['mandatory'],
        isSelectEngineMandatory: json['select_engine']['mandatory'],
        isUserNameMandatory: json['user_name']['mandatory'],
      );
  //*==================================================
}
