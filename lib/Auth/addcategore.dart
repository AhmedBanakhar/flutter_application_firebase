import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_firebase/Components/custombutton.dart';

import '../Components/textformfiled.dart';

class AddCategories extends StatefulWidget {
  const AddCategories({super.key});

  @override
  State<AddCategories> createState() => _AddCategoriesState();
}

class _AddCategoriesState extends State<AddCategories> {
  bool isloading = false;
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  CollectionReference categories =
      FirebaseFirestore.instance.collection('Categories');
  addCategories() async {
    if (formState.currentState!.validate()) {
      try {
        isloading = true;
        setState(() {});
        DocumentReference responce = await categories.add(
            {'name': name.text, 'id': FirebaseAuth.instance.currentUser!.uid});
        Navigator.of(context).pushNamedAndRemoveUntil('home', (route) => false);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add Categories'),
        ),
        body: isloading
            ?  Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Form(
                  key: formState,
                  child: Column(children: [
                    CustomTextForm(
                        hinttext: 'Enter The name',
                        mycontroller: name,
                        validator: (val) {
                          if (val == "") {
                            return 'Please Enter The name';
                          }
                          return null;
                        }),
                    const SizedBox(height: 20),
                    CustomButton(
                        login: 'Add',
                        onPressed: () {
                          addCategories();
                        })
                  ]),
                ),
              ));
  }
}
