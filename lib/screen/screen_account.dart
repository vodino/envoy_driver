import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
  late final ValueNotifier<String?> _avatarPhotoController;

  Future<Uint8List?> _openAccountPhotoModal() async {
    final result = await showDialog<int>(
      context: context,
      builder: (context) {
        return AccountPhotoModal(
          onCancel: () => Navigator.pop(context),
          onCamera: () => Navigator.pop(context, 1),
          onGallery: () => Navigator.pop(context, 0),
        );
      },
    );
    if (result != null) {
      if (result == 0) {
        return _openEditImage(ImageSource.gallery);
      } else {
        return _openEditImage(ImageSource.camera);
      }
    }
    return null;
  }

  Future<Uint8List?> _openEditImage(ImageSource source) async {
    final file = await ImagePicker().pickImage(source: source);
    if (file != null && mounted) {
      return Navigator.push<Uint8List>(
        context,
        CupertinoPageRoute(
          builder: (context) {
            final localizations = context.localizations;
            return ImageEditorScreen(
              image: file.path,
              title: localizations.modifyprofilephoto.capitalize(),
            );
          },
        ),
      );
    }
    return null;
  }

  void _openAvatarPhotoModal() async {
    final data = await _openAccountPhotoModal();
    if (data != null) {
      _updateClient(avatar: data, service: _avatarClientService);
    }
  }

  Future<void> _openFullNameModal() async {
    final value = await showDialog<String>(
      context: context,
      builder: (context) {
        final localizations = context.localizations;
        return CustomTextFieldModal(
          value: _currentClient?.fullName,
          hint: localizations.fullname.capitalize(),
          title: localizations.modifyfullname.capitalize(),
        );
      },
    );
    if (value != null) {
      _updateClient(fullName: value, service: _fullNameClientService);
    }
  }

  Future<void> _openPhoneNumberModal() async {
    final value = await showDialog<String>(
      context: context,
      builder: (context) {
        final localizations = context.localizations;
        return CustomTextFieldModal(
          value: _currentClient?.phoneNumber,
          hint: localizations.phonenumber.capitalize(),
          title: localizations.modifyphonenumber.capitalize(),
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
  late final ClientService _fullNameClientService;
  late final ClientService _avatarClientService;

  Client? _currentClient;

  void _updateClient({String? fullName, Uint8List? avatar, required ClientService service}) {
    service.handle(UpdateClient(
      fullName: fullName,
      avatar: avatar,
    ));
  }

  void _listenInstanceClientState(BuildContext context, ClientState state) {
    if (state is ClientItemState) {
      _currentClient = ClientService.authenticated;
      _avatarPhotoController.value = _currentClient!.avatar;
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
    _avatarClientService = ClientService();
    _fullNameClientService = ClientService();
    _instanceClientService = ClientService.instance();
    _currentClient = ClientService.authenticated!;

    /// Customer
    _avatarPhotoController = ValueNotifier(_currentClient!.avatar);
    _fullNameTextController = TextEditingController(text: _currentClient!.fullName);
    _phoneTextController = TextEditingController(text: _currentClient!.phoneNumber);
    // _emailTextController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = context.localizations;
    return ValueListenableListener<ClientState>(
      listener: _listenInstanceClientState,
      valueListenable: _instanceClientService,
      child: Scaffold(
        appBar: const AccountAppBar(),
        body: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(child: SizedBox(height: 16.0)),
            SliverPadding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              sliver: SliverToBoxAdapter(
                child: AspectRatio(
                  aspectRatio: 4.0,
                  child: ValueListenableConsumer<ClientState>(
                    listener: _listenClientState,
                    valueListenable: _avatarClientService,
                    builder: (context, state, child) {
                      return ValueListenableBuilder<String?>(
                        valueListenable: _avatarPhotoController,
                        builder: (context, file, child) {
                          if (state is PendingClientState) file = null;
                          return CustomButton(
                            onPressed: _openAvatarPhotoModal,
                            child: AuthSignupProfilAvatar(
                              foregroundImage: file != null ? NetworkImage('${RepositoryService.httpURL}/storage/$file') : null,
                              child: state is PendingClientState ? const CircularProgressIndicator.adaptive() : null,
                            ),
                          );
                        },
                      );
                    },
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
                      border: const UnderlineInputBorder(),
                      labelText: localizations.fullname.capitalize(),
                      suffixIcon: ValueListenableConsumer<ClientState>(
                        listener: _listenClientState,
                        valueListenable: _fullNameClientService,
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
                      border: const UnderlineInputBorder(),
                      labelText: localizations.phonenumber.capitalize(),
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
