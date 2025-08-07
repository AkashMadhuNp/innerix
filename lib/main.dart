import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:innerix/presentation/bloc/login/bloc/login_bloc.dart';
import 'package:innerix/presentation/bloc/otp/bloc/otp_bloc.dart';
import 'package:innerix/presentation/screens/dashboard/main_screen.dart';
import 'package:innerix/presentation/screens/onboarding/onboarding_screen.dart';

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
    return  MultiBlocProvider(
      providers: [


        BlocProvider<LoginBloc>(
          create: (context) => LoginBloc(),
          ),
          BlocProvider<OtpBloc>(
          create: (context) => OtpBloc(

          ),

          
          ),
         
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: OnboardingScreen(),
      ),
    );
  }
}