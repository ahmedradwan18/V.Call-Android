import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_module/app/core/utils/extensions.dart';

import '../../core/utils/localization_service.dart';
import '../../core/values/app_constants.dart';
import '../app_logo.dart';

@immutable
class ExpandableButton extends StatefulWidget {
  const ExpandableButton({
    super.key,
    this.initialOpen,
    required this.distance,
    required this.children,
    this.origin,
    this.onOpen,
    this.onClose,
  });

  final bool? initialOpen;
  final double distance;
  final List<Widget> children;
  final Offset? origin;
  final VoidCallback? onOpen;
  final VoidCallback? onClose;

  @override
  State<ExpandableButton> createState() => _ExpandableButtonState();
}

class _ExpandableButtonState extends State<ExpandableButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _expandAnimation;
  bool _open = false;
  late final maxWidth = MediaQuery.of(context).size.width;
  final isLTR = LocalizationService.isLTR;
  double elevation = 2.0;

  @override
  void initState() {
    super.initState();
    _open = widget.initialOpen ?? false;
    _controller = AnimationController(
      value: _open ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.easeOutQuad,
      parent: _controller,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _open = !_open;
      if (_open) {
        if (widget.onOpen != null) widget.onOpen!();
        _controller.forward();
      } else {
        if (widget.onClose != null) widget.onClose!();

        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: AlignmentDirectional.center,
      children: [
        _buildTapToCloseFab(),
        ..._buildExpandingActionButtons(),
        _buildTapToOpenFab(),
      ],
    );
  }

  Widget _buildTapToCloseFab() {
    return SizedBox(
      width: 56.0,
      height: 56.0,
      child: Center(
        child: Material(
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          elevation: elevation,
          child: InkWell(
            onTap: _toggle,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.close,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTapToOpenFab() {
    return IgnorePointer(
      ignoring: _open,
      child: AnimatedContainer(
        transformAlignment: Alignment.center,
        transform: Matrix4.diagonal3Values(
          _open ? 0.7 : 1.0,
          _open ? 0.7 : 1.0,
          1.0,
        ),
        duration: AppConstants.shortDuration,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
        child: AnimatedOpacity(
          opacity: _open ? 0.0 : 1.0,
          curve: const Interval(0.25, 1.0, curve: Curves.easeInOut),
          duration: AppConstants.shortDuration,
          child: FloatingActionButton(
            onPressed: _toggle,
            elevation: elevation,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            child: const AppLogo(
              iconOnly: true,
              widthFactor: 0.1,
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildExpandingActionButtons() {
    final children = <Widget>[];
    final count = widget.children.length;
    final step = 160.0 / (count - 1);
    final center = widget.origin!;

    final isOnLeftSide =
        isLTR ? (center.dx / maxWidth) <= 0.2 : (center.dx / maxWidth) > 0.2;
    for (var i = 0, angleInDegrees = -80.0;
        i < count;
        i++, angleInDegrees += step) {
      children.add(
        _ExpandingActionButton(
          directionInDegrees: angleInDegrees,
          maxDistance: widget.distance,
          progress: _expandAnimation,
          isOnLeftSide: isOnLeftSide,
          center: center,
          child: widget.children[i],
        ),
      );
    }
    return children;
  }
}

@immutable
class _ExpandingActionButton extends StatelessWidget {
  const _ExpandingActionButton({
    required this.directionInDegrees,
    required this.maxDistance,
    required this.progress,
    required this.child,
    required this.isOnLeftSide,
    required this.center,
  });

  final double directionInDegrees;
  final double maxDistance;
  final Animation<double> progress;
  final Widget child;
  final bool isOnLeftSide;
  final Offset center;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progress,
      builder: (context, child) {
        final iconOffset = Offset.fromDirection(
          (directionInDegrees * (math.pi / 180.0)),
          (progress.value * maxDistance),
        );

        final widgetOffset = Offset((0.3).wf, (0.125).hf);

        final horizontalOffset = isOnLeftSide
            ? (widgetOffset.dx + iconOffset.dx)
            : (widgetOffset.dx - iconOffset.dx);

        return PositionedDirectional(
          start: horizontalOffset,
          top: iconOffset.dy + widgetOffset.dy,
          child: Transform.rotate(
            angle: (1.0 - progress.value) * math.pi / 2,
            child: child!,
          ),
        );
      },
      child: FadeTransition(
        opacity: progress,
        child: child,
      ),
    );
  }
}
