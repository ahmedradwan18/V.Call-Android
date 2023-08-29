import 'package:equatable/equatable.dart';

import '../data/enums/meeting_type.dart';

class RoomTitleValueModel extends Equatable {
  //*================================ Properties ===============================
  final String roomID;
  final String roomTitle;
  final MeetingType engineType;
  //*================================ Constructor ==============================
  const RoomTitleValueModel({
    required this.roomTitle,
    required this.roomID,
    required this.engineType,
  });
  //*==================================================
  @override
  List<Object?> get props => [
        roomID,
        roomTitle,
      ];
  //*===========================================================================
}
