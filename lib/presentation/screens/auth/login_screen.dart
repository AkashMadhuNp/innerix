import 'package:flutter/material.dart';
import 'package:innerix/core/constants/colors.dart';
import 'package:innerix/core/utils/validators.dart';
import 'package:innerix/presentation/screens/dashboard/home_Screen.dart';
import 'package:innerix/service/api_service.dart';
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
  bool _isLoading = false;
  
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
      ),
    );
  }

  Future<void> _handleLogin() async {
  // Check if email is empty
  if (_emailController.text.trim().isEmpty) {
    _showSnackBar('Please enter your email address');
    return;
  }

  // Validate email format
  final emailValidation = Validators.email(_emailController.text.trim());
  if (emailValidation != null) {
    _showSnackBar('Please enter a valid email address');
    return;
  }

  setState(() {
    _isLoading = true;
  });

  try {
    // Case 1: Only email is filled (password is empty) → Request OTP
    if (_passwordController.text.trim().isEmpty) {
      final response = await ApiService.requestOtp(_emailController.text.trim());
      
      if (response['success']) {
        _showSnackBar('OTP sent to your email!', isError: false);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => OTPScreen(
              email: _emailController.text.trim(),
              isPasswordReset: false, // This is for login, not password reset
            ),
          ),
        );
      } else {
        _showSnackBar(response['message'] ?? 'Failed to send OTP');
      }
    }
    // Case 2: Both email and password are filled → Regular login
    else {
      // Validate password
      final passwordValidation = Validators.password(_passwordController.text);
      if (passwordValidation != null && !passwordValidation.contains('valid')) {
        _showSnackBar('Please enter a valid password');
        return;
      }

      final response = await ApiService.login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (response.success) {
        _showSnackBar('Login successful!', isError: false);
        
        
        
        // Alternative: Direct navigation
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => HomeScreen()),
          (route) => false,
        );
      } else {
        _showSnackBar(response.message ?? 'Login failed');
      }
    }
  } catch (e) {
    _showSnackBar('An error occurred. Please try again.');
  } finally {
    setState(() {
      _isLoading = false;
    });
  }
}

  Future<void> _handleForgotPassword() async {
    if (_emailController.text.trim().isEmpty) {
      _showSnackBar('Please enter your email address first');
      return;
    }

    if (!Validators.email(_emailController.text.trim())!.contains('valid')) {
      _showSnackBar('Please enter a valid email address');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await ApiService.requestOtp(_emailController.text.trim());
      
      if (response['success']) {
        _showSnackBar('OTP sent to your email!', isError: false);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => OTPScreen(
              email: _emailController.text.trim(),
              isPasswordReset: true,
            ),
          ),
        );
      } else {
        _showSnackBar(response['message'] ?? 'Failed to send OTP');
      }
    } catch (e) {
      _showSnackBar('An error occurred. Please try again.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AuthTextHeading(
                  textone: "Sign in to your", 
                  texttwo: 'Account', 
                  textthree: 'Enter your email and password to log in',
                ),

                SizedBox(height: 30),

                CustomTextFormField(
                  txt: "Email",
                  controller: _emailController, 
                  hintText: "Email",
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.email,
                  //enabled: !_isLoading,
                ),

                SizedBox(height: 10),

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
                  ////enabled: !_isLoading,
                ),

                SizedBox(height: 5),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: _isLoading ? null : _handleForgotPassword,
                      child: CustomTextButton(txt: "Forgot Password ?"),
                    ),
                  ],
                ),

                SizedBox(height: 20),

                CustomLoginButton(
                  text: _isLoading ? "Logging in..." : "Log In",
                  onPressed:  _handleLogin,
                  gradientColors: [
                    AppColors.mustardShade1,
                    AppColors.mustardShade2,
                    AppColors.mustardShade3,
                    AppColors.mustardShade4
                  ],
                ),

                if (_isLoading) ...[
                  SizedBox(height: 10),
                  Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.mustardShade3,
                      ),
                    ),
                  ),
                ],

                SizedBox(height: 20),

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

                // Google Sign In Button
                CustomSignInButtons(
                  txt: "Continue with Google", 
                  image: "assets/google.png",
                  height: 20,
                  width: 20,
                ),
                SizedBox(height: 10),
                CustomSignInButtons(
                  txt: "Continue with Facebook", 
                  image: "assets/fb.png",
                  height: 30,
                  width: 30,
                ),

                Spacer(),

                // Sign Up Text
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
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
                          
                        },
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                            color: Color(0xFFE67E22),
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
    );
  }
}