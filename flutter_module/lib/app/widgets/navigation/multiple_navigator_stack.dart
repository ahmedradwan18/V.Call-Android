import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class MultipleNavigationStack extends StatelessWidget {
  //================================ Properties ================================
  // to call this specific navigator with [push, pop] from any place
  final GlobalKey<NavigatorState> navigatorKey;
  // will be wrapped and used as the root '/' [default] route for this
  // specific Navigator
  final Widget child;
  // the rest of the navigation routes' map that will be used by the navigator
  final Map<String, WidgetBuilder> customNavigatorRoutes;
  // to enable hero animation w/ multiple stack navigation.
  final HeroController? heroController;
  //================================ Constructor ===============================
  const MultipleNavigationStack({
    required this.navigatorKey,
    required this.child,
    required this.customNavigatorRoutes,
    this.heroController,
    Key? key,
  }) : super(key: key);
  //================================= Methods ==================================
  // this will be the map of routes for each Navigator
  Map<String, WidgetBuilder> _customRouteBuilders(BuildContext context) {
    return {
      // the root and default route will be the received child
      '/': (_) => child,
      // the rest of the map will be sent by each view to it's navitgator
      ...customNavigatorRoutes,
    };
  }

  //============================================================================
  @override
  Widget build(BuildContext context) {
    //================================ Properties ==============================
    final routeBuilders = _customRouteBuilders(context);
    //==========================================================================
    return Navigator(
      observers: heroController != null
          ? [heroController!]
          : const <NavigatorObserver>[],
      key: navigatorKey,
      // this will be used to build a page based on the given route name.
      onGenerateRoute: (settings) => GetPageRoute(
        settings: settings,
        page: () => routeBuilders[settings.name]!(context),
        routeName: settings.name,
      ),
    );
  }
}
