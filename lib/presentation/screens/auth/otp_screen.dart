import 'package:flutter/material.dart';
import 'dart:async';
import 'package:innerix/core/constants/colors.dart';
import 'package:innerix/presentation/screens/dashboard/home_Screen.dart';
import 'package:innerix/service/api_service.dart';
import 'package:innerix/presentation/widgets/auth/auth_heading_txt.dart';
import 'package:innerix/presentation/widgets/auth/custom_button.dart';
import 'package:innerix/presentation/widgets/auth/custom_textfield.dart';

class OTPScreen extends StatefulWidget {
  final String email;
  final bool isPasswordReset;

  const OTPScreen({
    super.key,
    required this.email,
    this.isPasswordReset = false,
  });

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final TextEditingController otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  Timer? _timer;
  int _remainingTime = 60; 
  bool _canResend = false;
  bool _isLoading = false;
  bool _isResending = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _canResend = false;
    _remainingTime = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        setState(() {
          _canResend = true;
        });
        _timer?.cancel();
      }
    });
  }

  void _showSnackBar(String message, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 3),
      ),
    );
  }

  Future<void> _resendCode() async {
    if (!_canResend || _isResending) return;

    setState(() {
      _isResending = true;
    });

    try {
      final response = await ApiService.requestOtp(widget.email);
      
      if (response['success']) {
        _showSnackBar('OTP sent successfully!', isError: false);
        _startTimer(); 
      } else {
        _showSnackBar(response['message'] ?? 'Failed to resend OTP');
      }
    } catch (e) {
      _showSnackBar('An error occurred. Please try again.');
    } finally {
      setState(() {
        _isResending = false;
      });
    }
  }

  Future<void> _verifyOTP() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await ApiService.verifyOtp(
        widget.email,
        otpController.text.trim(),
      );

      if (response.success) {
        // Show success message with green snackbar
        _showSnackBar('OTP verified successfully!', isError: false);
        
        // Small delay to let user see the success message
        await Future.delayed(Duration(milliseconds: 800));
        
        if (widget.isPasswordReset) {
          // For password reset flow
          _showSnackBar('Please check your email for password reset instructions', isError: false);
          Navigator.of(context).popUntil((route) => route.isFirst);
        } else {
          // For login flow - navigate to home screen
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => HomeScreen(),
            ),
          );
          // Show welcome message after navigation
          Future.delayed(Duration(milliseconds: 300), () {
            if (mounted) {
              _showSnackBar('Welcome! Login successful.', isError: false);
            }
          });
        }
      } else {
        // Show error message
        _showSnackBar(response.message ?? 'OTP verification failed');
      }
    } catch (e) {
      _showSnackBar('An error occurred. Please try again.');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AuthTextHeading(
                  textone: "Let's verify",
                  texttwo: widget.isPasswordReset ? "Your Request" : "Your Account",
                  textthree: widget.isPasswordReset 
                      ? "Enter the OTP code we sent to\n${widget.email}"
                      : "Enter the OTP code we sent to\n${widget.email}",
                ),
                
                const SizedBox(height: 30),

                CustomTextFormField(
                  txt: "OTP",
                  controller: otpController,
                  hintText: "Enter your OTP",
                  keyboardType: TextInputType.number,
                 // enabled: !_isLoading,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter the OTP';
                    }
                    if (value.trim().length < 4) {
                      return 'Please enter a valid OTP';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                Center(
                  child: GestureDetector(
                    onTap: (_canResend && !_isResending && !_isLoading) ? _resendCode : null,
                    child: Text(
                      _isResending 
                          ? "Resending..."
                          : _canResend 
                              ? "Resend code" 
                              : "Resend code in (${_formatTime(_remainingTime)})",
                      style: TextStyle(
                        color: (_canResend && !_isResending && !_isLoading) 
                            ? AppColors.mustardShade3 
                            : Colors.grey,
                        fontSize: 14,
                        fontWeight: (_canResend && !_isResending && !_isLoading) 
                            ? FontWeight.w600 
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                CustomLoginButton(
                  text: _isLoading ? "Verifying..." : "Verify OTP",
                  onPressed:  _verifyOTP,
                  gradientColors: [
                    AppColors.mustardShade1,
                    AppColors.mustardShade2,
                    AppColors.mustardShade3,
                    AppColors.mustardShade4
                  ],
                ),

                if (_isLoading) ...[
                  SizedBox(height: 20),
                  Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.mustardShade3,
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}