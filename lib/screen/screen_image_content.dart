import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '_screen.dart';

class ImageContentScreen extends StatefulWidget {
  const ImageContentScreen({
    super.key,
    required this.title,
    required this.image,
  });

  final String title;
  final Uint8List image;

  @override
  State<ImageContentScreen> createState() => _ImageContentScreenState();
}

class _ImageContentScreenState extends State<ImageContentScreen> {
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
            return ImageEditorScreen(image: file.path, title: widget.title);
          },
        ),
      );
    }
    return null;
  }

  void _openProfileModal() async {
    final data = await _openAccountPhotoModal();
    if (data != null && mounted) Navigator.pop(context, data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ImageContentAppBar(title: widget.title, onTrailingPressed: _openProfileModal),
      body: InteractiveViewer(child: Center(child: Image(image: MemoryImage(widget.image)))),
    );
  }
}
