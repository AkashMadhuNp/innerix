import 'package:flutter/material.dart';
import 'package:innerix/core/constants/colors.dart';

class AuthTextHeading extends StatelessWidget {
  final String textone;
  final String texttwo;
  final String textthree;
  const AuthTextHeading({
    super.key, required this.textone, required this.texttwo, required this.textthree,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          textone,
          style: TextStyle(
            fontFamily: 'Gilroy',
            fontWeight: FontWeight.bold, 
            fontSize: 30,
            ),
            ),
              
        Text(
          texttwo, 
               style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold, 
              fontSize: 30,
            ),
            ),


        SizedBox(height: 20,),

        Text(
          textthree,
                style: TextStyle(
                  color: AppColors.grey,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600, // SemiBold
                fontSize: 12,
              ),

          )
      ],
    );
  }
}