// ignore_for_file: prefer_const_constructors

import 'package:bloom/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Creates a Widget representing the day.
class DayItem extends StatelessWidget {
  final int dayNumber;
  final String shortName;
  final bool isSelected;
  final Function onTap;
  final Color? dayColor;
  final Color? activeDayColor;
  final Color? activeDayBackgroundColor;
  final bool available;
  final Color? dotsColor;
  final Color? dayNameColor;

  DayItem({
    Key? key,
    required this.dayNumber,
    required this.shortName,
    required this.onTap,
    this.isSelected = false,
    this.dayColor,
    this.activeDayColor,
    this.activeDayBackgroundColor,
    this.available = true,
    this.dotsColor,
    this.dayNameColor,
  }) : super(key: key);

  final double height = Get.height * 56 / 800;
  final double width = Get.width * 40 / 360;

  _buildDay(BuildContext context) {
    final textStyle = TextStyle(
      fontFamily: "Poppins",
      fontSize: 16,
      fontWeight: FontWeight.w400,
    );
    final selectedStyle = TextStyle(
      fontFamily: "Poppins",
      fontSize: 16,
      fontWeight: FontWeight.w700,
    );

    return GestureDetector(
      onTap: available ? onTap as void Function()? : null,
      child: Container(
        margin: EdgeInsets.only(right: 8),
        decoration: isSelected
            ? BoxDecoration(
                color: yellowDark,
                borderRadius: BorderRadius.circular(5),
              )
            : BoxDecoration(
                color: Color(0xffF7DB12).withOpacity(0.4),
                borderRadius: BorderRadius.circular(5),
              ),
        height: height,
        width: width,
        child: Column(
          children: <Widget>[
            SizedBox(height: Get.height * 8 / 800),
            Text(
              shortName,
              style: TextStyle(
                color: dayNameColor ?? activeDayColor ?? naturalBlack,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                fontSize: 12,
                fontFamily: "Inter",
              ),
            ),
            Text(
              dayNumber.toString(),
              style: isSelected ? selectedStyle : textStyle,
            ),
            if (isSelected) ...[
              _buildDots(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDots() {
    final dot = Container(
      height: 4,
      width: 4,
      decoration: BoxDecoration(
        color: naturalBlack,
        shape: BoxShape.circle,
      ),
    );

    return dot;
  }

  @override
  Widget build(BuildContext context) {
    return _buildDay(context);
  }
}
