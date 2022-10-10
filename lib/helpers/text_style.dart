import 'package:flutter/material.dart';

class AppTextStyle extends TextStyle {
  const AppTextStyle({
    required double fontSize,
    FontWeight? fontWeight,
    required Color color,
  }) : super(
          fontSize: fontSize,
          fontWeight: fontWeight,
          fontFamily: '.SF UI Display',
          color: color,
        );
}

class CustomTextStyle {
  static const AppTextStyle white15w600 = AppTextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static const AppTextStyle red15 = AppTextStyle(
    fontSize: 15,
    color: Colors.red,
  );

  static const AppTextStyle black15w500 = AppTextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: Colors.black,
  );

  static const AppTextStyle black15w700 = AppTextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: Colors.black,
  );

  static const AppTextStyle grey14w400 = AppTextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Colors.grey,
  );

  static const AppTextStyle grey15bold = AppTextStyle(
    fontSize: 15,
    fontWeight: FontWeight.bold,
    color: Colors.grey,
  );

  static const AppTextStyle grey15 = AppTextStyle(
    fontSize: 15,
    color: Colors.grey,
  );
}
