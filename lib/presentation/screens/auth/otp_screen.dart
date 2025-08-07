import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:innerix/core/constants/colors.dart';
import 'package:innerix/presentation/bloc/otp/bloc/otp_bloc.dart';
import 'package:innerix/presentation/bloc/otp/bloc/otp_event.dart';
import 'package:innerix/presentation/bloc/otp/bloc/otp_state.dart';
import 'package:innerix/presentation/screens/dashboard/main_screen.dart';
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
  late OtpBloc otpBloc;

  @override
  void initState() {
    super.initState();
    otpBloc = BlocProvider.of<OtpBloc>(context);
    otpBloc.add(OtpStartTimer());
  }

  void _showSnackBar(String message, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _handleResendCode() {
    otpBloc.add(OtpResendRequested(widget.email));
  }

  void _handleVerifyOTP() {
    if (!_formKey.currentState!.validate()) return;

    otpBloc.add(OtpVerificationRequested(
      email: widget.email,
      otp: otpController.text.trim(),
      isPasswordReset: widget.isPasswordReset,
    ));
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: BlocListener<OtpBloc, OtpState>(
            listener: (context, state) {
              if (state is OtpResendSuccess) {
                _showSnackBar(state.message, isError: false);
              } else if (state is OtpResendFailure) {
                _showSnackBar(state.error);
              } else if (state is OtpVerificationSuccess) {
                _showSnackBar(state.message, isError: false);
                
                Future.delayed(const Duration(milliseconds: 800), () {
                  if (state.isPasswordReset) {
                    _showSnackBar(
                      'Please check your email for password reset instructions',
                      isError: false,
                    );
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  } else {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const MainScreen(),
                      ),
                    );
                    Future.delayed(const Duration(milliseconds: 300), () {
                      if (mounted) {
                        _showSnackBar('Welcome! Login successful.', isError: false);
                      }
                    });
                  }
                });
              } else if (state is OtpVerificationFailure) {
                _showSnackBar(state.error);
              }
            },
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AuthTextHeading(
                    textone: "Let's verify",
                    texttwo: widget.isPasswordReset ? "Your Request" : "Your Account",
                    textthree: "Enter the OTP code we sent to\n${widget.email}.Need to ",
                    useRichText: true,
                    onEditTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  
                  const SizedBox(height: 30),

                  CustomTextFormField(
                    txt: "",
                    controller: otpController,
                    hintText: "Enter your OTP",
                    keyboardType: TextInputType.number,
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
                    child: BlocBuilder<OtpBloc, OtpState>(
                      buildWhen: (previous, current) =>
                          current is OtpTimerState ||
                          current is OtpResendLoading,
                      builder: (context, state) {
                        if (state is OtpResendLoading) {
                          return const Text(
                            "Resending...",
                            style: TextStyle(
                              color: AppColors.brownishColor,
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                          );
                        }

                        if (state is OtpTimerState) {
                          return GestureDetector(
                            onTap: state.canResend ? _handleResendCode : null,
                            child: Text(
                              state.canResend
                                  ? "Resend code"
                                  : "Resend code in (${_formatTime(state.remainingTime)})",
                              style: TextStyle(
                                color: AppColors.brownishColor,
                                fontSize: 14,
                                fontWeight: state.canResend
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                            ),
                          );
                        }

                        return const SizedBox.shrink();
                      },
                    ),
                  ),

                  const SizedBox(height: 30),

                  BlocBuilder<OtpBloc, OtpState>(
                    buildWhen: (previous, current) =>
                        current is OtpVerificationLoading ||
                        previous is OtpVerificationLoading,
                    builder: (context, state) {
                      final isLoading = state is OtpVerificationLoading;
                      
                      return CustomLoginButton(
                        text: isLoading ? "Verifying..." : "Verify OTP",
                        onPressed: _handleVerifyOTP,
                        gradientColors: const [
                          AppColors.mustardShade1,
                          AppColors.mustardShade2,
                          AppColors.mustardShade3,
                          AppColors.mustardShade4
                        ],
                      );
                    },
                  ),

                  BlocBuilder<OtpBloc, OtpState>(
                    buildWhen: (previous, current) =>
                        current is OtpVerificationLoading ||
                        previous is OtpVerificationLoading,
                    builder: (context, state) {
                      if (state is OtpVerificationLoading) {
                        return const Column(
                          children: [
                            SizedBox(height: 20),
                            Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.mustardShade3,
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

