import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../Auth/Widget/view_profile_picture.dart';


class ImageOptionSheet extends StatelessWidget {
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(16),
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // _mediaOption(0, "Free Text", Icons.messenger_outline_sharp),
            _mediaOption(0, "Camera", Icons.camera_alt),
            _mediaOption(1, "Gallery", Icons.image),
            _mediaOption(2, "View", Icons.person),
          ],
        ),
      ),
    );
  }

  Future<File?> pickImage(ImageSource src) async {
    XFile? pickedFile = await _picker.pickImage(source: src, imageQuality: 70);
    if (pickedFile != null) {
      return File(pickedFile.path);
    } else {
      return null;
    }
  }

  _mediaOption(int index, String title, IconData icon) {
    return ListTile(
      onTap: () async {
        switch (index) {
          case 0:
            {

              File? f = await pickImage(
                ImageSource.camera,
              );
              Get.back(result: f);
            }
            break;
          case 1:
            {

              File? f = await pickImage(
                ImageSource.gallery,
              );
              Get.back(result: f);
            }
            break;

          case 2:
            {
              Get.back();
              Navigator.of(Get.context!).push(MaterialPageRoute(
                builder: (_) => ProfilePreview(),
              ));
            }
            break;
        }
      },
      title: Text(title),
      leading: Icon(icon),
    );
  }
}


