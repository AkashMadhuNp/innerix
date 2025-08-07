import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:innerix/core/utils/validators.dart';
import 'package:innerix/presentation/bloc/login/bloc/login_event.dart';
import 'package:innerix/service/api_service.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<OtpRequested>(_onOtpRequested);
    on<ForgotPasswordRequested>(_onForgotPasswordRequested);
    on<LoginReset>(_onLoginReset);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    // Validate email
    if (event.email.trim().isEmpty) {
      emit(LoginError(message: 'Please enter your email address'));
      return;
    }

    final emailValidation = Validators.email(event.email.trim());
    if (emailValidation != null) {
      emit(LoginError(message: 'Please enter a valid email address'));
      return;
    }

    emit(LoginLoading());

    try {
      // If password is empty, request OTP
      if (event.password.trim().isEmpty) {
        final response = await ApiService.requestOtp(event.email.trim());
        
        if (response['success']) {
          emit(OtpSent(
            email: event.email.trim(),
            isPasswordReset: false,
          ));
        } else {
          emit(LoginError(
            message: response['message'] ?? 'Failed to send OTP',
          ));
        }
      } else {
        // Validate password
        final passwordValidation = Validators.password(event.password);
        if (passwordValidation != null && !passwordValidation.contains('valid')) {
          emit(LoginError(message: 'Please enter a valid password'));
          return;
        }

        // Attempt login
        final response = await ApiService.login(
          event.email.trim(),
          event.password,
        );

        if (response.success) {
          emit(LoginSuccess());
        } else {
          emit(LoginError(
            message: response.message ?? 'Login failed',
          ));
        }
      }
    } catch (e) {
      emit(LoginError(message: 'An error occurred. Please try again.'));
    }
  }

  Future<void> _onOtpRequested(
    OtpRequested event,
    Emitter<LoginState> emit,
  ) async {
    if (event.email.trim().isEmpty) {
      emit(LoginError(message: 'Please enter your email address'));
      return;
    }

    final emailValidation = Validators.email(event.email.trim());
    if (emailValidation != null) {
      emit(LoginError(message: 'Please enter a valid email address'));
      return;
    }

    emit(LoginLoading());

    try {
      final response = await ApiService.requestOtp(event.email.trim());
      
      if (response['success']) {
        emit(OtpSent(
          email: event.email.trim(),
          isPasswordReset: false,
        ));
      } else {
        emit(LoginError(
          message: response['message'] ?? 'Failed to send OTP',
        ));
      }
    } catch (e) {
      emit(LoginError(message: 'An error occurred. Please try again.'));
    }
  }

  Future<void> _onForgotPasswordRequested(
    ForgotPasswordRequested event,
    Emitter<LoginState> emit,
  ) async {
    if (event.email.trim().isEmpty) {
      emit(LoginError(message: 'Please enter your email address first'));
      return;
    }

    final emailValidation = Validators.email(event.email.trim());
    if (emailValidation != null) {
      emit(LoginError(message: 'Please enter a valid email address'));
      return;
    }

    emit(LoginLoading());

    try {
      final response = await ApiService.requestOtp(event.email.trim());
      
      if (response['success']) {
        emit(OtpSent(
          email: event.email.trim(),
          isPasswordReset: true,
        ));
      } else {
        emit(LoginError(
          message: response['message'] ?? 'Failed to send OTP',
        ));
      }
    } catch (e) {
      emit(LoginError(message: 'An error occurred. Please try again.'));
    }
  }

  void _onLoginReset(
    LoginReset event,
    Emitter<LoginState> emit,
  ) {
    emit(LoginInitial());
  }
}
