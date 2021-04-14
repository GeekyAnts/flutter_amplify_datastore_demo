import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_amplify_demo/stores/user.dart';
import 'package:flutter_amplify_demo/theme/colors.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerButton extends StatefulWidget {
  ImagePickerButton({Key key}) : super(key: key);

  @override
  _ImagePickerButtonState createState() => _ImagePickerButtonState();
}

class _ImagePickerButtonState extends State<ImagePickerButton> {
  final picker = ImagePicker();
  File _image;

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    _image = File(pickedFile.path);
    final key = new DateTime.now().toString();
    // await UserStore().updateProfileImage(image: _image, key: key);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: IconButton(
        onPressed: () {
          getImage();
        },
        icon: Icon(
          Icons.qr_code,
          color: primary,
          size: 20,
        ),
      ),
    );
  }
}
