import 'package:flutter/material.dart';
import 'package:innerix/core/constants/colors.dart';
import 'package:innerix/presentation/screens/dashboard/cart_screen.dart';
import 'package:innerix/presentation/screens/dashboard/category_screen.dart';
import 'package:innerix/presentation/screens/dashboard/home_screen.dart';
import 'package:innerix/presentation/screens/dashboard/offer_screen.dart';
import 'package:innerix/presentation/screens/dashboard/profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const CategoriesScreen(),
    const OffersScreen(),
    const CartScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        height: 100, 
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: Colors.yellow,
          unselectedItemColor: AppColors.grey,
          selectedFontSize: 14, 
          unselectedFontSize: 14, 
          selectedLabelStyle: const TextStyle(
            color: Colors.yellow,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: TextStyle(
            color: AppColors.grey,
            fontWeight: FontWeight.w400,
            fontSize: 12
          ),
          iconSize: 32, 
          elevation: 0,
          items: [
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 4), 
                child: Image.asset(
                  'assets/home.png',
                ),
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Image.asset(
                  'assets/cards.png',
                  width: 32,
                  height: 32,
                ),
              ),
              label: 'Categories',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Image.asset(
                  'assets/celebration.png', 
                  width: 32,
                  height: 32,
                ),
              ),
              label: 'Offers',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Image.asset(
                  'assets/shopping.png', 
                  width: 32,
                  height: 32,
                ),
              ),
              label: 'Cart',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Image.asset(
                  'assets/profile.png', 
                  width: 32,
                  height: 32,
                ),
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}