import 'package:flutter/material.dart';


ThemeData getAppTheme() {
  var base = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.purple,

  );

  return base.copyWith(
      textTheme: base.textTheme.apply(fontFamily: 'VarelaRound')
  );
}