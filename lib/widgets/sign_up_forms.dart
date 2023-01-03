import 'package:flutter/material.dart';

class SignUpForms extends StatelessWidget {
  const SignUpForms({
    Key? key,
    required this.controller,
    required this.obstext,
    required this.formTitle,
    required this.formIcon,
    required this.keyboardType,
  }) : super(key: key);

  final String formTitle;
  final Icon formIcon;
  final TextInputType keyboardType;
  final bool obstext;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.15),
        child: TextField(
          controller: controller,
          scrollPhysics: const BouncingScrollPhysics(),
          obscureText: obstext,
          keyboardType: keyboardType,
          decoration:
              InputDecoration(hintText: formTitle, prefixIcon: formIcon),
        ),
      ),
    );
  }
}
