import 'package:flutter/material.dart';

class HomeBanner extends StatelessWidget {
  const HomeBanner({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      "assets/banner.png",
      height: 200,
      width: MediaQuery.of(context).size.width,
    );
  }
}
