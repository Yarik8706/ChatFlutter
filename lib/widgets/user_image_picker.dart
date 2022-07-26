import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  UserImagePicker(this.saveData);

  final void Function(String) saveData;

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {

  File _pickedImageFile = File('');
  String _imageData = '';

  void _pickImage() async {
    bool? result = await showDialog<bool>(
        context: context,
        builder: (dialogContext) =>
            AlertDialog(
              title: Text('Добавления фотографии'),
              content: Text("Как добавить фотографию?"),
              actions: [
                Row(
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(dialogContext, true);
                        },
                        child: Text('Из галереи')
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(dialogContext, false);
                        },
                        child: Text('Сделать фотографию')
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(dialogContext);
                        },
                        child: Text('Отмена')
                    ),
                  ],
                ),
              ],
            ),
        barrierDismissible: true
    );

    if(result == null) return;
    ImageSource pickImageType;
    if(result) {
      pickImageType = ImageSource.gallery;
    } else {
      pickImageType = ImageSource.camera;
    }

    final imageFile = await ImagePicker().pickImage(source: pickImageType);
    if(imageFile != null) {
      setState(() {
        _pickedImageFile = File(imageFile.path);
      });
    }
    List<int> imageBytes = _pickedImageFile.readAsBytesSync();
    _imageData = base64Encode(imageBytes);
    widget.saveData(_imageData);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          key: ValueKey('image'),
          radius: 50,
          backgroundColor: Theme.of(context).primaryColor,
          backgroundImage: _pickedImageFile.path == '' ? null : FileImage(_pickedImageFile),
        ),
        TextButton.icon(
          onPressed: _pickImage,
          icon: Icon(Icons.image),
          label: Text('Добавить фотографию'),
        ),
      ],
    );
  }
}
