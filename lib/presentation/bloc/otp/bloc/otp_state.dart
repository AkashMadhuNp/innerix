import 'package:equatable/equatable.dart';

abstract class OtpState extends Equatable {
  const OtpState();

  @override
  List<Object?> get props => [];
}

class OtpInitial extends OtpState {}

class OtpTimerState extends OtpState {
  final int remainingTime;
  final bool canResend;

  const OtpTimerState({
    required this.remainingTime,
    required this.canResend,
  });

  @override
  List<Object> get props => [remainingTime, canResend];
}

class OtpResendLoading extends OtpState {}

class OtpResendSuccess extends OtpState {
  final String message;

  const OtpResendSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class OtpResendFailure extends OtpState {
  final String error;

  const OtpResendFailure(this.error);

  @override
  List<Object> get props => [error];
}

class OtpVerificationLoading extends OtpState {}

class OtpVerificationSuccess extends OtpState {
  final String message;
  final bool isPasswordReset;

  const OtpVerificationSuccess({
    required this.message,
    required this.isPasswordReset,
  });

  @override
  List<Object> get props => [message, isPasswordReset];
}

class OtpVerificationFailure extends OtpState {
  final String error;

  const OtpVerificationFailure(this.error);

  @override
  List<Object> get props => [error];
}
