import 'package:flutter/material.dart';
import 'package:meditation_controll/Themes/app_colors.dart';
import 'package:meditation_controll/Themes/app_fonts.dart';

class MyButton extends StatelessWidget {
  const MyButton({Key? key, required this.text, required this.onPressed, required this.color}) : super(key: key);

  final String text;
  final VoidCallback? onPressed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(color),
        foregroundColor: MaterialStateProperty.all(AppColors.white),
        textStyle: MaterialStateProperty.all(AppFonts.button),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      child: Text(text, maxLines: 1),
    );
  }
}
