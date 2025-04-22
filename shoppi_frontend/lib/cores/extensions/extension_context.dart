import 'package:flutter/material.dart';

extension ExtensionContext on BuildContext {
  double get width {
    return MediaQuery.of(this).size.width;
  }

  double get height {
    return MediaQuery.of(this).size.height;
  }

  Future<T?> goUntil<T extends Object?>(Widget child, {Object? arguments}) {
    return Navigator.of(this).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => child,
        ),
        (Route<dynamic> route) => false);
  }

  Future<T?> goUntilCustom<T extends Object?>(
      {required Widget Function(BuildContext context) builder,
      Object? arguments}) {
    return Navigator.of(this).pushAndRemoveUntil(
        MaterialPageRoute(builder: builder), (Route<dynamic> route) => false);
  }

  Future<T?> goPageCustom<T extends Object?>(
      {required Widget Function(BuildContext context) builder}) {
    return Navigator.of(this).push(MaterialPageRoute(
      builder: builder,
    ));
  }

  Future<T?> goPage<T extends Object?>(Widget child) {
    return Navigator.of(this).push(MaterialPageRoute(
      builder: (context) => child,
    ));
  }

  pop<T extends Object?>([T? result]) {
    Navigator.of(this).pop(result);
  }

  unFocus() {
    // FocusManager.instance.primaryFocus?.unfocus();
    // FocusScope.of(this).unfocus();
    FocusScope.of(this).requestFocus(FocusNode());
  }

  // isDarkMode() {
  //   var brightness = MediaQuery.of(this).platformBrightness;
  //   final isDarkMode = brightness == Brightness.dark;
  //   return isDarkMode;
  // }
}
