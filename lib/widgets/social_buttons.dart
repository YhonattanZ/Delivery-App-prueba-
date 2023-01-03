import 'package:flutter/material.dart';

class SocialButton extends StatelessWidget {
  const SocialButton({
    Key? key,
    required this.size,
    required this.icon,
    required this.color,
  }) : super(key: key);

  final Size size;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size.height * 0.050,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              elevation: 0,
              side: BorderSide(color: Colors.grey.shade300),
              shape: const CircleBorder(),
              backgroundColor: Colors.white),
          onPressed: () {},
          child: Icon(
            icon,
            color: color,
            size: 23,
          )),
    );
  }
}
