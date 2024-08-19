// ignore_for_file: sort_child_properties_last

import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_firebase/Components/custombutton.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class EditUserAccount extends StatefulWidget {
  final String nameuser;
  final String iduser;
  final String imagestorage;

  const EditUserAccount({
    super.key,
    required this.nameuser,
    required this.iduser,
    required this.imagestorage,
  });

  @override
  State<EditUserAccount> createState() => _EditUserAccountState();
}

class _EditUserAccountState extends State<EditUserAccount> {
  File? file;
  String? imageurl;
  bool isloading = false;
  bool isImageSelected = false;
  bool isLoading = true;

  GlobalKey<FormState> formState = GlobalKey<FormState>();
  TextEditingController userpassword = TextEditingController();

  editUser(context) async {
    print('editUser method called');
    CollectionReference user = FirebaseFirestore.instance.collection('Users');
    if (formState.currentState!.validate()) {
      try {
        isloading = true;
        print('Updating document...');
        await user.doc(widget.iduser).update({'ImageUrl': imageurl});
        print('Document updated successfully');
        Navigator.of(context).pushNamedAndRemoveUntil('home', (route) => false);
        isImageSelected = false;
        setState(() {});
      } catch (e) {
        print(widget.iduser);
        print('Error updating document: $e');
        isloading = false;
        setState(() {});
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.rightSlide,
          title: 'Error',
          desc: 'There was an error updating your profile.',
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
        imageurl = await refStorage.getDownloadURL();
        setState(() {
          isImageSelected = true;
        });
        isLoading = false;
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
        imageurl = await refStorage.getDownloadURL();
        setState(() {
          isImageSelected = true;
        });
        isLoading = false;
        setState(() {});
      } catch (e) {
        print('Error uploading image: $e');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    imageurl = widget.imagestorage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.nameuser}'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 120, vertical: 50),
        child: Column(
          children: [
            (imageurl != 'none')
                ? Stack(
                    children: [
                      CircleAvatar(
                          radius: 70,
                          child: ClipOval(
                              child: Image.network(
                            imageurl!,
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                          )),
                    ],
                  ),
            const SizedBox(height: 20),
            Form(
              key: formState,
              child: Column(children: [
                // CustomUpload(
                //   login: 'UpLoad image',
                //   onPressed: () {
                //     getImageCamera();
                //   },
                //   isSlected: isImageSelected,
                // ),
                const SizedBox(height: 20),
                CustomButton(
                    login: 'Save',
                    onPressed: () {
                      editUser(context);
                      setState(() {
                        isImageSelected = false;
                      });
                    }),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
