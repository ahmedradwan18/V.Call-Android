import 'package:flutter/material.dart';
import 'package:flutter_module/app/core/utils/extensions.dart';

import '../../data/models/search/search_filter_model.dart';
import '../custom_animated_switcher.dart';

class SearchFilterList extends StatelessWidget {
  //*===========================================================================
  //*================================ Properties ===============================
  //*===========================================================================
  final bool shrinkWrap;
  final List<SearchFilterModel> searchFilterList;
  final ScrollPhysics? scrollPhysics;

  //*===========================================================================
  //*================================ Constructor ==============================
  //*===========================================================================
  const SearchFilterList({
    required this.searchFilterList,
    this.shrinkWrap = false,
    this.scrollPhysics,
    super.key,
  });
  //*===========================================================================
  //*================================= Methods =================================
  //*===========================================================================

  @override
  Widget build(BuildContext context) {
    //*================================ Properties =============================
    final iconLabelSpace = (0.043).wf;
    //*=========================================================================
    return ListView.builder(
      // NEEDS A KEY TO FUNCTION PROPERLY
      key: PageStorageKey<String>('${searchFilterList.length} items'),
      padding: EdgeInsets.zero,
      shrinkWrap: shrinkWrap,
      itemCount: searchFilterList.length,
      physics: scrollPhysics,

      itemBuilder: (_, index) => CustomAnimatedSwitcher(
        axis: Axis.vertical,
        child: !searchFilterList[index].visible
            ? const SizedBox.shrink()
            : Builder(
                builder: (builderContext) => SizedBox(
                  height: (0.043).hf,
                  child: ListTile(
                    onTap: searchFilterList[index].onTap == null
                        ? null
                        : () => searchFilterList[index].onTap!(builderContext),
                    leading: searchFilterList[index].leading,
                    horizontalTitleGap: iconLabelSpace,
                    title: searchFilterList[index].title,
                    trailing: searchFilterList[index].showTrailingWidget
                        ? Icon(
                            Icons.arrow_forward_ios_sharp,
                            size: (0.02).hf,
                          )
                        : null,
                    isThreeLine: false,
                    dense: true,
                    visualDensity: VisualDensity.compact,
                    minLeadingWidth: 0.0,
                    contentPadding: EdgeInsets.zero,
                    minVerticalPadding: 0.0,
                  ),
                ),
              ),
      ),
    );
  }
  //*===========================================================================
  //*===========================================================================
}
