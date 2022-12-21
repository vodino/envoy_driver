import 'dart:io';

import 'package:flutter/material.dart';
import 'package:extended_image/extended_image.dart';
import 'package:image_editor/image_editor.dart';

import '_screen.dart';

class ImageEditorScreen extends StatefulWidget {
  const ImageEditorScreen({
    super.key,
    required this.image,
    required this.title,
  });

  final File image;
  final String title;

  @override
  State<ImageEditorScreen> createState() => _ImageEditorScreenState();
}

class _ImageEditorScreenState extends State<ImageEditorScreen> {
  /// Customer
  late final GlobalKey<ExtendedImageEditorState> _imageEditorKey;

  void _onSwitch() {}
  void _onRotateLeft() {}
  void _onRotateRight() {}
  void _onRefresh() {}

  void _editImage() async {
    final state = _imageEditorKey.currentState!;
    final action = state.editAction!;
    final option = ImageEditorOption();
    if (action.needCrop) option.addOption(ClipOption.fromRect(state.getCropRect()!));
    if (action.hasRotateAngle) option.addOption(RotateOption(action.rotateAngle.toInt()));
    if (action.needFlip) option.addOption(FlipOption(horizontal: action.flipY, vertical: action.flipX));
    final result = await ImageEditor.editImage(imageEditorOption: option, image: state.rawImageData);
    if (mounted) Navigator.pop(context, result);
  }

  @override
  void initState() {
    super.initState();

    /// Customer
    _imageEditorKey = GlobalKey<ExtendedImageEditorState>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ImageEditorAppBar(
        onTrailingPressed: _editImage,
        title: widget.title,
      ),
      body: ExtendedImage.file(
        widget.image,
        cacheRawData: true,
        fit: BoxFit.contain,
        mode: ExtendedImageMode.editor,
        extendedImageEditorKey: _imageEditorKey,
        initEditorConfigHandler: (state) {
          return EditorConfig(
            maxScale: 8.0,
            hitTestSize: 20.0,
            cropRectPadding: const EdgeInsets.all(10.0),
            editorMaskColorHandler: (context, isMasked) {
              return Colors.black.withOpacity(0.8);
            },
          );
        },
      ),
      bottomNavigationBar: ImageEditorBottomAppBar(
        onRotateRight: _onRotateRight,
        onRotateLeft: _onRotateLeft,
        onRefresh: _onRefresh,
        onSwitch: _onSwitch,
      ),
    );
  }
}
