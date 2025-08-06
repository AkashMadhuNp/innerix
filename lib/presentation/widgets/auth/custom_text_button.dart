import 'package:flutter/material.dart';
import 'package:innerix/core/constants/colors.dart';

class CustomTextButton extends StatelessWidget {
  final String txt;
  const CustomTextButton({

    super.key, required this.txt,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
      },
      child: Text(
        txt,
        style: TextStyle(
          fontSize: 12,
          fontFamily: 'poppins',
          color: AppColors.brownishColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
