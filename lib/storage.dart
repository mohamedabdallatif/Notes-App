import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import 'package:firebase_storage/firebase_storage.dart';

class Storage extends StatefulWidget {
  const Storage({super.key});

  @override
  State<Storage> createState() => _StorageState();
}

class _StorageState extends State<Storage> {
  late File file;
  var imagepacker = ImagePicker();
  uploadImage()async{
    var imgpacked =await imagepacker.pickImage(source: ImageSource.camera);
    if(imgpacked!=null){
      file = File(imgpacked.path);
      var imgname = basename(imgpacked.path);
      var random = Random().nextInt(1000000);
      imgname = "$random$imgname";
      var refstorage = FirebaseStorage.instance.ref('images/$imgname');
     await refstorage.putFile(file);
     var url =await refstorage.getDownloadURL();
    }
    else{
      print('please choose image');
    }
  }

  getImagesAndFolderNames()async{
    var ref =await FirebaseStorage.instance.ref().listAll();
    print('files name:\n');
    ref.items.forEach((element) {
      print('================');
      print(element.name);
    });
    print('folders name');
    ref.prefixes.forEach((element) {
      print('================');
      print(element.name);
    });
  }
  @override
  void initState() {
    getImagesAndFolderNames();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Firebase Storage')),
      body:Center(
        child:ElevatedButton(child:const Text('Upload image') ,
        onPressed: ()async{
         await uploadImage();
        },)
         ) ,
    );
  }
}