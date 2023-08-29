import 'package:flutter/material.dart';
import 'package:flutter_module/app/modules/room/widgets/room_card.dart';
import '../../../data/models/room/room_model.dart';
import '../../../widgets/custom_animated_switcher.dart';
import '../../../widgets/empty_error/empty_data.dart';

class RoomList extends StatelessWidget {
  //*================================ Properties ===============================
  final List<RoomModel> list;
  final double horizontalPaddingFactor;
  final double verticalPaddingFactor;
  final ScrollController? scrollController;
  final int maxEmptyDataTitleLines;
  final int? maxDescriptionLines;
  final double? emptyImageHeightFactor;
  final double? emptyDataTopPaddingFactor;
  final double? emptyDataBottomPaddingFactor;
  final String emptyDataTitle;
  final String? emptyDataSubtitle;
  final TextStyle? emptyTitleTextStyle;
  final TextStyle? emptySubtitleTextStyle;
  final double? textHorizontalPaddingFactor;
  final double? emptyDataTextOffsetFactor;
  final double? horizontalMargin;
  final double? spaceBetweenTextFactor;
  final Axis listAxis;
  final double? itemWidth;
  final Axis switcherAxis;
  //*================================ Constructor ==============================
  const RoomList(
    this.list, {
    Key? key,
    required this.emptyDataTitle,
    this.horizontalPaddingFactor = (0.04),
    this.verticalPaddingFactor = (0.008),
    this.maxEmptyDataTitleLines = 4,
    this.emptyImageHeightFactor,
    this.emptyDataTopPaddingFactor,
    this.emptyDataBottomPaddingFactor,
    this.textHorizontalPaddingFactor,
    this.spaceBetweenTextFactor,
    this.listAxis = Axis.vertical,
    this.scrollController,
    this.emptyDataSubtitle,
    this.emptyTitleTextStyle,
    this.emptySubtitleTextStyle,
    this.emptyDataTextOffsetFactor,
    this.maxDescriptionLines,
    this.itemWidth,
    this.horizontalMargin,
    this.switcherAxis = Axis.horizontal,
  }) : super(key: key);

  //*================================= Methods =================================

  @override
  Widget build(BuildContext context) {
    return CustomAnimatedSwitcher(
      axis: switcherAxis,
      child: list.isEmpty
          ? EmptyData(
              title: emptyDataTitle,
              maxTitleLines: maxEmptyDataTitleLines,
              emptyImageHeightFactor: emptyImageHeightFactor,
              topPaddingFactor: emptyDataTopPaddingFactor,
              subtitle: emptyDataSubtitle,
              subtitleTextStyle: emptySubtitleTextStyle,
              textHorizontalPaddingFactor: textHorizontalPaddingFactor,
              textOffsetFactor: emptyDataTextOffsetFactor,
              bottomPaddingFactor: emptyDataBottomPaddingFactor,
              spaceBetweenTextFactor: spaceBetweenTextFactor,
            )
          : ListView.builder(
              controller: scrollController,
              scrollDirection: listAxis,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: list.length,
              itemBuilder: (_, index) => RoomCard(
                list[index],
              ),
            ),
    );
  }
  //*===========================================================================
}
