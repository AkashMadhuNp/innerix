import 'package:flutter/material.dart';
import 'package:innerix/core/constants/colors.dart';

class CustomSearchField extends StatelessWidget {
  const CustomSearchField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
              style: const TextStyle(
                fontFamily: 'Poppins',
              ),
              decoration: InputDecoration(
                hintText: "Search",
                hintStyle: const TextStyle(
    fontFamily: 'Poppins',
    color: AppColors.grey,
                ),
                prefixIcon:Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: const EdgeInsets.symmetric(
    vertical: 12.0,
    horizontal: 16.0,
                ),
                border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: const BorderSide(
      color: AppColors.grey,
      width: 1.5,
    ),
                ),
                enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(
      color: Colors.grey.shade300,
      width: 1.5,
    ),
                ),
                focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(
      color: Colors.grey.shade500,
      width: 2,
    ),
                ),
                
              ),
            );
  }
}
