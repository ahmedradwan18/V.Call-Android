import 'package:flutter/material.dart';
import 'package:flutter_module/app/core/utils/extensions.dart';

import '../../../themes/app_colors.dart';
import '../../../widgets/custom_spacer.dart';
import '../../../widgets/custom_svg.dart';
import '../../../widgets/text/custom_text.dart';

class CustomActionTile extends StatelessWidget {
  //*================================ Parameters ===============================
  final String title;
  final String svgPath;
  final VoidCallback onTap;
  final bool isButton;
  final double? width;
  final BorderRadiusGeometry? borderRadius;
  final double? widthBeforeIcon;
  //*================================ Constructor ==============================
  const CustomActionTile({
    required this.svgPath,
    required this.onTap,
    required this.title,
    this.width,
    this.borderRadius,
    this.widthBeforeIcon,
    this.isButton = false,
    super.key,
  });
  //*================================= Methods =================================
  @override
  Widget build(BuildContext context) {
    //*=========================================================================
    //*=========================================================================
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width ?? (0.856).wf,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: borderRadius ?? BorderRadius.circular(9.0),
          color: AppColors.greyTileColor,
        ),
        child: Row(
          children: [
            CustomSpacer(widthFactor: widthBeforeIcon),
            CustomSvg(
              svgPath: svgPath,
              heightFactor: 0.02,
            ),
            const CustomSpacer(
              widthFactor: 0.01,
            ),
            CustomText(title),
            const Spacer(),
            if (!isButton)
              const Icon(
                Icons.chevron_right,
                color: AppColors.grey,
              ),
          ],
        ),
      ),
    );
  }
  //*===========================================================================
}
