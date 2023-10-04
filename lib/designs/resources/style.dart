import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color kBlue = Color(0xFF2E8AF6);
const Color kDarkBrown = Color(0xFF1B2028);

const Color kGrey = Color(0xFFA4AAAD);
const Color kDarkGrey = Color(0xFF878787);
const Color kDarkerGrey = Color(0xFF323436);
const Color kLightGrey = Color(0xFFEDEDED);

const Color kWhite = Color(0xFFFFFFFF);
const Color kBlack = Color(0xFF111111);

const Color kBgColor = Color(0xFF181A1C);

const Color kYellow = Color(0xFFFFD33C);
const Color kPink = Color(0xFFF62E8E);
const Color kPurple = Color(0xFFAC1AF0);
const double kBorderRadius = 12.0;

const double kPaddingHorizontal = 20.0;

final kInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(kBorderRadius),
    borderSide: const BorderSide(
        color: kLightGrey
    )
);

final kNanumGothicBold = GoogleFonts.nanumGothic(
    fontWeight: FontWeight.w700
);
final kNanumGothicSemiBold = GoogleFonts.nanumGothic(
    fontWeight: FontWeight.w600
);
final kNanumGothicMedium = GoogleFonts.nanumGothic(
    fontWeight: FontWeight.w500
);
final kanumGothicRegular = GoogleFonts.nanumGothic(
    fontWeight: FontWeight.w400
);