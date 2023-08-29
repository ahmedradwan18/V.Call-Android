import 'package:flutter/material.dart';
import 'package:flutter_module/app/core/utils/extensions.dart';
import '../../../core/utils/design_utils.dart';
import '../../../core/values/app_images_paths.dart';
import '../../../data/models/checkbox_model.dart';
import '../../../data/typedefs/app_typedefs.dart';
import '../../../widgets/custom_checkbox.dart';
import '../../../widgets/custom_svg.dart';

class RoomCheckboxList extends StatelessWidget {
  //*===========================================================================
  //*================================ Properties ===============================
  //*===========================================================================
  final List<CheckboxModel> roomCheckboxList;
  final OnCheckboxChanged onCheckboxChanged;
  final bool shrinkWrap;
  //*===========================================================================
  //*================================ Constructor ==============================
  //*===========================================================================
  const RoomCheckboxList({
    super.key,
    required this.roomCheckboxList,
    required this.onCheckboxChanged,
    this.shrinkWrap = false,
  });

  //*===========================================================================
  //*================================= Methods =================================
  //*===========================================================================
  @override
  Widget build(BuildContext context) {
    //*================================ Properties =============================
    final horizontalPadding = (0.02).wf;
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.bodyMedium?.copyWith(
      color: theme.primaryColor,
    );
    //*=========================================================================
    return Material(
      shape: DesignUtils.getRoundedRectangleBorder(),
      color: Colors.white,
      child: ListView.builder(
        shrinkWrap: shrinkWrap,
        padding: EdgeInsetsDirectional.only(
          start: horizontalPadding,
          end: horizontalPadding,
        ),
        itemExtent: (0.035).hf,
        itemCount: roomCheckboxList.length,
        itemBuilder: (_, index) => CustomCheckBox(
          onChanged: (bool? newVal) => onCheckboxChanged(
            index: index,
            newValue: newVal!,
          ),
          label: roomCheckboxList[index].label,
          isSelected: roomCheckboxList[index].isSelected,
          textStyle: textStyle,
          leading: const CustomSvg(
            svgPath: AppImagesPaths.meetingFilterRoomSvg,
            heightFactor: (0.02),
          ),
        ),
      ),
    );
  }
  //*===========================================================================
  //*===========================================================================
}
