import 'package:flutter/material.dart';

class SideBarItem extends StatelessWidget {
  const SideBarItem({Key? key, required this.name, required this.icon, required this.onPressed}) : super(key: key);

  final String name;
  final dynamic icon; // dynamic in order to use different widgets as icon
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: SizedBox(
        height: 40,
        child: Row(
          children: [
            Icon(icon, size: 20, color: Colors.white,),
            const SizedBox(width: 40,),
            Text(name, style: const TextStyle(fontSize: 20, color: Colors.white),)
          ],
        ),
      )
    );
  }
}

