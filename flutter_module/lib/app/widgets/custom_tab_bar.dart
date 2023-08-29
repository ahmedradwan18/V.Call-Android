import 'package:flutter/material.dart';
import 'package:flutter_module/app/core/utils/extensions.dart';

class CustomTabBar extends StatelessWidget implements PreferredSizeWidget {
  //*================================ Parameters ===============================
  final Function(int newIndex)? onTap;
  final List<String> tabList;
  final double topPadding;
  final Color? borderColor;
  final double? tabContentHorizontalPadding;
  final double? tabContentVerticalPadding;
  final TabController? tabBarController;
  final Decoration? indicator;
  final bool centerTabs;
  final bool isScrollable;
  final EdgeInsetsGeometry? labelPadding;
  //*================================ Constructor ==============================
  const CustomTabBar({
    Key? key,
    this.onTap,
    required this.tabList,
    this.topPadding = 0.0,
    this.borderColor,
    this.tabContentHorizontalPadding,
    this.tabContentVerticalPadding,
    this.tabBarController,
    this.centerTabs = false,
    this.isScrollable = false,
    this.labelPadding,
    this.indicator,
  }) : super(key: key);

  //*================================= Methods =================================

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + topPadding);
  //*==================================================
  @override
  Widget build(BuildContext context) {
    //*================================ Properties =============================
    final tabContentVerticalPadding =
        this.tabContentVerticalPadding ?? (0.013).hf;
    //*=========================================================================
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: (0.11).wf,
      ),
      child: DecoratedBox(
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey,
              width: 1.7,
            ),
          ),
        ),
        child: TabBar(
          controller: tabBarController,
          onTap: onTap,
          indicator: indicator,
          isScrollable: isScrollable,
          enableFeedback: true,
          labelPadding: labelPadding,
          tabs: tabList
              .map(
                (element) => Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: tabContentHorizontalPadding ?? 0.0,
                    vertical: tabContentVerticalPadding,
                  ),
                  child: Text(
                    element,
                    maxLines: 1,
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  //*=========================================================================
  //*=========================================================================
}
