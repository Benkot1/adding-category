import 'package:flutter/material.dart';

class CircularCard extends StatelessWidget {
  final Color color;
  final VoidCallback onPressed;
  final String text;
  final IconData iconData;
  final Color iconColor;
  const CircularCard({this.color,this.onPressed,this.text,this.iconData,this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
            height:40,
            width: 40,
            decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(20)
            ),
            child: IconButton(
                icon: Icon(
                  iconData,
                  size: 16,
                  color: iconColor,
                ),
                onPressed: onPressed
            )
        ),
        Text(text,style: const TextStyle(fontSize: 12),)
      ],
    );
  }
}

