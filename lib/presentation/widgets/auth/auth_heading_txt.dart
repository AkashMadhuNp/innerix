import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:innerix/core/constants/colors.dart';

class AuthTextHeading extends StatelessWidget {
  final String textone;
  final String texttwo;
  final String textthree;
  final bool useRichText;
  final VoidCallback? onEditTap;

  const AuthTextHeading({
    super.key,
    required this.textone,
    required this.texttwo,
    required this.textthree,
    this.useRichText = false,
    this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    final parts = textthree.split("Need to edit the mail");

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          textone,
          style: const TextStyle(
            fontFamily: 'Gilroy',
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        Text(
          texttwo,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        const SizedBox(height: 20),

        // Conditional rendering
        useRichText
            ? RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color: AppColors.grey,
                  ),
                  children: [
                    TextSpan(text: parts[0]),
                    TextSpan(
                      text: 'edit the mail',
                      style: const TextStyle(
                        decoration: TextDecoration.underline,
                        color: AppColors.grey,
                      ),
                      recognizer: TapGestureRecognizer()..onTap = onEditTap,
                    ),
                    if (parts.length > 1) TextSpan(text: parts[1]),
                  ],
                ),
              )
            : Text(
                textthree,
                style: const TextStyle(
                  color: AppColors.grey,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
      ],
    );
  }
}
