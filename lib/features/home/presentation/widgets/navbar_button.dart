import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/main/main_cubit.dart';

class NavbarButton extends StatelessWidget {
  final MainTab groupVal;
  final MainTab value;
  final String icon;

  const NavbarButton(
      {Key? key,
      required this.groupVal,
      required this.value,
      required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.read<MainCubit>().setTab(value),
      child: Image.asset(
        groupVal == value
            ? 'assets/icons/${icon}_select.png'
            : 'assets/icons/${icon}_unselect.png',
        width: 24,
      ),
    );
  }
}
