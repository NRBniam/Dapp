import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  final EdgeInsetsGeometry margin;

  CustomTextButton({
    required this.onPressed,
    required this.text,
    TextStyle? textStyle,
    this.margin = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      /*style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),*/
      child: Text(
        text,
        style: TextStyle(
          color: Color(0XFF726C6C),
        ),
      ),
    );
  }
}
