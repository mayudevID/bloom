import 'package:flutter/material.dart';

// COLOR
Color naturalBlack = const Color(0xff1B1D21);
Color naturalWhite = const Color(0xFFFFFFFF);
Color greyDark = const Color(0xFFA7A7A7);
Color greyLight = const Color(0xFFE2E3EB);
Color yellowDark = const Color(0xFFF7E353);
Color yellowLight = const Color(0xFFFEF5B6);
Color redLight = const Color(0xFFF75353);
Color redAction = const Color(0xFFFEB6B6);
Color greenAction = const Color(0xFFDEFEB6);

const MaterialColor primaryBlack = MaterialColor(
  _blackPrimaryValue,
  <int, Color>{
    50: Color(0xFFE6E6E6),
    100: Color(0xFFCDCDCD),
    200: Color(0xFFB3B3B3),
    300: Color(0xFF999999),
    400: Color(0xFF808080),
    500: Color(_blackPrimaryValue),
    600: Color(0xFF4D4D4D),
    700: Color(0xFF333333),
    800: Color(0xFF1A1A1A),
    900: Color(0xFF000000),
  },
);
const int _blackPrimaryValue = 0xFF666666;

// TEXT
TextStyle mainTitle = const TextStyle(
  fontFamily: 'Poppins',
  fontWeight: FontWeight.w600,
  fontSize: 32,
);

TextStyle mainSubTitle = const TextStyle(
  fontFamily: 'Poppins',
  fontWeight: FontWeight.w600,
  fontSize: 24,
);

TextStyle mainBrandName = const TextStyle(
  fontFamily: 'Londrina Solid',
  fontWeight: FontWeight.w300,
  fontSize: 32,
);

TextStyle buttonLarge = const TextStyle(
  fontFamily: 'Poppins',
  fontWeight: FontWeight.w600,
  fontSize: 20,
);

TextStyle buttonSmall = const TextStyle(
  fontFamily: 'Poppins',
  fontWeight: FontWeight.w600,
  fontSize: 16,
);

TextStyle textForm = const TextStyle(
  fontFamily: 'Poppins',
  fontWeight: FontWeight.w400,
  fontSize: 14,
);

TextStyle textParagraph = const TextStyle(
  fontFamily: 'Poppins',
  fontWeight: FontWeight.w400,
  fontSize: 14,
);

TextStyle smallText = const TextStyle(
  fontFamily: 'Poppins',
  fontWeight: FontWeight.w400,
  fontSize: 12,
);

TextStyle smallTextLink = const TextStyle(
  fontFamily: 'Poppins',
  fontWeight: FontWeight.w600,
  fontSize: 12,
);

TextStyle interBold12 = const TextStyle(
  fontFamily: 'Inter',
  fontWeight: FontWeight.w700,
  fontSize: 12,
);

TextStyle interSemiBold14 = const TextStyle(
  fontFamily: 'Inter',
  fontWeight: FontWeight.w600,
  fontSize: 14,
);
