// ignore_for_file: must_be_immutable
import 'package:bloom/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../theme.dart';

class FormInputPassword extends StatelessWidget {
  final TextEditingController controller;
  FormInputPassword({Key? key, required this.controller}) : super(key: key);
  var isHide = true.obs;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: getWidth(30)),
      padding: const EdgeInsets.all(8),
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: naturalBlack),
      ),
      child: Row(
        children: [
          Image.asset("assets/icons/lock.png", width: 24),
          SizedBox(width: getWidth(8)),
          Expanded(
            child: Obx(
              () {
                return TextFormField(
                  controller: controller,
                  style: textForm,
                  cursorColor: naturalBlack,
                  obscureText: (isHide.value ? true : false),
                  decoration: InputDecoration.collapsed(
                    hintText: "Password",
                    hintStyle: textForm.copyWith(color: greyDark),
                  ),
                );
              },
            ),
          ),
          GestureDetector(
            onTap: () {
              isHide.value = !isHide.value;
            },
            child: Obx(
              () {
                return isHide.value
                    ? Image.asset("assets/icons/eye_show.png")
                    : Image.asset("assets/icons/eye_hide.png");
              },
            ),
          ),
        ],
      ),
    );
  }
}
