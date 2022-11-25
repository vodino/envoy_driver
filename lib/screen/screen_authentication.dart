import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  static const String path = '/auth';
  static const String name = 'auth';

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  /// Input
  late final TextEditingController _phoneTextController;
  late final ValueNotifier<String?> _errorController;
  late final ValueNotifier<bool> _privacyController;
  late final FocusNode _phoneFocusNode;
  CountrySchema? _currentCountry;

  void _listenError(BuildContext context, String? data) {
    if (data != null) HapticFeedback.vibrate();
  }

  String get _phoneNumber {
    final String dialCode = _currentCountry!.dialCode;
    final String phoneNumber = _phoneTextController.text.trimSpace();
    return '$dialCode $phoneNumber';
  }

  /// AuthService
  late final AuthService _authService;

  void _verifyPhoneNumber() {
    if (_phoneTextController.text.trim().isEmpty) {
      _errorController.value = 'Numéro de téléphone est requis.';
      return;
    }
    if (_currentCountry == null) {
      _errorController.value = 'Indicatif est requis.';
      return;
    }
    if (!_privacyController.value) {
      _errorController.value = "Veuillez accepter les conditions d'utilistaion.";
      return;
    }
    _authService.handle(
      VerifyPhoneNumberAuthEvent(
        phoneNumber: _phoneNumber,
      ),
    );
  }

  void _listenAuthService(BuildContext context, AuthState state) {
    if (state is SmsCodeSentState) {
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) {
            return AuthVerificationScreen(
              verificationId: state.verificationId,
              phoneNumber: state.phoneNumber,
              resendToken: state.resendToken,
              timeout: state.timeout,
            );
          },
        ),
      );
    } else if (state is PendingAuthState) {
      _phoneFocusNode.unfocus();
      _errorController.value = null;
    } else if (state is FailureAuthState) {
      _phoneFocusNode.unfocus();
      _errorController.value = state.message;
    }
  }

  /// CountryService
  late final CountryService _countryService;

  void _getCountries() {
    _countryService.handle(const GetCountries());
  }

  void _goToAuthCountry({
    required List<CountrySchema> items,
    CountrySchema? currentItem,
  }) async {
    final country = await showModalBottomSheet<CountrySchema>(
      context: context,
      builder: (context) {
        return AuthCountryScreen(
          currentItem: currentItem,
          items: items,
        );
      },
    );
    if (country != null) {
      _countryService.value = CountryItemListState(
        currentCountry: country,
        data: items,
      );
    }
  }

  void _listenCountryService(BuildContext context, CountryState state) {
    if (state is PendingCountryState) {
      _errorController.value = null;
    }
  }

  @override
  void initState() {
    super.initState();

    /// Input
    _phoneFocusNode = FocusNode();
    _errorController = ValueNotifier(null);
    _privacyController = ValueNotifier(false);
    _phoneTextController = TextEditingController();

    /// AuthService
    _authService = AuthService.instance();

    /// CountryService
    _countryService = CountryService.instance();
    if (_countryService.value is! CountryItemListState) _getCountries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AuthAppBar(),
      body: BottomAppBar(
        elevation: 0.0,
        color: Colors.transparent,
        child: CustomScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          slivers: [
            const SliverToBoxAdapter(child: AuthEnvoyIcon()),
            const SliverToBoxAdapter(child: SizedBox(height: 8.0)),
            const SliverToBoxAdapter(child: AuthTitle()),
            const SliverToBoxAdapter(child: SizedBox(height: 12.0)),
            SliverToBoxAdapter(
              child: ValueListenableConsumer<CountryState>(
                valueListenable: _countryService,
                listener: _listenCountryService,
                builder: (context, state, child) {
                  VoidCallback? onPressed = _getCountries;
                  if (state is PendingCountryState) {
                    onPressed = null;
                  } else if (state is CountryItemListState) {
                    _currentCountry = state.currentCountry;
                    onPressed = () => _goToAuthCountry(items: state.data, currentItem: state.currentCountry);
                  }
                  return Row(
                    children: [
                      AuthDialCodeInput(
                        onPressed: onPressed,
                        child: Visibility(
                          visible: onPressed != null,
                          replacement: SizedBox.fromSize(
                            size: const Size.fromRadius(13.0),
                            child: const CustomLoading(),
                          ),
                          child: Visibility(
                            visible: _currentCountry != null,
                            replacement: const Icon(CupertinoIcons.refresh),
                            child: Builder(
                              builder: (context) {
                                return Text(
                                  '${CustomString.toFlag(_currentCountry!.code)} '
                                  '${_currentCountry!.dialCode}',
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: AuthPhoneTextField(
                          enabled: onPressed != null,
                          focusNode: _phoneFocusNode,
                          controller: _phoneTextController,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24.0)),
            SliverToBoxAdapter(
              child: ValueListenableBuilder<bool>(
                valueListenable: _privacyController,
                builder: (context, value, child) {
                  return AuthPrivacyInput(
                    value: value,
                    onChanged: (value) {
                      if (value != null) _privacyController.value = value;
                    },
                  );
                },
              ),
            ),
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
                  ValueListenableConsumer<AuthState>(
                    valueListenable: _authService,
                    listener: _listenAuthService,
                    builder: (context, state, _) {
                      VoidCallback? onPressed = _verifyPhoneNumber;
                      if (state is PendingAuthState) onPressed = null;
                      return AuthSubmitButton(
                        onPressed: onPressed,
                        child: Visibility(
                          visible: onPressed != null,
                          replacement: const CustomLoading(),
                          child: const Icon(CupertinoIcons.arrow_right),
                        ),
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
