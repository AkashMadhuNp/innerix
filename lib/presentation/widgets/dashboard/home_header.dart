import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hi,Shammas",
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            //SizedBox(height: 1),
            Text(
              "Let's start shopping",
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            )
          ],
        ),
        Spacer(),
        Image.asset("assets/favorite.png"),
        SizedBox(width: 10),
        Image.asset("assets/bell.png"),
      ],
    );
  }
}