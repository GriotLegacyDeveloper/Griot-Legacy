import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:griot_legacy_social_media_app/src/widgets/image_picker_diaolg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'dart:async';

class ImagePickerHandler {
  ImagePickerDialog imagePickerDialog;
  AnimationController controller;
  ImagePickerListener listener;
  String comeFrom;

  ImagePickerHandler(this.listener, this.controller,this.comeFrom);

  openCamera() async {
    final picker = ImagePicker();

    imagePickerDialog.dismissDialog();
    //final pickedFile = ImagePicker(source: ImageSource.gallery);

    var image = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 50,
        maxHeight: 1200,
        maxWidth: 1200);
    listener.userImage(image);

  }

  openGalleryForProfile() async {
    final picker = ImagePicker();

    imagePickerDialog.dismissDialog();
    //final pickedFile = ImagePicker(source: ImageSource.gallery);

    var image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxHeight: 1200,
        maxWidth: 1200);
    listener.userImage(image);

  }

  List<File> imagesList = <File>[];

/*
  Future<XFile> getImageFileFromAssets(Asset asset) async {
    final byteData = await asset.getByteData();

    final tempFile = XFile("${(await getTemporaryDirectory()).path}/${asset.name}");
    final file = await tempFile.writeAsBytes(
      byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes),
    );
    return file;
  }
*/

  openGallery() async {
    imagePickerDialog.dismissDialog();
    loadAssets();
  }

  openGalleryForVideo() async {
    final picker = ImagePicker();

    imagePickerDialog.dismissDialog();
    var video = await picker.pickVideo(source: ImageSource.gallery);
   // print("video.......   $video");
    final filePath = await FlutterAbsolutePath.getAbsolutePath(video.path);

    File tempFile = File(filePath);
   // print("tempFile...    $tempFile");


    listener.userVideo(tempFile);
  }

  List<Asset> images = <Asset>[];

  Future<void> loadAssets() async {
    List<Asset> resultList = <Asset>[];
    //  String error = 'No Error Detected';
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: const CupertinoOptions(
          takePhotoIcon: "chat",
          doneButtonTitle: "Selected",
        ),
        materialOptions: const MaterialOptions(
          actionBarColor: "#000000",
          actionBarTitle: "Example App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      //error = e.toString();
      //  print("error..... $e");
    }
    //  print("images..... ${images.length}");

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    images = resultList;
    images.forEach((imageAsset) async {
      final filePath =
          await FlutterAbsolutePath.getAbsolutePath(imageAsset.identifier);

      File tempFile = File(filePath);
      File compressedFile = await FlutterNativeImage.compressImage(
        tempFile.path,
        quality: 50,
      );
      //compressFile(tempFile);
      //compressImage(tempFile);
      imagesList.add(compressedFile);
      listener.userImageForGallery(imagesList);
      // print("imagesList    ${imagesList.length}");
      /* if (tempFile.existsSync()) {
        imagesList.add(tempFile);
      }*/
    });
    //return imagesList;
    //images = resultList;
  }

/*  void compressImage(tempFile) async {
   // File imageFile = await ImagePicker.pickImage();
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    int rand =  Math.Random().nextInt(10000);

    Im.Image image = Im.decodeImage(tempFile.readAsBytesSync());
    Im.Image smallerImage = Im.copyResize(image, 500); // choose the size here, it will maintain aspect ratio

    var compressedImage =
    File('$path/img_$rand.jpg')..writeAsBytesSync(Im.encodeJpg(image, quality: 85));
  }*/

  void init() {
    imagePickerDialog = ImagePickerDialog(this, controller,comeFrom);
    imagePickerDialog.initState();
  }

  showDialog(BuildContext context) {
    imagePickerDialog.getImage(context);
  }
}

abstract class ImagePickerListener {
  userImage(XFile _image);
  userImageForGallery(List<File> _image);
  userVideo(File _image);
}
