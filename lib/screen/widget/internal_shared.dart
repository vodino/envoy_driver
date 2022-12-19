import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '_widget.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    this.hintText,
    this.labelText,
    this.maxLines = 1,
    this.minLines,
    this.focusNode,
    this.initalValue,
    this.controller,
    this.enabled,
    this.label,
    this.keyboardType,
    this.expands = false,
    this.readOnly = false,
    this.alignLabelWithHint,
    this.autofocus = false,
    this.textAlign = TextAlign.start,
  });

  final String? initalValue;
  final String? hintText;
  final String? labelText;
  final int? minLines;
  final int? maxLines;
  final bool expands;
  final bool? enabled;
  final bool readOnly;
  final bool autofocus;

  final Widget? label;
  final bool? alignLabelWithHint;

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextAlign textAlign;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12.0),
      decoration: ShapeDecoration(
        color: CupertinoColors.systemFill,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
      child: TextFormField(
        autofocus: autofocus,
        keyboardType: keyboardType,
        textAlign: textAlign,
        enabled: enabled,
        readOnly: readOnly,
        expands: expands,
        minLines: minLines,
        maxLines: maxLines,
        focusNode: focusNode,
        controller: controller,
        initialValue: initalValue,
        decoration: InputDecoration(
          label: label,
          hintText: hintText,
          labelText: labelText,
          alignLabelWithHint: alignLabelWithHint,
          hintStyle: const TextStyle(color: CupertinoColors.tertiaryLabel),
          contentPadding: const EdgeInsets.all(12.0),
        ),
      ),
    );
  }
}

class CustomBar extends StatelessWidget {
  const CustomBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: FractionallySizedBox(
          widthFactor: 0.15,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: const Divider(
              color: CupertinoColors.systemFill,
              thickness: 5.0,
              height: 5.0,
            ),
          ),
        ),
      ),
    );
  }
}

class CustomBoxShadow extends StatelessWidget {
  const CustomBoxShadow({
    super.key,
    required this.child,
    this.shadow = true,
    this.border = true,
    this.color,
  });

  final Widget child;
  final Color? color;
  final bool shadow;
  final bool border;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = context.theme;
    return Container(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
        boxShadow: shadow ? const [BoxShadow(spreadRadius: -14.0, blurRadius: 16.0)] : null,
        border: border ? Border.all(color: CupertinoColors.systemFill) : null,
        borderRadius: BorderRadius.circular(12.0),
        color: color ?? theme.colorScheme.surface,
      ),
      child: child,
    );
  }
}

class CustomOutlineButton extends StatelessWidget {
  const CustomOutlineButton({
    super.key,
    this.onPressed,
    required this.child,
  });

  final Widget child;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        side: const BorderSide(color: CupertinoColors.systemGrey, width: 0.8),
      ),
      child: DefaultTextStyle(
        style: context.cupertinoTheme.textTheme.actionTextStyle,
        child: child,
      ),
    );
  }
}

class CustomLoading extends StatelessWidget {
  const CustomLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const LoadingIndicator(
      colors: [CupertinoColors.systemGrey],
      indicatorType: Indicator.ballClipRotateMultiple,
    );
  }
}

class CustomAudioPlayer extends StatelessWidget {
  const CustomAudioPlayer({
    super.key,
    this.onChanged,
    this.isPlaying = false,
    this.position = Duration.zero,
    this.duration = const Duration(seconds: 30),
  });

  final bool isPlaying;
  final Duration position;
  final Duration duration;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CustomButton(
        onPressed: () => onChanged?.call(!isPlaying),
        child: Material(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
            side: const BorderSide(),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
            child: Row(
              children: [
                Visibility(
                  visible: isPlaying,
                  replacement: const Icon(CupertinoIcons.play_fill),
                  child: const Icon(CupertinoIcons.pause_fill),
                ),
                const SizedBox(width: 12.0),
                Text((position.toString().split('.')[0]).substring(2)),
                const SizedBox(width: 8.0),
                Expanded(
                  child: LinearProgressIndicator(
                    backgroundColor: CupertinoColors.systemFill,
                    value: (position.inSeconds / duration.inSeconds).clamp(0.0, 1.0),
                  ),
                ),
                const SizedBox(width: 8.0),
                Text((duration.toString().split('.')[0]).substring(2)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomSheetButton extends StatelessWidget {
  const CustomSheetButton({
    super.key,
    required this.child,
    required this.onPressed,
  });

  final Widget child;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: CupertinoButton.filled(
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}

class CustomLocationTile extends StatelessWidget {
  const CustomLocationTile({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return CustomListTile(
      leading: const Icon(
        CupertinoIcons.location_solid,
        color: CupertinoColors.systemGrey2,
      ),
      title: Text(
        title,
        style: context.cupertinoTheme.textTheme.textStyle,
      ),
    );
  }
}

class CustomTextFieldModal extends StatefulWidget {
  const CustomTextFieldModal({
    super.key,
    this.value,
    required this.hint,
    required this.title,
  });

  final String hint;
  final String? value;
  final String title;

  @override
  State<CustomTextFieldModal> createState() => _CustomTextFieldModalState();
}

class _CustomTextFieldModalState extends State<CustomTextFieldModal> {
  /// Customer
  late final GlobalKey<FormState> _formKey;

  late final TextEditingController _valueTextController;

  String? _validator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ce champ ne peut être vide';
    }
    return null;
  }

  @override
  void initState() {
    super.initState();

    /// Customer
    _formKey = GlobalKey();
    _valueTextController = TextEditingController(text: widget.value);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(widget.title),
      content: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Form(
          key: _formKey,
          child: Material(
            color: Colors.transparent,
            borderRadius: const BorderRadius.all(Radius.circular(8.0)),
            child: TextFormField(
              autofocus: true,
              validator: _validator,
              controller: _valueTextController,
              decoration: InputDecoration(
                filled: true,
                hintText: widget.hint,
                fillColor: CupertinoColors.systemFill,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
                border: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
              ),
            ),
          ),
        ),
      ),
      actions: [
        CupertinoDialogAction(
          isDestructiveAction: true,
          onPressed: () => Navigator.pop(context),
          child: const Text('Annuler'),
        ),
        CupertinoDialogAction(
          isDefaultAction: true,
          child: const Text('Terminer'),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.pop(context, _valueTextController.text);
            }
          },
        ),
      ],
    );
  }
}

class CustomCheckListTile extends StatelessWidget {
  const CustomCheckListTile({
    super.key,
    this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final Widget? title;
  final Widget? subtitle;

  final bool? value;
  final ValueChanged<bool?>? onChanged;

  void _onTap() {
    if (value != null) {
      onChanged?.call(!(value!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomListTile(
      title: title,
      onTap: _onTap,
      subtitle: subtitle,
      trailing: Checkbox(
        value: value,
        onChanged: onChanged,
        activeColor: CupertinoColors.activeGreen,
        visualDensity: const VisualDensity(
          vertical: VisualDensity.minimumDensity,
          horizontal: VisualDensity.minimumDensity,
        ),
        side: const BorderSide(color: CupertinoColors.systemFill),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      ),
    );
  }
}

class CustomErrorPage extends StatelessWidget {
  const CustomErrorPage({
    super.key,
    required this.onTap,
  });

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: const [
          Text("Une erreur s'est produite"),
          SizedBox(height: 12.0),
          Text("Cliquer ici pour réessayer"),
        ],
      ),
    );
  }
}
