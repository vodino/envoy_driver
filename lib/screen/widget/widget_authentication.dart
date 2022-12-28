import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '_widget.dart';

class AuthAppBar extends DefaultAppBar {
  const AuthAppBar({super.key});
  @override
  Widget build(BuildContext context) {
    return const CupertinoNavigationBar(
      border: Border.fromBorderSide(BorderSide.none),
      transitionBetweenRoutes: false,
    );
  }
}

class AuthEnvoyIcon extends StatelessWidget {
  const AuthEnvoyIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 4.5,
      child: Center(child: Assets.images.envoyDriverIcon.image()),
    );
  }
}

class AuthTitle extends StatelessWidget {
  const AuthTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = context.localizations;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: CustomListTile(
          title: Text(
            localizations.authenticatephonenumberbysms.capitalize(),
            style: context.cupertinoTheme.textTheme.navTitleTextStyle,
            overflow: TextOverflow.visible,
            textAlign: TextAlign.center,
            softWrap: true,
          ),
        ),
      ),
    );
  }
}

class AuthDialCodeInput extends StatelessWidget {
  const AuthDialCodeInput({
    super.key,
    this.onPressed,
    required this.child,
  });

  final Widget child;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final localizations = context.localizations;
    return Container(
      width: 100.0,
      padding: const EdgeInsets.only(left: 12.0),
      child: Column(
        children: [
          CustomListTile(
            height: 30.0,
            title: Text(localizations.dialcode.capitalize()),
            contentPadding: const EdgeInsets.symmetric(horizontal: 6.0),
          ),
          CustomButton(
            onPressed: onPressed,
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(bottom: 9.0, right: 8.0, left: 8.0, top: 8.0),
              decoration: BoxDecoration(
                color: CupertinoColors.systemFill,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: FittedBox(fit: BoxFit.scaleDown, child: child),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthPhoneTextField extends StatelessWidget {
  const AuthPhoneTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.enabled,
  });

  final bool? enabled;
  final FocusNode? focusNode;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    final localizations = context.localizations;
    return Column(
      children: [
        CustomListTile(
          height: 30.0,
          title: Text(localizations.phonenumber.capitalize()),
        ),
        CustomTextField(
          enabled: enabled,
          focusNode: focusNode,
          controller: controller,
          keyboardType: TextInputType.phone,
          hintText: localizations.phonenumber,
        ),
      ],
    );
  }
}

class AuthPrivacyInput extends StatelessWidget {
  const AuthPrivacyInput({
    super.key,
    required this.value,
    required this.onChanged,
    this.onTermsofuseTaped,
    this.onPrivacypoliciesTaped,
  });

  final bool value;
  final ValueChanged<bool?>? onChanged;
  final VoidCallback? onTermsofuseTaped;
  final VoidCallback? onPrivacypoliciesTaped;

  @override
  Widget build(BuildContext context) {
    final localizations = context.localizations;
    return ListTile(
      leading: Checkbox(
        value: value,
        onChanged: onChanged,
        activeColor: CupertinoColors.activeGreen,
      ),
      subtitle: Text.rich(
        TextSpan(children: [
          TextSpan(text: '${localizations.acceptthe.capitalize()} '),
          TextSpan(
            text: localizations.termsofuse.capitalize(),
            style: const TextStyle(color: CupertinoColors.activeBlue),
            recognizer: TapGestureRecognizer()..onTap = onTermsofuseTaped,
          ),
          TextSpan(text: ' ${localizations.theuseofpersonalinformation} '),
          TextSpan(
            text: localizations.privacypolicies.capitalize(),
            style: const TextStyle(color: CupertinoColors.activeBlue),
            recognizer: TapGestureRecognizer()..onTap = onPrivacypoliciesTaped,
          ),
        ]),
        overflow: TextOverflow.visible,
        softWrap: true,
      ),
    );
  }
}

class AuthErrorText extends StatelessWidget {
  const AuthErrorText(this.data, {super.key});

  final String data;

  @override
  Widget build(BuildContext context) {
    return ShakeWidget(
      key: UniqueKey(),
      animate: true,
      shakeOffset: 12.0,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Text(
          data,
          style: const TextStyle(color: CupertinoColors.destructiveRed),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class AuthSubmitButton extends StatelessWidget {
  const AuthSubmitButton({
    super.key,
    this.onPressed,
    required this.child,
  });

  final Widget child;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = onPressed != null ? context.theme.primaryColorDark : CupertinoColors.systemGrey6;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: FloatingActionButton(
        backgroundColor: backgroundColor,
        disabledElevation: 0.0,
        onPressed: onPressed,
        elevation: 0.8,
        child: child,
      ),
    );
  }
}
