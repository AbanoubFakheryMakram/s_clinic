import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

// ! libs
// ? 1- image_picker:
// ? 2- flutter_image_compress:

class ImageProcessing {
  // pick image depend on the source
  static Future<File> getImage(ImageSource source) async {
    File file = await ImagePicker.pickImage(source: source);
    return file;
  }

  // // compress asset and get list<int>
  // static Future<List<int>> compressImageAsset(String assetName) async {
  //   var list = await FlutterImageCompress.compressAssetImage(
  //     assetName,
  //     minHeight: 1920,
  //     minWidth: 1080,
  //     quality: 96,
  //     rotate: 180,
  //   );

  //   return list;
  // }

  // // compress file and get file.
  // static Future<File> compressImageAndGetFile(
  //     File file, String targetPath) async {
  //   var result = await FlutterImageCompress.compressAndGetFile(
  //     file.absolute.path,
  //     targetPath,
  //     quality: 88,
  //     rotate: 180,
  //   );

  //   print(file.lengthSync());
  //   print(result.lengthSync());

  //   return result;
  // }

  static Future<String> getImageUrlFromFirbaseStorage(
    FirebaseStorage storage,
  ) async {
    String url;
    try {
      url = await storage.ref().getDownloadURL();
    } catch (e) {
      print('can not download image url: ${e.toString()}');
      url = null;
    }

    return url;
  }
}
