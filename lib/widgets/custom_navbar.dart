import 'package:bloom/theme.dart';
import 'package:flutter/material.dart';

class CustomNavBar extends StatelessWidget {
  const CustomNavBar(
      {Key? key,
      required this.items,
      required this.onItemSelected,
      required this.selectedIndex})
      : super(key: key);

  final List<String> items;
  final ValueChanged<int> onItemSelected;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: naturalWhite,
      height: 56,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items.map((iconUrl) {
          var index = items.indexOf(iconUrl);
          return GestureDetector(
            onTap: () => onItemSelected(index),
            child: Container(
              child: (index == selectedIndex)
                  ? Image.asset(
                      'assets/icons/${iconUrl}_select.png',
                      width: 24,
                    )
                  : Image.asset(
                      'assets/icons/${iconUrl}_unselect.png',
                      width: 24,
                    ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
