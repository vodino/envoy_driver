import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '_screen.dart';

class AuthSignupScreen extends StatefulWidget {
  const AuthSignupScreen({
    super.key,
    required this.phoneNumber,
    required this.token,
  });

  final String phoneNumber;
  final String token;

  static const String phoneNumberKey = 'phone_number';
  static const String tokenKey = 'token';

  static const String name = 'auth_signup';
  static const String path = 'auth_signup';

  @override
  State<AuthSignupScreen> createState() => _AuthSignupScreenState();
}

class _AuthSignupScreenState extends State<AuthSignupScreen> {
  /// Customer
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
              title: localizations.modifyprofilephoto.capitalize(),
              image: file.path,
            );
          },
        ),
      );
    }
    return null;
  }

  Future<Uint8List?> _openImageContent({
    required Uint8List image,
    required String title,
  }) {
    return Navigator.push<Uint8List>(
      context,
      CupertinoPageRoute(
        builder: (context) {
          return ImageContentScreen(image: image, title: title);
        },
      ),
    );
  }

  void _openProfilePhotoModal() async {
    final data = await _openAccountPhotoModal();
    if (data != null) _profilePhotoController.value = data;
  }

  void _openDocumentRectoPhotoModal() async {
    final localizations = context.localizations;
    if (_documentRectoPhotoController.value != null) {
      final data = await _openImageContent(
        image: _documentRectoPhotoController.value!,
        title: localizations.rectodocument.capitalize(),
      );
      if (data != null) _documentRectoPhotoController.value = data;
    } else {
      final data = await _openAccountPhotoModal();
      if (data != null) {
        _documentRectoPhotoController.value = data;
        _documentRectoTextController.text = localizations.rectocompleted.capitalize();
      }
    }
  }

  void _openDocumentVersoPhotoModal() async {
    final localizations = context.localizations;
    if (_documentVersoPhotoController.value != null) {
      final data = await _openImageContent(
        image: _documentVersoPhotoController.value!,
        title: localizations.versodocument.capitalize(),
      );
      if (data != null) _documentVersoPhotoController.value = data;
    } else {
      final data = await _openAccountPhotoModal();
      if (data != null) {
        _documentVersoPhotoController.value = data;
        _documentVersoTextController.text = localizations.versocompleted.capitalize();
      }
    }
  }

  /// Input
  late final ValueNotifier<Uint8List?> _documentRectoPhotoController;
  late final TextEditingController _documentRectoTextController;
  late final ValueNotifier<Uint8List?> _documentVersoPhotoController;
  late final TextEditingController _documentVersoTextController;
  late final ValueNotifier<Uint8List?> _profilePhotoController;
  late final TextEditingController _fullNameTextController;
  late final ValueNotifier<String?> _errorController;
  late final FocusNode _fullNameFocusNode;

  void _listenError(BuildContext context, String? data) {
    if (data != null) HapticFeedback.vibrate();
  }

  /// ClientService
  late final ClientService _clientService;

  void _registerClient() {
    _clientService.handle(RegisterClient(
      documentRecto: _documentRectoPhotoController.value,
      documentVerso: _documentVersoPhotoController.value,
      fullName: _fullNameTextController.text.trim(),
      avatar: _profilePhotoController.value!,
      phoneNumber: widget.phoneNumber,
      firebaseToken: widget.token,
    ));
  }

  void _listenClientService(BuildContext context, ClientState state) {
    if (state is ClientItemState) {
      context.goNamed(HomeScreen.name);
    } else if (state is FailureClientState) {
      _errorController.value = state.message;
    }
  }

  @override
  void initState() {
    super.initState();

    /// Input
    _fullNameFocusNode = FocusNode();
    _errorController = ValueNotifier(null);
    _profilePhotoController = ValueNotifier(null);
    _fullNameTextController = TextEditingController();
    _documentRectoPhotoController = ValueNotifier(null);
    _documentRectoTextController = TextEditingController();
    _documentVersoPhotoController = ValueNotifier(null);
    _documentVersoTextController = TextEditingController();

    /// ClientService
    _clientService = ClientService.instance();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = context.localizations;
    return Scaffold(
      appBar: const AuthSignupAppBar(),
      body: BottomAppBar(
        elevation: 0.0,
        color: Colors.transparent,
        child: CustomScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          slivers: [
            SliverPinnedHeader.builder((context, overlap) {
              return Visibility(
                visible: overlap,
                child: const Divider(),
              );
            }),
            SliverPadding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              sliver: SliverToBoxAdapter(
                child: AspectRatio(
                  aspectRatio: 4.0,
                  child: ValueListenableBuilder<Uint8List?>(
                    valueListenable: _profilePhotoController,
                    builder: (context, file, child) {
                      return CustomButton(
                        onPressed: _openProfilePhotoModal,
                        child: AuthSignupProfilAvatar(
                          foregroundImage: file != null ? MemoryImage(file) : null,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 12.0)),
            const SliverToBoxAdapter(child: AuthSignupTitle()),
            const SliverToBoxAdapter(child: SizedBox(height: 12.0)),
            const SliverToBoxAdapter(child: AuthSignupFullNameLabel()),
            SliverToBoxAdapter(
              child: AuthSignupFullNameTextField(
                controller: _fullNameTextController,
                focusNode: _fullNameFocusNode,
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 12.0)),
            const SliverToBoxAdapter(child: AuthSignupDocumentLabel()),
            SliverToBoxAdapter(
              child: Row(
                children: [
                  Expanded(
                    child: AuthSignupDocumentTextField(
                      hintText: localizations.recto.capitalize(),
                      controller: _documentRectoTextController,
                      onTap: _openDocumentRectoPhotoModal,
                    ),
                  ),
                  Expanded(
                    child: ValueListenableBuilder<Uint8List?>(
                      valueListenable: _documentVersoPhotoController,
                      builder: (context, file, child) {
                        return AuthSignupDocumentTextField(
                          hintText: localizations.verso.capitalize(),
                          controller: _documentVersoTextController,
                          onTap: _openDocumentVersoPhotoModal,
                        );
                      },
                    ),
                  ),
                ],
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
                      VoidCallback? onPressed = _registerClient;
                      if (state is PendingClientState) onPressed = null;
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
