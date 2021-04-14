import 'package:flutter/material.dart';

/// Navigation service using Global Key.
///
/// Send data to route generator as arguments.
class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();

  /// Navigate to particular screen and add last screen to stack.
  Future<dynamic> navigateTo(String routeName, {dynamic arguments}) {
    return navigatorKey.currentState.pushNamed(routeName, arguments: arguments);
  }

  /// Remove last screen and add current screen on top of stack
  Future<dynamic> replaceAndNavigateTo(String routeName, {dynamic arguments}) {
    return navigatorKey.currentState
        .pushReplacementNamed(routeName, arguments: arguments);
  }

  /// Pop all the screen/routes from stack and add the current screen.
  Future<dynamic> popAllAndReplace(String routeName, {dynamic arguments}) {
    return navigatorKey.currentState.pushNamedAndRemoveUntil(
        routeName, (Route<dynamic> route) => false,
        arguments: arguments);
  }

  /// If called with data, then passes that data to last screen in stack or else pop the last screen without and data.
  void goBack({Map<String, dynamic> data}) {
    if (data != null)
      return navigatorKey.currentState.pop(data);
    else
      navigatorKey.currentState.pop();
  }
}
