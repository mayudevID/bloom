import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/main/home_cubit.dart';

class NavbarButton extends StatelessWidget {
  final HomeTab groupVal;
  final HomeTab value;
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
      onTap: () => context.read<HomeCubit>().setTab(value),
      child: Image.asset(
        groupVal == value
            ? 'assets/icons/${icon}_select.png'
            : 'assets/icons/${icon}_unselect.png',
        width: 24,
      ),
    );
  }
}
