import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

import '../data/models/checkbox_model.dart';
import '../data/typedefs/app_typedefs.dart';
import 'custom_checkbox.dart';

class CheckboxList extends StatelessWidget {
  //*===========================================================================
  //*================================ Properties ===============================
  //*===========================================================================
  final List<CheckboxModel> checkBoxList;
  final bool shrinkWrap;
  final Axis scrollDirection;
  final OnCheckboxChanged onCheckboxChanged;
  //*===========================================================================
  //*================================ Constructor ==============================
  //*===========================================================================
  const CheckboxList({
    super.key,
    required this.checkBoxList,
    this.shrinkWrap = false,
    this.scrollDirection = Axis.vertical,
    required this.onCheckboxChanged,
  });

  //*===========================================================================
  //*================================= Methods =================================
  //*===========================================================================
  @override
  Widget build(BuildContext context) {
    //*================================ Properties =============================
    final textStyle = Theme.of(context).textTheme.bodyMedium;
    //*=========================================================================
    return ListView.builder(
      scrollDirection: scrollDirection,
      itemCount: checkBoxList.length,
      shrinkWrap: shrinkWrap,
      padding: EdgeInsets.zero,
      itemBuilder: (_, index) {
        final isSelected = checkBoxList[index].isSelected;
        return CustomCheckBox(
          onChanged: (newVal) => onCheckboxChanged(
            index: index,
            newValue: newVal!,
          ),
          isSelected: isSelected,
          textStyle: textStyle,
          label: (checkBoxList[index].label).tr,
        );
      },
    );
  }
  //*===========================================================================
  //*===========================================================================
}
