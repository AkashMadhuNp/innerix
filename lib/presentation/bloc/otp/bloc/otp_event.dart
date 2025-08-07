import 'package:equatable/equatable.dart';

abstract class OtpEvent extends Equatable {
  const OtpEvent();

  @override
  List<Object> get props => [];
}

class OtpStartTimer extends OtpEvent {}

class OtpTimerTick extends OtpEvent {
  final int remainingTime;

  const OtpTimerTick(this.remainingTime);

  @override
  List<Object> get props => [remainingTime];
}

class OtpResendRequested extends OtpEvent {
  final String email;

  const OtpResendRequested(this.email);

  @override
  List<Object> get props => [email];
}

class OtpVerificationRequested extends OtpEvent {
  final String email;
  final String otp;
  final bool isPasswordReset;

  const OtpVerificationRequested({
    required this.email,
    required this.otp,
    required this.isPasswordReset,
  });

  @override
  List<Object> get props => [email, otp, isPasswordReset];
}

class OtpReset extends OtpEvent {}
