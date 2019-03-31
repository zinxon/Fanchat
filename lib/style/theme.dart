import 'dart:ui';

import 'package:flutter/cupertino.dart';

class Colors {
  const Colors();

  static const Color loginGradientStart = const Color(0xFFfbab66);
  // static const Color loginGradientEnd = const Color(0xFFf7418c);
  static const Color loginGradientEnd = const Color(0xfffc852e);

  static const primaryGradient = const LinearGradient(
    colors: const [loginGradientStart, loginGradientEnd],
    stops: const [0.0, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

class AppColors {
  static const AppBarColor = 0xfffc852e;
  static const themeColor = Color(0xfff5a623);
  static const primaryColor = Color(0xff203152);
  static const greyColor = Color(0xffaeaeae);
  static const greyColor2 = Color(0xffE8E8E8);
}
