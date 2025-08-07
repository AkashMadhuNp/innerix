import 'package:flutter/material.dart';
import 'package:innerix/presentation/screens/auth/login_screen.dart';
import 'package:lottie/lottie.dart';

class SimpleOnboardingScreen extends StatefulWidget {
  const SimpleOnboardingScreen({super.key});

  @override
  State<SimpleOnboardingScreen> createState() => _SimpleOnboardingScreenState();
}

class _SimpleOnboardingScreenState extends State<SimpleOnboardingScreen> {
  late PageController _pageController;
  int _currentPage = 0;
  bool _showGetStarted = false;

  final List<OnboardingData> _onboardingData = [
    OnboardingData(
      title: "Welcome to Coffee World",
      subtitle: "Discover the perfect cup for every moment",
      description: "Explore our premium collection of artisanal coffee beans sourced from the finest farms around the world.",
      lottieAsset: "assets/coffee time loading.json",
    ),
    OnboardingData(
      title: "Premium Quality",
      subtitle: "Crafted with passion and expertise",
      description: "Each bean is carefully selected and roasted to perfection, ensuring you get the best coffee experience every time.",
      lottieAsset: "assets/coffee time loading.json",
    ),
    OnboardingData(
      title: "Fast Delivery",
      subtitle: "Fresh coffee delivered to your door",
      description: "Get your favorite coffee delivered quickly and safely, maintaining the freshness you deserve.",
      lottieAsset: "assets/coffee time loading.json",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
      _showGetStarted = page == _onboardingData.length - 1;
    });
  }

  void _nextPage() {
    if (_currentPage < _onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _getStarted();
    }
  }

  void _skipOnboarding() {
    _pageController.animateToPage(
      _onboardingData.length - 1,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void _getStarted() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;
    final isSmallScreen = screenHeight < 600;
    final isMediumScreen = screenHeight < 800;
    
    final horizontalPadding = screenWidth * 0.08;
    final bottomPadding = screenHeight * 0.04;
    
    final animationSize = isSmallScreen 
        ? screenWidth * 0.6 
        : isMediumScreen 
            ? screenWidth * 0.65 
            : screenWidth * 0.7;
    
    final titleFontSize = isSmallScreen ? 24.0 : isMediumScreen ? 28.0 : 32.0;
    final subtitleFontSize = isSmallScreen ? 16.0 : isMediumScreen ? 17.0 : 18.0;
    final descriptionFontSize = isSmallScreen ? 14.0 : isMediumScreen ? 15.0 : 16.0;
    
    final titleSpacing = isSmallScreen ? 30.0 : isMediumScreen ? 40.0 : 50.0;
    final subtitleSpacing = isSmallScreen ? 12.0 : isMediumScreen ? 14.0 : 16.0;
    final descriptionSpacing = isSmallScreen ? 16.0 : isMediumScreen ? 20.0 : 24.0;
    final bottomSpacing = isSmallScreen ? 20.0 : isMediumScreen ? 30.0 : 40.0;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _onboardingData.length,
                itemBuilder: (context, index) {
                  return SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: screenHeight * 0.6,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: animationSize,
                            width: animationSize,
                            constraints: BoxConstraints(
                              maxHeight: screenHeight * 0.35,
                              maxWidth: screenWidth * 0.8,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Lottie.asset(
                              _onboardingData[index].lottieAsset,
                              fit: BoxFit.contain,
                            ),
                          ),
                          
                          SizedBox(height: titleSpacing),
                          
                          Text(
                            _onboardingData[index].title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: titleFontSize,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFF5E6D3), 
                              height: 1.2,
                            ),
                          ),
                          
                          SizedBox(height: subtitleSpacing),
                          
                          Text(
                            _onboardingData[index].subtitle,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: subtitleFontSize,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFFD4A574),
                            ),
                          ),
                          
                          SizedBox(height: descriptionSpacing),
                          
                          Text(
                            _onboardingData[index].description,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: descriptionFontSize,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFFB8A082),
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            
            Container(
              padding: EdgeInsets.all(bottomPadding),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Page indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _onboardingData.length,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPage == index ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? const Color(0xFFD4A574)
                              : const Color(0xFF5A4037),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  
                  SizedBox(height: bottomSpacing),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Skip button (left side)
                      if (!_showGetStarted)
                        TextButton(
                          onPressed: _skipOnboarding,
                          child: Text(
                            'Skip',
                            style: TextStyle(
                              color: const Color(0xFFD4A574),
                              fontSize: subtitleFontSize,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      else
                        const SizedBox(width: 48), // Placeholder to maintain spacing
                      
                      // Next/Get Started button (right side)
                      SizedBox(
                        height: isSmallScreen ? 48 : 56,
                        child: ElevatedButton(
                          onPressed: _nextPage,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFD4A574),
                            foregroundColor: const Color(0xFF2C1810),
                            elevation: 8,
                            shadowColor: const Color(0xFFD4A574).withOpacity(0.4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(isSmallScreen ? 24 : 28),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: _showGetStarted ? 24 : 32,
                              vertical: 8,
                            ),
                          ),
                          child: Text(
                            _showGetStarted ? 'Get Started' : 'Next',
                            style: TextStyle(
                              fontSize: subtitleFontSize,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingData {
  final String title;
  final String subtitle;
  final String description;
  final String lottieAsset;

  OnboardingData({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.lottieAsset,
  });
}