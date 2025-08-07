import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {}

class OtpSent extends LoginState {
  final String email;
  final bool isPasswordReset;

  const OtpSent({
    required this.email,
    required this.isPasswordReset,
  });

  @override
  List<Object> get props => [email, isPasswordReset];
}

class LoginError extends LoginState {
  final String message;

  const LoginError({required this.message});

  @override
  List<Object> get props => [message];
}

