import 'package:flutter/material.dart';

class NoDataWidget extends StatelessWidget {
  NoDataWidget({this.text, super.key});

  String? text = '';

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/no_item-3.png',
          width: width / 1,
          height: height / 2.5,
        ),
        Text(text!)
      ],
    );
  }
}
