import 'package:flutter/material.dart';


ThemeData getAppTheme() {
  var base = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.cyan,

  );

  return base.copyWith(
      textTheme: base.textTheme.apply(fontFamily: 'SegoeUi')
  );
}