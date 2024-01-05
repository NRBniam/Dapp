import 'package:flutter/material.dart';

class Custom__Button extends StatelessWidget {
  final String buttonText;
  final Function onPressed;

  Custom__Button(
      {required this.buttonText,
      required this.onPressed,
      EdgeInsets? padding,
      Color? buttonColor});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onPressed(),
      child: Container(
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Color(0XFF2E3F42),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Center(
          child: Text(
            buttonText,
            style: TextStyle(
              fontFamily: 'Canva Sans',
              fontSize: 17.0,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
