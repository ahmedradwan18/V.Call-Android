import 'package:flutter/material.dart';

class CustomBottomSheet extends StatelessWidget {
  //*================================ Properties ===============================
  final bool isSecondChildVisible;
  final Widget firstBottomSheetChild;
  final Widget secondBottomSheetChild;
  //*================================ Constructor ==============================
  const CustomBottomSheet({
    required this.isSecondChildVisible,
    required this.firstBottomSheetChild,
    required this.secondBottomSheetChild,
    Key? key,
  }) : super(key: key);

  //*================================= Methods =================================

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      firstChild: firstBottomSheetChild,
      secondChild: secondBottomSheetChild,
      duration: const Duration(milliseconds: 400),
      crossFadeState: isSecondChildVisible
          ? CrossFadeState.showSecond
          : CrossFadeState.showFirst,
    );
  }
  //*===========================================================================

}
