import 'package:flutter/material.dart';
import 'package:innerix/presentation/screens/auth/login_screen.dart';
import 'package:innerix/presentation/screens/dashboard/home_Screen.dart';
import 'package:innerix/presentation/screens/dashboard/main_screen.dart';

void main(){
  runApp(MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
    );
  }
}