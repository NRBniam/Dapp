import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  final String? hintText;
  final String Function(String)? validator;
  final TextEditingController? controller;
  final IconData? suffixIcon;
  final TextStyle? hintStyle;
  bool? obscureText; // Add obscureText property

  CustomTextFormField({
    required this.hintText,
    this.validator,
    this.controller,
    this.suffixIcon,
    bool? enabled,
    this.obscureText, // Add obscureText property
    TextStyle? style,
    this.hintStyle,
    Color? borderColor,
    MaterialColor? hintTextColor,
    Color? textColor,
    bool? readOnly,
    InputDecoration? decoration,
    Null Function(dynamic value)? onChanged,
  });

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: TextFormField(
        controller: _controller,
        obscureText: widget.obscureText ?? false, // Use obscureText property
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: widget.hintStyle,
          filled: true,
          fillColor: Colors.white,
          suffixIcon: widget.suffixIcon != null
              ? IconButton(
                  icon: Icon(widget.suffixIcon),
                  onPressed: () {
                    setState(() {
                      widget.obscureText =
                          !(widget.obscureText ?? false); // Toggle obscureText
                    });
                  },
                )
              : null, // Add suffix icon if provided
          isDense: true,
          contentPadding: EdgeInsets.all(10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey),
          ),
        ),
        validator: (value) {
          return widget.validator?.call(value!) ?? null;
        },
      ),
    );
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }
}
