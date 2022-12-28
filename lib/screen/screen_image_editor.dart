import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_editor/image_editor.dart';
import 'package:extended_image/extended_image.dart';

import '_screen.dart';

class ImageEditorScreen extends StatefulWidget {
  const ImageEditorScreen({
    super.key,
    required this.image,
    required this.title,
    this.shape = BoxShape.circle,
  });

  final String image;
  final String title;
  final BoxShape shape;

  @override
  State<ImageEditorScreen> createState() => _ImageEditorScreenState();
}

class _ImageEditorScreenState extends State<ImageEditorScreen> {
  /// Customer
  late final GlobalKey<ExtendedImageEditorState> _imageEditorKey;

  void _onFlip() {
    _imageEditorKey.currentState!.flip();
  }

  void _onRotateLeft() {
    _imageEditorKey.currentState!.rotate(right: false);
  }

  void _onRotateRight() {
    _imageEditorKey.currentState!.rotate(right: true);
  }

  void _onRefresh() {
    _imageEditorKey.currentState!.reset();
  }

  void _editImage() async {
    final state = _imageEditorKey.currentState!;
    final action = state.editAction!;
    final option = ImageEditorOption();
    if (action.needCrop) option.addOption(ClipOption.fromRect(state.getCropRect()!));
    if (action.hasRotateAngle) option.addOption(RotateOption(action.rotateAngle.toInt()));
    if (action.needFlip) option.addOption(FlipOption(horizontal: action.flipY, vertical: action.flipX));
    option.outputFormat = const OutputFormat.png(88);
    final result = await ImageEditor.editImage(imageEditorOption: option, image: state.rawImageData);
    if (result != null && mounted) Navigator.pop(context, result);
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
        File(widget.image),
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
        onFlip: _onFlip,
      ),
    );
  }
}
