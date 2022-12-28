import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '_screen.dart';

class AuthVerificationScreen extends StatefulWidget {
  const AuthVerificationScreen({
    super.key,
    required this.verificationId,
    required this.phoneNumber,
    required this.resendToken,
    required this.timeout,
    this.update = false,
  });

  final String verificationId;
  final String phoneNumber;
  final Duration timeout;
  final int? resendToken;
  final bool update;

  static const String verificationIdKey = 'verificationId';
  static const String phoneNumberKey = 'phone_number';
  static const String timeoutKey = 'timeout';
  static const String resendTokenKey = 'resend_token';

  static const String name = 'auth_verification';
  static const String path = 'auth_verification';

  @override
  State<AuthVerificationScreen> createState() => _AuthVerificationScreenState();
}

class _AuthVerificationScreenState extends State<AuthVerificationScreen> {
  /// Props
  PhoneAuthCredential? _credential;
  late String _verificationId;
  late String _phoneNumber;
  late Duration _timeout;
  int? _resendToken;

  /// Input
  late final TextEditingController _smsCodeTextController;
  late final ValueNotifier<String?> _errorController;
  late final FocusNode _smsCodeFocusNode;

  void _listenError(BuildContext context, String? data) {
    if (data != null) HapticFeedback.vibrate();
  }

  void _onSmsCodeCompleted(String? data) {
    _signInUser();
  }

  /// AuthService
  late final AuthService _resendAuthService;
  late final AuthService _authService;

  void _verifyPhoneNumber() {
    _resendAuthService.handle(
      VerifyPhoneNumberAuthEvent(
        timeout: _timeout + const Duration(seconds: 30),
        phoneNumber: _phoneNumber,
        resendToken: _resendToken,
      ),
    );
  }

  void _signInUser() {
    _authService.handle(
      SignInOrUpdateAuthEvent(
        smsCode: _smsCodeTextController.text,
        verificationId: _verificationId,
        credential: _credential,
        update: widget.update,
      ),
    );
  }

  void _listenAuthService(BuildContext context, AuthState state) {
    if (state is SmsCodeSentState) {
      _timeout = state.timeout;
      _phoneNumber = state.phoneNumber;
      _resendToken = state.resendToken;
      _verificationId = state.verificationId;
    } else if (state is PhoneNumberVerifiedState) {
      _smsCodeFocusNode.unfocus();
      _errorController.value = null;
      _credential = state.credential;
      _smsCodeTextController.text = _credential!.smsCode!;
    } else if (state is UserSignedState) {
      _smsCodeFocusNode.unfocus();
      _errorController.value = null;
      _loginOrUpdateClient(phoneNumber: _phoneNumber, token: state.user.uid);
    } else if (state is PendingAuthState) {
      _smsCodeFocusNode.unfocus();
      _errorController.value = null;
    } else if (state is FailureAuthState) {
      _smsCodeFocusNode.unfocus();
      _errorController.value = state.message;
    }
  }

  /// ClientService
  late final ClientService _clientService;

  void _loginOrUpdateClient({required String phoneNumber, required String token}) {
    if (widget.update) {
      _clientService.handle(UpdateClient(phoneNumber: phoneNumber));
    } else {
      _clientService.handle(LoginClient(phoneNumber: phoneNumber, token: token));
    }
  }

  void _listenClientService(BuildContext context, ClientState state) {
    if (state is ClientItemState) {
      if (widget.update) {
        if (widget.update) ClientService.instance().value = state;
        Navigator.popUntil(context, (route) {
          return route is! CupertinoPageRoute;
        });
      } else {
        context.goNamed(HomeScreen.name);
      }
    } else if (state is NoClientItemState) {
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
          builder: (context) {
            return AuthSignupScreen(
              phoneNumber: state.phoneNumber!,
              token: state.token!,
            );
          },
        ),
      );
    } else if (state is FailureClientState) {
      _errorController.value = state.message;
    }
  }

  @override
  void initState() {
    super.initState();

    /// Props
    _timeout = widget.timeout;
    _phoneNumber = widget.phoneNumber;
    _resendToken = widget.resendToken;
    _verificationId = widget.verificationId;

    /// Input
    _smsCodeFocusNode = FocusNode();
    _errorController = ValueNotifier(null);
    _smsCodeTextController = TextEditingController();

    /// AuthService
    _authService = AuthService.instance();
    _resendAuthService = AuthService();

    /// ClientService
    _clientService = widget.update ? ClientService() : ClientService.instance();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = context.localizations;
    return Scaffold(
      appBar: const AuthVerificationAppBar(),
      body: BottomAppBar(
        elevation: 0.0,
        color: Colors.transparent,
        child: CustomScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          slivers: [
            const SliverToBoxAdapter(child: SizedBox(height: 16.0)),
            SliverToBoxAdapter(child: AuthVerificationTitle(phoneNumber: _phoneNumber)),
            const SliverToBoxAdapter(child: SizedBox(height: 12.0)),
            SliverToBoxAdapter(
              child: AuthVerificationFields(
                focusNode: _smsCodeFocusNode,
                onCompleted: _onSmsCodeCompleted,
                controller: _smsCodeTextController,
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 16.0)),
            SliverToBoxAdapter(
              child: Align(
                alignment: Alignment.centerRight,
                child: ValueListenableConsumer<AuthState>(
                  initiated: true,
                  listener: _listenAuthService,
                  valueListenable: _resendAuthService,
                  builder: (context, state, child) {
                    return CounterBuilder(
                      duration: _timeout,
                      builder: (context, duration, child) {
                        final seconds = duration.inSeconds.toString();
                        final bool active = seconds == '0';
                        final bool pending = state is PendingAuthState;
                        return CustomButton(
                          onPressed: active && !pending ? _verifyPhoneNumber : null,
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${localizations.resendcode.capitalize()}${active ? '' : ' ${localizations.inside} ${seconds.padLeft(2, '0')}s'}',
                                style: active && !pending ? const TextStyle(color: CupertinoColors.activeBlue) : null,
                              ),
                              Visibility(
                                visible: pending,
                                child: SizedBox.fromSize(
                                  size: const Size.fromRadius(10.0),
                                  child: const CustomLoading(),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 16.0)),
            SliverFillRemaining(
              hasScrollBody: false,
              fillOverscroll: true,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ValueListenableConsumer<String?>(
                    listener: _listenError,
                    valueListenable: _errorController,
                    builder: (context, data, child) {
                      return Visibility(
                        visible: data != null,
                        child: Builder(
                          builder: (context) {
                            return AuthErrorText(data!);
                          },
                        ),
                      );
                    },
                  ),
                  ValueListenableConsumer<ClientState>(
                    listener: _listenClientService,
                    valueListenable: _clientService,
                    builder: (context, state, child) {
                      final bool pending = state is PendingClientState;
                      return ValueListenableConsumer<AuthState>(
                        initiated: true,
                        listener: _listenAuthService,
                        valueListenable: _authService,
                        builder: (context, state, child) {
                          VoidCallback? onPressed = _signInUser;
                          if (state is PendingAuthState || pending) onPressed = null;
                          return AuthSubmitButton(
                            onPressed: onPressed,
                            child: Visibility(
                              visible: onPressed != null,
                              replacement: const CustomLoading(),
                              child: const Icon(CupertinoIcons.arrow_right),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
