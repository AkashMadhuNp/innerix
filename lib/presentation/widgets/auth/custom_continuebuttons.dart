import 'package:flutter/material.dart';
import 'package:innerix/core/constants/colors.dart';

class CustomSignInButtons extends StatelessWidget {
  final String txt;
  final String image;
  final double height;
  final double width;
  final void Function()? ontap;


  const CustomSignInButtons({
    super.key, 
    required this.txt, 
    required this.image, 
    this.ontap, 
    required this.height, 
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
        color: Colors.white,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap:ontap,
          child: Container(
            height: 45,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: AppColors.bg,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.grey.shade300
              )
            ),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  image, // Add Google icon to assets
                  height: height,
                  width: width,
                ),
                SizedBox(width: 12),
                Text(
                  txt,
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Poppins"
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}