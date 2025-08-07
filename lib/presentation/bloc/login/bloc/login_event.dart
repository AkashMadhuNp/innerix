
import 'package:equatable/equatable.dart';


abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}


class LoginSubmitted extends LoginEvent {
  final String email;
  final String password;

  const LoginSubmitted({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

class OtpRequested extends LoginEvent {
  final String email;

  const OtpRequested({required this.email});

  @override
  List<Object> get props => [email];
}

class ForgotPasswordRequested extends LoginEvent {
  final String email;

  const ForgotPasswordRequested({required this.email});

  @override
  List<Object> get props => [email];
}

class LoginReset extends LoginEvent {}



