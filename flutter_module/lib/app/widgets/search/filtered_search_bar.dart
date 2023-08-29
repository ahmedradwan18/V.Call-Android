import 'package:flutter/material.dart';
import 'package:flutter_module/app/core/utils/extensions.dart';
import 'package:flutter_module/app/widgets/search/search_filter_list.dart';

import '../../core/utils/design_utils.dart';
import '../../core/values/app_images_paths.dart';
import '../../data/models/search/search_filter_model.dart';
import '../../themes/app_colors.dart';
import '../custom_spacer.dart';
import '../custom_svg.dart';
import '../textfields/search_text_field.dart';

class FilteredSearchBar extends StatelessWidget {
  //*===========================================================================
  //*================================ Properties ===============================
  //*===========================================================================
  final TextEditingController textFieldController;
  final String hintText;
  final List<SearchFilterModel> searchFilterList;
  final ScrollPhysics? scrollPhysics;
  final OnSearchQueryChanged? onSearchQueryChanged;
  final OnSearchQueryChanged? onSearchFieldSubmitted;
  final VoidCallback? onSearchFieldCleared;
  final Animation<double>? animation;
  //*===========================================================================
  //*================================ Constructor ==============================
  //*===========================================================================
  const FilteredSearchBar({
    required this.searchFilterList,
    required this.textFieldController,
    required this.hintText,
    this.scrollPhysics,
    super.key,
    this.onSearchQueryChanged,
    this.onSearchFieldCleared,
    this.animation,
    this.onSearchFieldSubmitted,
  });

  //*===========================================================================
  //*================================ Methods ==================================
  //*===========================================================================
  @override
  Widget build(BuildContext context) {
    //*================================ Properties =============================
    const transparentColor = AppColors.transparent;
    const double elevation = 7.0;

    final contentHorizontalPadding = (0.04).wf;
    //*=========================================================================
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: transparentColor,
        splashColor: transparentColor,
        highlightColor: transparentColor,
      ),
      child: Material(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: DesignUtils.getBorderRadius(radius: 8.0),
          side: const BorderSide(
            color: AppColors.lightBorderColor,
          ),
        ),
        elevation: elevation,
        child: ExpansionTile(
          // NEEDS A KEY TO FUNCTION PROPERLY
          key: const PageStorageKey<String>('ExpansionTileKey'),
          childrenPadding: EdgeInsets.only(
            left: contentHorizontalPadding,
            right: contentHorizontalPadding,
            bottom: (0.014).hf,
          ),

          title: SearchTextField(
            // NEEDS A KEY TO FUNCTION PROPERLY
            key: const PageStorageKey<String>('SearchTextFieldKey'),
            textFieldController: textFieldController,
            onQueryChanged: onSearchQueryChanged,
            onTextFieldCleared: onSearchFieldCleared,
            onQuerySubmitted: onSearchFieldSubmitted,
            hintText: hintText,
            showBorder: false,
            animation: animation,
          ),
          tilePadding: EdgeInsets.zero,
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              //* Vertical Divider
              VerticalDivider(),
              CustomSpacer(widthFactor: 0.013),

              //* Filter Icon
              Flexible(
                child: CustomSvg(
                  svgPath: AppImagesPaths.filterSvg,
                  heightFactor: 0.025,
                ),
              ),
              CustomSpacer(widthFactor: 0.02),
            ],
          ),

          //* List of Filters (Room/Date/Recording, etc..),
          children: [
            SearchFilterList(
              searchFilterList: searchFilterList,
              shrinkWrap: true,
              scrollPhysics: scrollPhysics,
            ),
          ],
        ),
      ),
    );
  }
  //*===========================================================================
  //*===========================================================================
}
