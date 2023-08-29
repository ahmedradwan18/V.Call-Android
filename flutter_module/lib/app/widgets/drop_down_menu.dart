import 'package:flutter/material.dart';
import 'package:flutter_module/app/widgets/room_title_value_model.dart';

import '../core/utils/design_utils.dart';

import '../themes/app_text_theme.dart';
import 'text/custom_text.dart';

class DropDownMenu extends StatelessWidget {
  //================================ Properties ================================
  final Function? onChangeHandler;
  final Object? selectedItem;

  /// the List<object> that will be used to generate [DropDownButtons] ..
  /// e.g. <String>['one','two','three',]
  final List<dynamic> itemList;
  //================================ Constructor ===============================
  const DropDownMenu({
    required this.onChangeHandler,
    required this.itemList,
    required this.selectedItem,
    Key? key,
  }) : super(key: key);
  //================================= Methods ==================================
  @override
  Widget build(BuildContext context) {
    //*================================ Properties =============================
    const int roomTitleMaxLines = 1;
    final roomTitleStyle = AppTextTheme.highlightedTextFieldStyle;
    //*=========================================================================
    return DropdownButtonFormField(
      // the value must be from the provided list.
      value: selectedItem,
      borderRadius: DesignUtils.getBorderRadius(),
      onChanged: (value) => onChangeHandler!(value),
      // take the list of [objects] and maps each one to a [DropDownButton]
      items: itemList
          .map<DropdownMenuItem<Object>>(
            (chosenItem) => DropdownMenuItem<Object>(
              // this is what the user sees at the Item/Card
              value: RoomTitleValueModel(
                roomID: chosenItem.id,
                roomTitle: chosenItem.title,
                engineType: chosenItem.engineType,
              ),
              // this is what the user sees at the Item/Card
              child: CustomText(
                chosenItem.title,
                style: roomTitleStyle,
                maxLines: roomTitleMaxLines,
                useTextOverflow: true,
              ),
            ),
          )
          .toList(),
      decoration: DesignUtils.getFormInputDecoration(showSuffixWidget: false),
    );
  }
  //============================================================================
}
