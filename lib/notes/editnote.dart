// ignore_for_file: sort_child_properties_last

import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_firebase/Components/custombutton.dart';
import 'package:flutter_application_firebase/notes/viewnote.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import '../Components/textformfiled.dart';

class EditNote extends StatefulWidget {
  final String categoryid;
  final String notedocid;
  final String categoryname;
  final String textnote;
  final String imageUrl;
  const EditNote(
      {super.key,
      required this.categoryid,
      required this.categoryname,
      required this.notedocid,
      required this.textnote,
      required this.imageUrl});

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  bool isloading = false;
  bool isImageSelected = false;
  File? file;
  String? url;

  GlobalKey<FormState> formState = GlobalKey<FormState>();
  TextEditingController note = TextEditingController();

  editnote(context) async {
    CollectionReference categories = FirebaseFirestore.instance
        .collection('Categories')
        .doc(widget.categoryid)
        .collection('notes');
    if (formState.currentState!.validate()) {
      try {
        isloading = true;
        await categories
            .doc(widget.notedocid)
            .update({'note': note.text, 'Url_Image': url ?? 'null'});
        //set()تستخدم لحالتي :1-اضافه اذا الديكومينت غير موجود 2-تعديل اذا كان الديكومينت موجود
        //setopection(maegen:true)عشان لما اعدل ماتخدف لي id تبع الديكومينت
        // await categories.doc(widget.categoryid).set({
        //   'name': name.text,
        // }, SetOptions(merge: true));
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => VeiwNote(
                  nameCategory: widget.categoryname,
                  idCategory: widget.categoryid)),
        );
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
      } catch (e) {
        print('Error uploading image: $e');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    note.text = widget.textnote;
    url = widget.imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.categoryname),
        ),
        body: WillPopScope(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Form(
                key: formState,
                child: Column(children: [
                  (url != 'null')
                      ? Stack(
                          children: [
                            CircleAvatar(
                                radius: 70,
                                child: ClipOval(
                                    child: Image.network(
                                  url!,
                                  height: 200,
                                  width: 200,
                                  fit: BoxFit.cover,
                                ))),
                            Positioned(
                                bottom: 1,
                                right: 1,
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  child: IconButton(
                                    onPressed: () {
                                      AwesomeDialog(
                                        context: context,
                                        dialogType: DialogType.info,
                                        animType: AnimType.rightSlide,
                                        title: 'Error',
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
                                    },
                                    icon: const Icon(
                                      Icons.add_a_photo,
                                    ),
                                    color: isImageSelected
                                        ? Colors.green
                                        : const Color.fromARGB(255, 255, 55, 0),
                                  ),
                                  decoration: const BoxDecoration(
                                      color: Color.fromARGB(255, 124, 114, 111),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                )),
                          ],
                        )
                      : Stack(
                          children: [
                            CircleAvatar(
                                radius: 70,
                                child: ClipOval(
                                    child: Image.asset(
                                  'images/user (2).png',
                                  // fit: BoxFit.cover,
                                ))),
                            Positioned(
                                bottom: 1,
                                right: 1,
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  child: IconButton(
                                    onPressed: () {
                                      AwesomeDialog(
                                        context: context,
                                        dialogType: DialogType.info,
                                        animType: AnimType.rightSlide,
                                        title: 'Error',
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
                                    },
                                    icon: Icon(
                                      Icons.add_a_photo,
                                    ),
                                    color: isImageSelected
                                        ? Colors.green
                                        : Color.fromARGB(255, 255, 55, 0),
                                  ),
                                  decoration: const BoxDecoration(
                                      color: Color.fromARGB(255, 124, 114, 111),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                )),
                          ],
                        ),
                  Container(
                    height: 30,
                  ),
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
                      login: 'Save',
                      onPressed: () {
                        editnote(context);
                      })
                ]),
              ),
            ),
            onWillPop: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => VeiwNote(
                      nameCategory: widget.categoryname,
                      idCategory: widget.categoryid)));
              return Future.value(false);
            }));
  }
}
