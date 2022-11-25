import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '_service.dart';

class AuthService extends ValueNotifier<AuthState> {
  AuthService([AuthState value = const InitAuthState()]) : super(value);

  static AuthService? _instance;
  static AuthService instance([AuthState state = const InitAuthState()]) {
    return _instance ??= AuthService(state);
  }

  Future<void> handle(AuthEvent event) => event._execute(this);
}

abstract class AuthEvent {
  const AuthEvent();

  FirebaseAuth get firebaseAuth => FirebaseService.firebaseAuth;

  Future<void> _execute(AuthService service);
}

class VerifyPhoneNumberAuthEvent extends AuthEvent {
  const VerifyPhoneNumberAuthEvent({
    this.timeout = const Duration(seconds: 30),
    required this.phoneNumber,
    this.resendToken,
  });

  final String phoneNumber;
  final int? resendToken;

  final Duration timeout;

  @override
  Future<void> _execute(AuthService service) async {
    service.value = const PendingAuthState();
    try {
      await firebaseAuth.setLanguageCode(window.locale.languageCode);
      await firebaseAuth.verifyPhoneNumber(
        codeAutoRetrievalTimeout: (verificationId) {},
        codeSent: (verificationId, resendToken) {
          service.value = SmsCodeSentState(
            verificationId: verificationId,
            phoneNumber: phoneNumber,
            resendToken: resendToken,
            timeout: timeout,
          );
        },
        verificationCompleted: (credential) {
          service.value = PhoneNumberVerifiedState(
            credential: credential,
          );
        },
        verificationFailed: (exception) {
          service.value = FailureAuthState(
            message: exception.message!,
          );
        },
        forceResendingToken: resendToken,
        phoneNumber: phoneNumber,
        timeout: timeout,
      );
    } catch (error) {
      service.value = FailureAuthState(
        message: error.toString(),
        event: this,
      );
    }
  }
}

class SignInAuthEvent extends AuthEvent {
  SignInAuthEvent({
    required this.verificationId,
    required this.smsCode,
    this.credential,
  });

  PhoneAuthCredential? credential;
  final String verificationId;
  final String smsCode;

  @override
  Future<void> _execute(AuthService service) async {
    service.value = const PendingAuthState();
    try {
      credential ??= PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      final userCredential = await firebaseAuth.signInWithCredential(
        credential!,
      );
      service.value = UserSignedState(
        user: userCredential.user!,
      );
    } catch (error) {
      service.value = FailureAuthState(
        message: error.toString(),
        event: this,
      );
    }
  }
}

class SignOutAuthEvent extends AuthEvent {
  const SignOutAuthEvent();

  @override
  Future<void> _execute(AuthService service) async {
    service.value = const PendingAuthState();
    try {
      await FirebaseService.firebaseAuth.signOut();
    } catch (error) {
      service.value = FailureAuthState(
        message: error.toString(),
        event: this,
      );
    }
  }
}
