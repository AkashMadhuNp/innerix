import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:innerix/presentation/bloc/otp/bloc/otp_event.dart';
import 'package:innerix/presentation/bloc/otp/bloc/otp_state.dart';
import 'package:innerix/service/api_service.dart';

class OtpBloc extends Bloc<OtpEvent, OtpState> {
  Timer? _timer;
  static const int _timerDuration = 60;

  OtpBloc() : super(OtpInitial()) {
    on<OtpStartTimer>(_onStartTimer);
    on<OtpTimerTick>(_onTimerTick);
    on<OtpResendRequested>(_onResendRequested);
    on<OtpVerificationRequested>(_onVerificationRequested);
    on<OtpReset>(_onReset);
  }

  void _onStartTimer(OtpStartTimer event, Emitter<OtpState> emit) {
    _timer?.cancel();
    
    emit(const OtpTimerState(
      remainingTime: _timerDuration,
      canResend: false,
    ));

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final remainingTime = _timerDuration - timer.tick;
      
      if (remainingTime > 0) {
        add(OtpTimerTick(remainingTime));
      } else {
        add(OtpTimerTick(0));
        timer.cancel();
      }
    });
  }

  void _onTimerTick(OtpTimerTick event, Emitter<OtpState> emit) {
    emit(OtpTimerState(
      remainingTime: event.remainingTime,
      canResend: event.remainingTime == 0,
    ));
  }

  Future<void> _onResendRequested(
    OtpResendRequested event,
    Emitter<OtpState> emit,
  ) async {
    if (state is OtpTimerState && !(state as OtpTimerState).canResend) {
      return;
    }

    emit(OtpResendLoading());

    try {
      final response = await ApiService.requestOtp(event.email);

      if (response['success']) {
        emit(const OtpResendSuccess('OTP sent successfully!'));
        add(OtpStartTimer());
      } else {
        emit(OtpResendFailure(response['message'] ?? 'Failed to resend OTP'));
      }
    } catch (e) {
      emit(const OtpResendFailure('An error occurred. Please try again.'));
    }
  }

  Future<void> _onVerificationRequested(
    OtpVerificationRequested event,
    Emitter<OtpState> emit,
  ) async {
    emit(OtpVerificationLoading());

    try {
      final response = await ApiService.verifyOtp(event.email, event.otp);

      if (response.success) {
        emit(OtpVerificationSuccess(
          message: 'OTP verified successfully!',
          isPasswordReset: event.isPasswordReset,
        ));
      } else {
        emit(OtpVerificationFailure(
          response.message ?? 'OTP verification failed',
        ));
      }
    } catch (e) {
      emit(const OtpVerificationFailure(
        'An error occurred. Please try again.',
      ));
    }
  }

  void _onReset(OtpReset event, Emitter<OtpState> emit) {
    emit(OtpInitial());
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}

