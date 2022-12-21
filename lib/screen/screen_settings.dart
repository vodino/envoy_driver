import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  static const String path = 'settings';
  static const String name = 'settings';

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  /// Customer
  String _language(String languageCode) {
    final localizations = context.localizations;
    switch (languageCode) {
      case 'fr':
        return localizations.french;
      default:
        return localizations.english;
    }
  }

  Future<void> _openLogoutModal() async {
    final result = await showDialog<int>(
      context: context,
      builder: (context) {
        return SettingsLogoutModal(
          onCancel: () => Navigator.pop(context),
          onDelete: () => Navigator.pop(context, 1),
          onLogout: () => Navigator.pop(context, 0),
        );
      },
    );
    if (result != null) {
      if (result == 0) {
        _logoutClient();
      } else {
        _openDeleteModal();
      }
    }
  }

  Future<void> _openDeleteModal() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return SettingsDeleteModal(
          onCancelled: () => Navigator.pop(context),
          onDeleted: () => Navigator.pop(context, true),
        );
      },
    );
    if (result != null) {
      _deleteClient();
    }
  }

  /// ClientService
  late final ClientService _instanceClientService;
  late final ClientService _clientService;

  void _listenClientState(BuildContext context, ClientState state) {
    if (state is InitClientState) {
      Navigator.pop(context);
      _instanceClientService.value = state;
      context.goNamed(HomeScreen.name);
    }
  }

  void _logoutClient() {
    _clientService.handle(const LogoutClient());
  }

  void _deleteClient() {
    _clientService.handle(const DeleteClient());
  }

  @override
  void initState() {
    super.initState();

    /// ClientService
    _clientService = ClientService();
    _instanceClientService = ClientService.instance();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = context.localizations;
    return Scaffold(
      appBar: const SettingsAppBar(),
      body: BottomAppBar(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: CustomListTile(
                height: 60.0,
                title: Text(localizations.notifications.capitalize()),
                trailing: CupertinoSwitch(
                  onChanged: (value) {},
                  value: true,
                ),
                onTap: () {},
              ),
            ),
            SliverToBoxAdapter(
              child: CustomListTile(
                height: 60.0,
                title: Text(localizations.receivingcalls.capitalize()),
                trailing: CupertinoSwitch(
                  value: true,
                  onChanged: (value) {},
                ),
                onTap: () {},
              ),
            ),
            const SliverToBoxAdapter(child: Divider(indent: 16.0, endIndent: 16.0)),
            SliverToBoxAdapter(
              child: Builder(builder: (context) {
                final locale = Localizations.localeOf(context);
                return CustomListTile(
                  height: 65.0,
                  title: Text(localizations.language.capitalize()),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _language(locale.languageCode).capitalize(),
                        style: const TextStyle(color: CupertinoColors.systemGrey),
                      ),
                      const Icon(CupertinoIcons.forward, color: CupertinoColors.systemFill),
                    ],
                  ),
                  onTap: () => context.pushNamed(SettingsLanguageScreen.name),
                );
              }),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              fillOverscroll: true,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Divider(indent: 16.0, endIndent: 16.0),
                  ValueListenableConsumer<ClientState>(
                    listener: _listenClientState,
                    valueListenable: _clientService,
                    builder: (context, state, child) {
                      VoidCallback? onPressed = _openLogoutModal;
                      if (state is PendingClientState) onPressed = null;
                      return CupertinoButton(
                        onPressed: onPressed,
                        child: Visibility(
                          visible: onPressed != null,
                          replacement: const CupertinoActivityIndicator(),
                          child: Text(
                            localizations.logout.capitalize(),
                            style: const TextStyle(color: CupertinoColors.destructiveRed),
                          ),
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
