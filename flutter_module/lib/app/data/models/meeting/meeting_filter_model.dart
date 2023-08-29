import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class MeetingFilterModel extends Equatable {
  //*===========================================================================
  //*================================ Parameters ===============================
  //*===========================================================================
  List<String> roomList;
  String startDate;
  String endDate;
  bool showRecorded;
  bool showNotRecorded;
  //*===========================================================================
  //*================================ Constructor ==============================
  //*===========================================================================
  MeetingFilterModel({
    required this.roomList,
    required this.startDate,
    required this.endDate,
    required this.showRecorded,
    required this.showNotRecorded,
  });
  //*==================================================
  factory MeetingFilterModel.empty() => MeetingFilterModel(
        roomList: const <String>[],
        startDate: '',
        endDate: '',
        showRecorded: true,
        showNotRecorded: false,
      );

  //*===========================================================================
  //*================================= Methods =================================
  //*===========================================================================

  @override
  String toString() {
    return {
      'roomList': roomList.toString(),
      'beginDate': startDate.isEmpty ? '-' : startDate,
      'endDate': endDate.isEmpty ? '-' : endDate,
      'showRecorded': showRecorded,
      'showNotRecorded': showNotRecorded,
    }.toString();
  }
  //*==================================================

  @override
  List<Object?> get props => [
        roomList,
        startDate,
        endDate,
        showRecorded,
        showNotRecorded,
      ];
  //*===========================================================================
  //*===========================================================================
}
