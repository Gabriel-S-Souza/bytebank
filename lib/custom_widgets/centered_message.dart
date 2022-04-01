import 'package:flutter/material.dart';

class CustomCenteredMessage extends StatelessWidget {
  final String message;
  final IconData icon;
  final double iconSize;
  final double fontSize;

  const CustomCenteredMessage(
     {Key? key, 
    required this.message,
    required this.icon,
    this.iconSize = 64,
    this.fontSize = 24,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Visibility(
            child: Icon(
              icon,
              size: iconSize,
            ),
            visible: true,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 24.0),
            child: Text(
              message,
              style: TextStyle(fontSize: fontSize),
            ),
          ),
        ],
      ),
    );
  }
}
