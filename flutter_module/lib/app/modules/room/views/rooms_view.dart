import 'package:flutter/material.dart';
import 'package:flutter_module/app/core/utils/extensions.dart';
import 'package:get/get.dart';
import '../../meetings/views/meetings_view.dart';
import '../controllers/rooms_controller.dart';
import '../widgets/room_chart.dart';

class RoomsView extends GetView<RoomsController> {
  //*================================ Properties ===============================

  //*================================ Constructor ==============================
  const RoomsView({Key? key}) : super(key: key);

  //*================================= Methods =================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: (0.01).hf,
              ),
              child: const RoomChart(),
            ),
            const Expanded(
              child: MeetingsView(),
            )
          ],
        ),
      ),
    );
  }
  //*===========================================================================
}
