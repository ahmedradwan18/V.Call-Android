import 'package:flutter/material.dart';

import 'custom_tab_bar.dart';

class CustomSliverAppBar extends StatelessWidget {
  //*================================ Properties ===============================
  final List<String>? tabList;
  final dynamic Function(int)? onTap;
  //*================================ Constructor ==============================
  const CustomSliverAppBar({Key? key, this.tabList, this.onTap})
      : super(key: key);

  //*================================= Methods =================================
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      pinned: true,
      floating: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      expandedHeight: 0,
      bottom: CustomTabBar(
        tabList: tabList!,
        onTap: onTap,
      ),
    );
  }
  //*===========================================================================
}
