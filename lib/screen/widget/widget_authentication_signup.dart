import 'package:flutter/cupertino.dart';

import '_widget.dart';

class AuthSignupAppBar extends DefaultAppBar {
  const AuthSignupAppBar({super.key});
  @override
  Widget build(BuildContext context) {
    return const CupertinoNavigationBar(
      middle: Text('Informations du compte'),
      border: Border.fromBorderSide(BorderSide.none),
    );
  }
}

class AuthSignupTitle extends StatelessWidget {
  const AuthSignupTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomListTile(
      title: Center(
        child: Text(
          "Entrer votre vrai nom complet pour pouvoir mieux utiliser l'application.",
          style: context.cupertinoTheme.textTheme.navTitleTextStyle.copyWith(
            color: CupertinoColors.systemGrey,
            fontWeight: FontWeight.w400,
          ),
          textScaleFactor: context.mediaQuery.textScaleFactor,
          overflow: TextOverflow.visible,
          textAlign: TextAlign.center,
          softWrap: true,
        ),
      ),
    );
  }
}

class AuthSignupFullNameLabel extends StatelessWidget {
  const AuthSignupFullNameLabel({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomListTile(height: 30.0, title: Text('Nom Complet'));
  }
}

class AuthSignupFullNameTextField extends StatelessWidget {
  const AuthSignupFullNameTextField({
    super.key,
    this.controller,
    this.focusNode,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      hintText: 'nom complet',
      controller: controller,
      focusNode: focusNode,
      autofocus: true,
    );
  }
}
