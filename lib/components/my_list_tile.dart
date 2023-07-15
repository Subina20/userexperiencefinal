import 'package:flutter/material.dart';

class MyListTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color? color;
  final Color? tilecolor;
  final void Function()? onTap;
  const MyListTile(
      {super.key,
      required this.icon,
      required this.text,
      required this.onTap,
      this.tilecolor,
      this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: ListTile(
        tileColor: tilecolor,
        horizontalTitleGap: 0.5,
        leading: Icon(
          icon,
          color: color ?? Colors.white,
        ),
        onTap: onTap,
        title: Text(
          text,
          style: TextStyle(color: color ?? Colors.white),
        ),
      ),
    );
  }
}
