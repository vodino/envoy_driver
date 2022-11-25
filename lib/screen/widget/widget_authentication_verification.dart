import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';

import '_widget.dart';

class AuthVerificationAppBar extends DefaultAppBar {
  const AuthVerificationAppBar({super.key});
  @override
  Widget build(BuildContext context) {
    return const CupertinoNavigationBar(
      middle: Text('Verification'),
      border: Border.fromBorderSide(BorderSide.none),
    );
  }
}

class AuthVerificationTitle extends StatelessWidget {
  const AuthVerificationTitle({
    super.key,
    required this.phoneNumber,
  });

  final String phoneNumber;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: IntrinsicWidth(
        child: CustomListTile(
          title: Text.rich(
            TextSpan(
              text: 'Entrez le code réçu au numéro de téléphone\n',
              children: [
                TextSpan(
                  text: phoneNumber,
                  style: TextStyle(
                    color: context.theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const TextSpan(text: '.'),
              ],
            ),
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
      ),
    );
  }
}

class AuthVerificationFields extends StatelessWidget {
  const AuthVerificationFields({
    super.key,
    this.onCompleted,
    this.controller,
    this.focusNode,
  });

  final FocusNode? focusNode;
  final TextEditingController? controller;
  final ValueChanged<String?>? onCompleted;

  @override
  Widget build(BuildContext context) {
    final BorderRadius borderRadius = BorderRadius.circular(8.0);
    final PinTheme defaultPinTheme = PinTheme(
      width: 56,
      height: 60,
      textStyle: context.cupertinoTheme.textTheme.navTitleTextStyle,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        color: CupertinoColors.systemFill,
        border: Border.all(color: Colors.transparent),
      ),
    );
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Pinput(
          length: 6,
          autofocus: true,
          focusNode: focusNode,
          controller: controller,
          onCompleted: onCompleted,
          defaultPinTheme: defaultPinTheme,
          keyboardType: TextInputType.number,
          focusedPinTheme: defaultPinTheme.copyWith(
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              border: Border.all(color: CupertinoColors.systemGrey2),
            ),
          ),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
          ],
        ),
      ),
    );
  }
}

class AuthVerificationTextField extends StatelessWidget {
  const AuthVerificationTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      stepWidth: 80.0,
      child: CustomBoxShadow(
        color: CupertinoColors.systemGrey5,
        child: TextFormField(
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            LengthLimitingTextInputFormatter(1),
          ],
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          style: context.theme.textTheme.headline5,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.all(16.0),
          ),
        ),
      ),
    );
  }
}
