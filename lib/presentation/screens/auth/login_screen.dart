import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:innerix/core/constants/colors.dart';
import 'package:innerix/core/utils/validators.dart';
import 'package:innerix/presentation/bloc/login/bloc/login_bloc.dart';
import 'package:innerix/presentation/bloc/login/bloc/login_event.dart';
import 'package:innerix/presentation/bloc/login/bloc/login_state.dart';
import 'package:innerix/presentation/screens/dashboard/main_screen.dart';
import 'package:innerix/presentation/screens/auth/otp_screen.dart';
import 'package:innerix/presentation/widgets/auth/auth_heading_txt.dart';
import 'package:innerix/presentation/widgets/auth/custom_button.dart';
import 'package:innerix/presentation/widgets/auth/custom_continueButtons.dart';
import 'package:innerix/presentation/widgets/auth/custom_text_button.dart';
import 'package:innerix/presentation/widgets/auth/custom_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  bool _obscurePassword = true;
  
  @override
  void initState() {
    super.initState();
  }
  
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _handleLogin() {
    try {
      final loginBloc = context.read<LoginBloc>();
      
      loginBloc.add(
        LoginSubmitted(
          email: _emailController.text,
          password: _passwordController.text,
        ),
      );
    } catch (e) {
      _showSnackBar('BLoC error: $e');
    }
  }

  void _handleForgotPassword() {
    try {
      context.read<LoginBloc>().add(
        ForgotPasswordRequested(
          email: _emailController.text,
        ),
      );
    } catch (e) {
      _showSnackBar('Error: $e');
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              _showSnackBar('Login successful!', isError: false);
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => MainScreen()),
                (route) => false,
              );
            } else if (state is LoginError) {
              _showSnackBar(state.message);
            } else if (state is OtpSent) {
              _showSnackBar('OTP sent to your email!', isError: false);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => OTPScreen(
                    email: state.email,
                    isPasswordReset: state.isPasswordReset,
                  ),
                ),
              );
            }
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height - 
                          MediaQuery.of(context).padding.top - 
                          MediaQuery.of(context).padding.bottom - 40,
              ),
              child: IntrinsicHeight(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Section
                      AuthTextHeading(
                        textone: "Sign in to your", 
                        texttwo: 'Account', 
                        textthree: 'Enter your email and password to log in ',
                      ),

                      SizedBox(height: 30),

                      // Form Fields Section
                      CustomTextFormField(
                        txt: "Email",
                        controller: _emailController, 
                        hintText: "Email",
                        keyboardType: TextInputType.emailAddress,
                        validator: Validators.email,
                      ),

                      SizedBox(height: 16),

                      CustomTextFormField(
                        txt: "Password",
                        controller: _passwordController,
                        hintText: "Enter your password",
                        obscureText: _obscurePassword,
                        onToggleObscureText: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                        validator: Validators.password,
                      ),

                      SizedBox(height: 8),

                      // Forgot Password
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          BlocBuilder<LoginBloc, LoginState>(
                            builder: (context, state) {
                              return GestureDetector(
                                onTap: state is LoginLoading ? null : _handleForgotPassword,
                                child: CustomTextButton(txt: "Forgot Password ?"),
                              );
                            },
                          ),
                        ],
                      ),

                      SizedBox(height: 24),

                      // Login Button Section
                      BlocBuilder<LoginBloc, LoginState>(
                        builder: (context, state) {
                          return Column(
                            children: [
                              CustomLoginButton(
                                text: state is LoginLoading ? "Logging in..." : "Log In",
                                onPressed: state is LoginLoading ? null : _handleLogin,
                                gradientColors: [
                                  AppColors.mustardShade1,
                                  AppColors.mustardShade2,
                                  AppColors.mustardShade3,
                                  AppColors.mustardShade4
                                ],
                              ),
                              
                              // Loading indicator
                              if (state is LoginLoading) ...[
                                SizedBox(height: 16),
                                Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      AppColors.mustardShade3,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          );
                        },
                      ),

                      SizedBox(height: 24),

                      // Divider Section
                      Row(
                        children: [
                          Expanded(child: Divider(color: Colors.grey[300])),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              "Or",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Expanded(child: Divider(color: Colors.grey[300])),
                        ],
                      ),

                      SizedBox(height: 20),

                      // Social Login Buttons
                      CustomSignInButtons(
                        txt: "Continue with Google", 
                        image: "assets/google.png",
                        height: 20,
                        width: 20,
                      ),
                      SizedBox(height: 12),
                      CustomSignInButtons(
                        txt: "Continue with Facebook", 
                        image: "assets/fb.png",
                        height: 30,
                        width: 30,
                      ),

                      // Flexible spacer that adjusts to available space
                      Expanded(
                        child: SizedBox(height: 20),
                      ),

                      // Sign Up Link (always at bottom)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0, top: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account? ",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                // Navigate to sign up screen
                              },
                              child: Text(
                                "Sign Up",
                                style: TextStyle(
                                  color: AppColors.brownishColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}