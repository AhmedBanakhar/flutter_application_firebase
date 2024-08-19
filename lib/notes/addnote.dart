import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_firebase/Components/custombutton.dart';
import 'package:flutter_application_firebase/notes/viewnote.dart';
import 'package:image_picker/image_picker.dart';
import '../Components/textformfiled.dart';
import 'package:path/path.dart';

class AddNote extends StatefulWidget {
  final String idcategory;
  final String namecategory;
  const AddNote(
      {super.key, required this.namecategory, required this.idcategory});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  File? file;
  String? url;
  bool isloading = false;
  bool isImageSelected = false;

  GlobalKey<FormState> formState = GlobalKey<FormState>();
  TextEditingController note = TextEditingController();

  addNote(context) async {
    CollectionReference notes = FirebaseFirestore.instance
        .collection('Categories')
        .doc(widget.idcategory)
        .collection('notes');
    if (formState.currentState!.validate()) {
      try {
        isloading = true;
        setState(() {});
        DocumentReference responce =
            await notes.add({'note': note.text, 'Url_Image':url??'null'});
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => VeiwNote(
                nameCategory: widget.namecategory,
                idCategory: widget.idcategory)));
        print(responce);
      } catch (e) {
        isloading = false;
        setState(() {});
        print(e);
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.rightSlide,
          title: 'Error',
          desc: 'There Some thing Error.....!',
          // btnCancelOnPress: () {},
          btnOkOnPress: () {
            // Navigator.of(context).pop();
          },
        ).show();
      }
    }
  }

   getImageCamera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      file = File(image.path);
      var imagename = basename(image.path);
      var refStorage = FirebaseStorage.instance.ref('images/$imagename');
      try {
        await refStorage.putFile(file!);
        url = await refStorage.getDownloadURL();
        setState(() {
          isImageSelected = true;
        });
       
        setState(() {});
      } catch (e) {
        print('Error uploading image: $e');
      }
    }
  }
   getImageGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      file = File(image.path);
      var imagename = basename(image.path);
      var refStorage = FirebaseStorage.instance.ref('images/$imagename');
      try {
        await refStorage.putFile(file!);
        url = await refStorage.getDownloadURL();
        setState(() {
          isImageSelected = true;
        });
       
        setState(() {});
      } catch (e) {
        print('Error uploading image: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.namecategory),
        ),
        body: isloading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
              children: [
                
                Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        
                    child: Form(
                      key: formState,
                      child: Column(children: [
                        CustomTextForm(
                            hinttext: 'Enter The note',
                            mycontroller: note,
                            validator: (val) {
                              if (val == "") {
                                return 'Please Enter The note';
                              }
                              return null;
                            }),
                        const SizedBox(height: 20),
                        CustomButton(
                            login: 'Add',
                            onPressed: () {
                              addNote(context);
                            }),
                            CustomUpload(login: 'Upload Image', onPressed: ()async{
                            AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.info,
                                  animType: AnimType.rightSlide,
                                  title: 'Info',
                                  desc:
                                      'To Upload Image chose one of thim.....!',
                                  btnCancelText: 'Camera',
                                  btnOkText: 'Gallery',
                                  btnCancelOnPress: () {
                                    getImageCamera();
                                  },
                                  btnOkOnPress: () {
                                    getImageGallery();
                                  },
                                ).show();
                            }, isSlected: isImageSelected?true:false)
                      ]),
                    ),
                  ),
              ],
            ));
  }
}
