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
  late final TextEditingController _emailTextController;

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
    if (value != null) {}
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
    if (value != null) {}
  }

  Future<void> _openEmailModal() async {
    final value = await showDialog<String>(
      context: context,
      builder: (context) {
        return const CustomTextFieldModal(
          hint: 'Email',
          title: "Modifier l'email",
        );
      },
    );
    if (value != null) {}
  }

  /// ClientService
  late final ClientService _clientService;
  Client? _currentClient;

  void _updateClient() {}

  void _listenClientState(BuildContext context, ClientState state) {}

  @override
  void initState() {
    super.initState();

    /// ClientService
    _clientService = ClientService.instance();
    _currentClient = ClientService.authenticated!;

    /// Customer
    _fullNameTextController = TextEditingController(text: _currentClient!.fullName);
    _phoneTextController = TextEditingController(text: _currentClient!.phoneNumber);
    _emailTextController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  decoration: const InputDecoration(
                    labelText: 'Nom complet',
                    border: UnderlineInputBorder(),
                    suffixIcon: Icon(CupertinoIcons.pencil),
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
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Numréro de téléphone',
                    suffixIcon: Icon(CupertinoIcons.pencil),
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
                  onTap: _openEmailModal,
                  controller: _emailTextController,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Adresse mail (Optionnel)',
                    suffixIcon: Icon(CupertinoIcons.pencil),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
