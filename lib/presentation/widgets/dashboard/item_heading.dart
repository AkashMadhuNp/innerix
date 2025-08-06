import 'package:flutter/material.dart';

class ItemHeading extends StatelessWidget {
  final String txt;
  final String txtto;
  const ItemHeading({
    super.key, 
    required this.txt, 
    required this.txtto,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          txt,
          style: TextStyle(
            fontFamily: "Poppins",
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          txtto,
          style: TextStyle(
            fontFamily: "Poppins",
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        )
      ],
    );
  }
}


