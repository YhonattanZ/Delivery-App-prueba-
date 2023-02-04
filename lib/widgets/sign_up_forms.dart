import 'package:app_delivery/constants/constants.dart';
import 'package:flutter/material.dart';

class SignUpForms extends StatelessWidget {
  const SignUpForms({
    Key? key,
    required this.autofocus,
    this.focusNode,
    this.controller,
    this.lines,
    this.onTap,
    required this.obstext,
    required this.formTitle,
    required this.formIcon,
    required this.keyboardType,
  }) : super(key: key);

  final String formTitle;
  final Icon formIcon;
  final TextInputType keyboardType;
  final bool obstext;
  final int? lines;
  final TextEditingController? controller;
  final bool autofocus;
  final FocusNode? focusNode;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.15),
        child: TextField(
          onTap: onTap,
          focusNode: focusNode,
          autofocus: autofocus,
          maxLines: lines,
          controller: controller,
          scrollPhysics: const BouncingScrollPhysics(),
          obscureText: obstext,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: formTitle,
            prefixIcon: formIcon,
          ),
        ),
      ),
    );
  }
}
