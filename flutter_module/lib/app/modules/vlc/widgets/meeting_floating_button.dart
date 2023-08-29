import 'package:flutter/material.dart';
import 'package:flutter_module/app/core/utils/extensions.dart';

import '../../../core/values/app_constants.dart';
import '../../../widgets/buttons/expandable_button.dart';

class MeetingFloatingButton extends StatefulWidget {
  //*===========================================================================
  //*================================ Parameters ===============================
  //*===========================================================================
  final List<Widget> iconList;
  //*===========================================================================
  //*================================ Constructor ==============================
  //*===========================================================================
  const MeetingFloatingButton({
    super.key,
    required this.iconList,
  });
  //*===========================================================================
  //*================================= State ===================================
  //*===========================================================================

  @override
  State<MeetingFloatingButton> createState() => _MeetingFloatingButtonState();
  //*===========================================================================
  //*===========================================================================
}

class _MeetingFloatingButtonState extends State<MeetingFloatingButton> {
  double opacity = _fullOapacity;
  static const double _fullOapacity = 1.0;
  static const double _hiddenOpacity = 0.25;
  bool _isOpened = false;
  Offset _origin = Offset(
    (0.54).wf,
    (0.18).hf,
  );

  void _onUseHiddenOpacity() {
    Future.delayed(const Duration(seconds: 2), () {
      if (_isOpened) return;
      setState(() {
        opacity = _hiddenOpacity;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 25),
      left: _origin.dx,
      top: _origin.dy,
      height: (0.3).hf,
      width: (0.7).wf,
      child: AnimatedOpacity(
        opacity: opacity,
        duration: AppConstants.shortDuration,
        child: GestureDetector(
          onPanUpdate: (details) {
            setState(() {
              opacity = _fullOapacity;
              _origin += details.delta;
            });
          },
          onPanEnd: (_) {
            setState(() {
              _origin = Offset(
                _origin.dx.clamp((-0.21).wf, (0.51).wf),
                _origin.dy.clamp((0.01).hf, (0.72).hf),
              );
            });
            _onUseHiddenOpacity();
          },
          child: ExpandableButton(
            distance: 75,
            origin: _origin,
            onOpen: () {
              setState(() {
                opacity = _fullOapacity;
              });
              _isOpened = true;
            },
            onClose: () {
              _isOpened = false;
              _onUseHiddenOpacity();
            },
            children: widget.iconList,
          ),
        ),
      ),
    );
  }
}
