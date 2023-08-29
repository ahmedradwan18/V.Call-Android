import 'package:get/get.dart';

import '../modules/creation/bindings/creation_binding.dart';
import '../modules/creation/views/creation_view.dart';
import '../modules/meetings/bindings/meetings_binding.dart';
import '../modules/meetings/views/meetings_view.dart';
import '../modules/room/bindings/room_binding.dart';
import '../modules/room/views/rooms_view.dart';
import '../modules/vlc/bindings/vlc_binding.dart';
import '../modules/vlc/views/vlc_view.dart';

part 'app_routes.dart';

class AppPages {
  static const home = Routes.room;

  static final routes = [
    //! [Views w/o bindings]

    GetPage(
      name: _Paths.meetings,
      page: () => const MeetingsView(),
      binding: MeetingsBinding(),
    ),

    GetPage(
      name: _Paths.rooms,
      page: () => const RoomsView(),
      binding: RoomBinding(),
    ),

    GetPage(
      name: _Paths.vlc,
      page: () => const VlcView(),
      binding: VlcBinding(),
    ),
    GetPage(
      name: _Paths.schedule,
      page: () => const ScheduleView(),
      binding: CreationBinding(),
    ),
  ];
}
