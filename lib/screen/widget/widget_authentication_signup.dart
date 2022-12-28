import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';

import '_widget.dart';

class AuthSignupAppBar extends DefaultAppBar {
  const AuthSignupAppBar({super.key});
  @override
  Widget build(BuildContext context) {
    final localizations = context.localizations;
    return CupertinoNavigationBar(
      middle: Text(localizations.accountinfo.capitalize()),
      border: const Border.fromBorderSide(BorderSide.none),
      transitionBetweenRoutes: false,
    );
  }
}

class AuthSignupTitle extends StatelessWidget {
  const AuthSignupTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = context.localizations;
    return CustomListTile(
      title: Center(
        child: Text(
          localizations.enteraccountinfo.capitalize(),
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
    final localizations = context.localizations;
    return CustomListTile(height: 30.0, title: Text(localizations.fullname.capitalize()));
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
    final localizations = context.localizations;
    return CustomTextField(
      hintText: localizations.fullname.capitalize(),
      controller: controller,
      focusNode: focusNode,
      autofocus: true,
    );
  }
}

class AuthSignupProfilAvatar extends StatelessWidget {
  const AuthSignupProfilAvatar({super.key, required this.foregroundImage, this.child});

  final ImageProvider<Object>? foregroundImage;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Badge(
      position: BadgePosition.bottomEnd(),
      badgeColor: CupertinoColors.black,
      badgeContent: const Icon(CupertinoIcons.pen, color: CupertinoColors.systemGrey4),
      child: CustomCircleAvatar(
        radius: 45.0,
        elevation: 0.0,
        foregroundImage: foregroundImage,
        backgroundColor: CupertinoColors.systemGrey,
        foregroundColor: CupertinoColors.systemGrey4,
        side: const BorderSide(color: CupertinoColors.systemGrey4, width: 2.0),
        child: child ?? const Icon(CupertinoIcons.profile_circled, size: 80.0),
      ),
    );
  }
}

class AuthSignupDocumentLabel extends StatelessWidget {
  const AuthSignupDocumentLabel({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = context.localizations;
    return CustomListTile(height: 30.0, title: Text(localizations.documentcniorpassport.capitalize()));
  }
}

class AuthSignupDocumentTextField extends StatelessWidget {
  const AuthSignupDocumentTextField({
    super.key,
    this.onTap,
    this.controller,
    this.focusNode,
    required this.hintText,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final VoidCallback? onTap;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      textAlign: TextAlign.center,
      controller: controller,
      focusNode: focusNode,
      hintText: hintText,
      readOnly: true,
      onTap: onTap,
    );
  }
}
