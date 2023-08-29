import 'package:flutter/material.dart';

import 'custom_animated_switcher.dart';
import 'loader.dart';

class PaginationIndicator extends StatelessWidget {
  //*================================ Properties ===============================
  final bool isFetchingMoreData;
  final Axis? axis;
  //*================================ Constructor ==============================
  const PaginationIndicator({
    required this.isFetchingMoreData,
    this.axis,
    Key? key,
  }) : super(key: key);

  //*================================= Methods =================================
  @override
  Widget build(BuildContext context) {
    //*================================ Properties =============================
    final axis = this.axis ?? Axis.vertical;
    //*=========================================================================
    return CustomAnimatedSwitcher(
      axis: axis,
      child: (isFetchingMoreData)
          ? const Center(child: Loader())
          : const SizedBox.shrink(),
    );
  }
  //*===========================================================================
  //*===========================================================================
}
