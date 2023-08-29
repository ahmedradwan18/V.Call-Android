import 'package:flutter/widgets.dart';

import '../../enums/search/filter_type.dart';

class SearchFilterModel {
  //*===========================================================================
  //*================================ Parameters ===============================
  //*===========================================================================
  final Widget leading;
  final Widget title;
  final Function? onTap;
  final bool showTrailingWidget;
  final FilterType filterType;
  final bool visible;
  //*===========================================================================
  //*================================ Constructor ==============================
  //*===========================================================================

  const SearchFilterModel({
    required this.leading,
    required this.title,
    required this.filterType,
    this.onTap,
    this.showTrailingWidget = true,
    this.visible = true,
  });
  //*==================================================
  factory SearchFilterModel.fromOld({
    required SearchFilterModel oldItem,
    Widget? leading,
    Widget? title,
    Function? onTap,
    bool? showTrailingWidget,
    FilterType? filterType,
    bool? visible,
  }) =>
      SearchFilterModel(
        leading: leading ?? oldItem.leading,
        title: title ?? oldItem.title,
        filterType: filterType ?? oldItem.filterType,
        onTap: onTap ?? oldItem.onTap,
        visible: visible ?? oldItem.visible,
        showTrailingWidget: showTrailingWidget ?? oldItem.showTrailingWidget,
      );
  //*===========================================================================
  //*================================= Methods =================================
  //*===========================================================================

  //*===========================================================================
  //*===========================================================================
}
