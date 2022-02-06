import 'package:flutter/material.dart';

import '../theme.dart';

class FormInput extends StatelessWidget {
  final String icon;
  final String hintText;
  final TextEditingController controller;
  const FormInput(
      {Key? key,
      required this.icon,
      required this.hintText,
      required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      padding: const EdgeInsets.all(8),
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: naturalBlack),
      ),
      child: Row(
        children: [
          Image.asset("assets/icons/$icon.png", width: 24),
          const SizedBox(width: 8),
          Expanded(
            child: TextFormField(
              controller: controller,
              style: textForm,
              cursorColor: naturalBlack,
              decoration: InputDecoration.collapsed(
                hintText: hintText,
                hintStyle: textForm.copyWith(color: greyDark),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
