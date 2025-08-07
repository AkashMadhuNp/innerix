import 'package:flutter/material.dart';
import 'package:innerix/core/constants/colors.dart';
import 'package:innerix/presentation/screens/auth/login_screen.dart'; 

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Map<String, String>> onboardingData = [
    {
      "image": "assets/wlone.png",
      "title": "Welcome to ecom",
      "description": "Lorem Ipsum is simply dummy text of the\nprinting and typesetting!"
    },
    {
      "image": "assets/wtwo.png",
      "title": "Lorem Ipsum is simply dummy\ntext of the printing !",
      "description": "Lorem Ipsum is simply dummy text of the\nprinting and typesetting !"
    },
    {
      "image": "assets/wtrie.png",
      "title": "It is a long established fact\nthat a reader will !",
      "description": "Lorem Ipsum is simply dummy text of the\nprinting and typesetting !"
    },
  ];

  void _nextPage() {
  if (_currentIndex < onboardingData.length - 1) {
    _pageController.nextPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  } else {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ),
    );
  }
}


  void _skip() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen(),));
  }

  Widget _buildIndicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(horizontal: 4.0),
      height: 8,
      width:  8,
      decoration: BoxDecoration(
        color: isActive ? AppColors.black : AppColors.grey,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: onboardingData.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (_, index) {
                final item = onboardingData[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        item['image']!,
                        height: 280,
                        width: 280,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(height: 30),
                      Text(
                        textAlign: TextAlign.center,
                        item['title']!,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: AppColors.black,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        item['description']!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: AppColors.grey,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60.0, vertical: 60),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: _skip,
                  child: Text(
                    "Skip",
                    style: TextStyle(
                      fontFamily: 'DM Sans',
                      fontSize: 18,
                      color: AppColors.grey,
                      fontWeight: FontWeight.w400
                    ),
                  ),
                ),

                Row(
                  children: List.generate(
                    onboardingData.length,
                    (index) => _buildIndicator(index == _currentIndex),
                  ),
                ),

                GestureDetector(
                  onTap: _nextPage,
                  child: Text(
                    _currentIndex == onboardingData.length - 1 ? "Done" : "Next",
                    style: TextStyle(
                      fontFamily: 'DM Sans',
                      fontSize: 18,
                      color: AppColors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
