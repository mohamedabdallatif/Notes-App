import 'dart:io';
import 'dart:math';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/componats/alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditNotes extends StatefulWidget {
  const EditNotes({super.key,required this.docid,required this.list});
  final docid;
  final list;
  @override
  State<EditNotes> createState() => _EditNotesState();
}

var title, note, imageUrl;
 File? file;
late Reference ref;
CollectionReference notesref = FirebaseFirestore.instance.collection('notes');

class _EditNotesState extends State<EditNotes> {
GlobalKey<FormState> formState = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    addNotes()async{
        var formData = formState.currentState;
      if(file==null){
         if(formData!.validate()){
    showLoading(context);
    formData.save();
   await notesref.doc(widget.docid).update({
    'title' : title,
    'note' : note,
    }).then((value) =>     Navigator.of(context).pushNamed('homepage')
).catchError((e){print('$e');});
  }
      }
      else{
         if(formData!.validate()){
    showLoading(context);
    formData.save();
    await ref.putFile(file!);
    imageUrl = await ref.getDownloadURL();
   await notesref.doc(widget.docid).update({
    'title' : title,
    'note' : note,
    'imageurl' : imageUrl,
    }).then((value) =>     Navigator.of(context).pushNamed('homepage')
).catchError((e){print('$e');});
  }
      }
 
}
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit notes'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Form(
              key: formState,
              child: Column(
                children: [
                  TextFormField(
                    initialValue: '${widget.list['title']}',
                    onSaved: (newValue) {
                      title = newValue;
                    },
                    maxLength: 30,
                    decoration: const InputDecoration(
                      label: Text('Title'),
                      prefixIcon: Icon(Icons.title),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (value) {
                            if (value!.length > 30) {
                              return 'Title can\'t be greater than 30';
                            }
                            if (value.length < 2) {
                              return 'Title can\'t be lesser than 2';
                            }
                            return null;
                          },
                  ),
                  TextFormField(
                    initialValue: '${widget.list['note']}',
                    onSaved: (newValue) {
                      note = newValue;
                    },
                    maxLines: 3,
                    minLines: 1,
                    maxLength: 200,
                    decoration: const InputDecoration(
                      label: Text('Note'),
                      prefixIcon: Icon(Icons.note),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (value) {
                            if (value!.length > 200) {
                              return 'note can\'t be greater than 200';
                            }
                            if (value.length < 2) {
                              return 'note can\'t be lesser than 2';
                            }
                            return null;
                          },
                  ),
                ],
              ),
            ),
            ElevatedButton(onPressed: ()async {
             await addNotes();
            }, child: const Text('Edit Note')),
            ElevatedButton(
                onPressed: () {
                  showBottomSheet(context);
                },
                child: const Text('Edit image of note'))
          ],
        ),
      ),
    );
  }
}

showBottomSheet(context) {
  return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20.0),
          height: 170,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Please choose Image',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              InkWell(
                onTap: () async {
                  var picked = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);
                  if (picked != null) {
                    file = File(picked.path);
                    var rand = Random().nextInt(1000000);
                    var nameimage = "$rand${basename(picked.path)}";
                     ref =
                        FirebaseStorage.instance.ref('images').child(nameimage);
                        Navigator.of(context).pop();
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  width: double.infinity,
                  child: Row(
                    children: const [
                      Icon(
                        Icons.photo_outlined,
                        size: 30,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text('From Gallary')
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                    var picked = await ImagePicker()
                        .pickImage(source: ImageSource.camera);
                    if (picked != null) {
                      file = File(picked.path);
                      var rand = Random().nextInt(1000000);
                      var nameimage = "$rand${basename(picked.path)}";
                       ref = FirebaseStorage.instance
                          .ref('images')
                          .child(nameimage);
                          Navigator.of(context).pop();
                    }
                  
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  width: double.infinity,
                  child: Row(
                    children: const [
                      Icon(
                        Icons.camera,
                        size: 30,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text('From Camera')
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      });
}
