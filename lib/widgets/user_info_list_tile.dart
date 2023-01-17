import 'package:flutter/material.dart';

class UserInfoListTile extends StatelessWidget {
  const UserInfoListTile({
    Key? key,
    required this.size,
    required this.info,
    required this.subtitleInfo,
    required this.style,
    required this.icon,
    required this.iconColor,
  }) : super(key: key);

  final Size size;
  final String info;
  final String subtitleInfo;
  final TextStyle style;
  final Icon icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: size.height * 0.010),
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
      child: ListTile(
        leading: icon,
        iconColor: iconColor,
        title: Text(info, style: style),
        subtitle: Text(subtitleInfo),
      ),
    );
  }
}
