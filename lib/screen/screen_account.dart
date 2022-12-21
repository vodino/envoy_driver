import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  static const String path = 'account';
  static const String name = 'account';

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  /// Customer
  late final TextEditingController _fullNameTextController;
  late final TextEditingController _phoneTextController;
  // late final TextEditingController _emailTextController;

  Future<void> _openFullNameModal() async {
    final value = await showDialog<String>(
      context: context,
      builder: (context) {
        return CustomTextFieldModal(
          hint: 'Nom Complet',
          title: 'Modifier le nom complet',
          value: _currentClient?.fullName,
        );
      },
    );
    if (value != null) {
      _updateClient(value);
    }
  }

  Future<void> _openPhoneNumberModal() async {
    final value = await showDialog<String>(
      context: context,
      builder: (context) {
        return CustomTextFieldModal(
          hint: 'Numero de téléphone',
          title: 'Modifier le numero de téléphone',
          value: _currentClient?.phoneNumber,
        );
      },
    );
    if (value != null) {
      _verifyPhoneNumber(value);
    }
  }

  // Future<void> _openEmailModal() async {
  //   final value = await showDialog<String>(
  //     context: context,
  //     builder: (context) {
  //       return const CustomTextFieldModal(
  //         hint: 'Email',
  //         title: "Modifier l'email",
  //       );
  //     },
  //   );
  //   if (value != null) {}
  // }

  /// ClientService
  late final ClientService _instanceClientService;
  late final ClientService _clientService;

  Client? _currentClient;

  void _updateClient(String fullName) {
    _clientService.handle(UpdateClient(
      fullName: fullName,
    ));
  }

  void _listenInstanceClientState(BuildContext context, ClientState state) {
    if (state is ClientItemState) {
      _currentClient = ClientService.authenticated;
      _fullNameTextController.text = _currentClient!.fullName!;
      _phoneTextController.text = _currentClient!.phoneNumber!;
    }
  }

  void _listenClientState(BuildContext context, ClientState state) {
    if (state is ClientItemState) {
      _instanceClientService.value = state;
      _currentClient = ClientService.authenticated;
      _fullNameTextController.text = _currentClient!.fullName!;
      _phoneTextController.text = _currentClient!.phoneNumber!;
    } else if (state is FailureClientState) {}
  }

  /// AuthService
  late final AuthService _authService;

  void _verifyPhoneNumber(String phoneNumber) {
    _authService.handle(
      VerifyPhoneNumberAuthEvent(
        phoneNumber: phoneNumber,
      ),
    );
  }

  void _listenAuthState(BuildContext context, AuthState state) {
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
              update: true,
            );
          },
        ),
      );
    } else if (state is FailureAuthState) {}
  }

  @override
  void initState() {
    super.initState();

    /// AuthService
    _authService = AuthService.instance();

    /// ClientService
    _clientService = ClientService();
    _instanceClientService = ClientService.instance();
    _currentClient = ClientService.authenticated!;

    /// Customer
    _fullNameTextController = TextEditingController(text: _currentClient!.fullName);
    _phoneTextController = TextEditingController(text: _currentClient!.phoneNumber);
    // _emailTextController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableListener<ClientState>(
      listener: _listenInstanceClientState,
      valueListenable: _instanceClientService,
      child: Scaffold(
        appBar: const AccountAppBar(),
        body: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(child: SizedBox(height: 16.0)),
            const SliverPadding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              sliver: SliverToBoxAdapter(
                child: AspectRatio(
                  aspectRatio: 4.0,
                  child: CircleAvatar(
                    backgroundColor: CupertinoColors.systemGrey,
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 12.0)),
            SliverPadding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              sliver: SliverToBoxAdapter(
                child: CustomListTile(
                  title: TextField(
                    readOnly: true,
                    onTap: _openFullNameModal,
                    controller: _fullNameTextController,
                    decoration: InputDecoration(
                      labelText: 'Nom complet',
                      border: const UnderlineInputBorder(),
                      suffixIcon: ValueListenableConsumer<ClientState>(
                        listener: _listenClientState,
                        valueListenable: _clientService,
                        builder: (context, state, child) {
                          return Visibility(
                            visible: state is! PendingClientState,
                            replacement: const CupertinoActivityIndicator(),
                            child: const Icon(CupertinoIcons.pencil),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 12.0)),
            SliverPadding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              sliver: SliverToBoxAdapter(
                child: CustomListTile(
                  title: TextField(
                    readOnly: true,
                    onTap: _openPhoneNumberModal,
                    controller: _phoneTextController,
                    decoration: InputDecoration(
                      labelText: 'Numréro de téléphone',
                      border: const UnderlineInputBorder(),
                      suffixIcon: ValueListenableConsumer<AuthState>(
                        listener: _listenAuthState,
                        valueListenable: _authService,
                        builder: (context, state, child) {
                          return Visibility(
                            visible: state is! PendingAuthState,
                            replacement: const CupertinoActivityIndicator(),
                            child: const Icon(CupertinoIcons.pencil),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // const SliverToBoxAdapter(child: SizedBox(height: 12.0)),
            // SliverPadding(
            //   padding: const EdgeInsets.symmetric(vertical: 8.0),
            //   sliver: SliverToBoxAdapter(
            //     child: CustomListTile(
            //       title: TextField(
            //         readOnly: true,
            //         onTap: _openEmailModal,
            //         controller: _emailTextController,
            //         decoration: const InputDecoration(
            //           border: UnderlineInputBorder(),
            //           labelText: 'Adresse mail (Optionnel)',
            //           suffixIcon: Icon(CupertinoIcons.pencil),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
