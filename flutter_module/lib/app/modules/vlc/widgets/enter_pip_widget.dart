import 'package:flutter/material.dart';
import 'package:flutter_module/app/modules/vlc/widgets/tool_button.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import '../../../core/values/app_images_paths.dart';
import '../../../widgets/loader.dart';

class EnterPIPWidget extends StatelessWidget {
  //*===========================================================================
  //*================================ Parameters ===============================
  //*===========================================================================
  final Future<bool> isPipAvailable;
  final VoidCallback? onPressed;
  //*===========================================================================
  //*================================ Constructor ==============================
  //*===========================================================================
  const EnterPIPWidget({
    Key? key,
    required this.isPipAvailable,
    this.onPressed,
  }) : super(key: key);

  //*===========================================================================
  //*================================= Methods =================================
  //*===========================================================================

  @override
  Widget build(BuildContext context) {
    //*================================ Properties =============================
    final toolTip = 'minimize_meeting'.tr;
    //*=========================================================================
    return FutureBuilder<bool>(
      future: isPipAvailable,
      builder: (_, snapshot) {
        //* Check if I have any data
        if (snapshot.hasData) {
          return ToolButton(
            svgPath: AppImagesPaths.pipModeSvg,
            onPressed: onPressed,
            tooltip: toolTip,
          );
        }

        //* Check if it has an error
        else if (snapshot.hasError ||
            ((snapshot.connectionState == ConnectionState.done) &&
                (!snapshot.hasData))) {
          return const SizedBox.shrink();
        }

        //* By default, show a loading spinner.
        return const Center(
          child: Loader(isWhite: true),
        );
      },
    );
    //*=========================================================================
    //*=========================================================================
  }
}
