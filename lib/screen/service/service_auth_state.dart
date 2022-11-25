import 'package:firebase_auth/firebase_auth.dart';

import '_service.dart';

abstract class AuthState {
  const AuthState();
}

class InitAuthState extends AuthState {
  const InitAuthState();
}

class PendingAuthState extends AuthState {
  const PendingAuthState();
}

class FailureAuthState extends AuthState {
  const FailureAuthState({
    required this.message,
    this.event,
  });

  final String message;
  final AuthEvent? event;
}

class SmsCodeSentState extends AuthState {
  const SmsCodeSentState({
    required this.verificationId,
    required this.resendToken,
    required this.phoneNumber,
    required this.timeout,
  });
  final String verificationId;
  final String phoneNumber;
  final Duration timeout;
  final int? resendToken;
}

class PhoneNumberVerifiedState extends AuthState {
  const PhoneNumberVerifiedState({
    required this.credential,
  });
  final PhoneAuthCredential credential;
}

class UserSignedState extends AuthState {
  const UserSignedState({
    required this.user,
  });
  final User user;
}
