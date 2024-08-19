import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_firebase/Components/custombutton.dart';

import '../Components/textformfiled.dart';

class EditCategories extends StatefulWidget {
  final String categoryid;
  final String categoryname;
  const EditCategories(
      {super.key, required this.categoryid, required this.categoryname});

  @override
  State<EditCategories> createState() => _EditCategoriesState();
}

class _EditCategoriesState extends State<EditCategories> {
  bool isloading = false;
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  CollectionReference categories =
      FirebaseFirestore.instance.collection('Categories');
  editcategories() async {
    if (formState.currentState!.validate()) {
      try {
        isloading = true;
        await categories.doc(widget.categoryid).update({
          'name': name.text,
        });
        //set()تستخدم لحالتي :1-اضافه اذا الديكومينت غير موجود 2-تعديل اذا كان الديكومينت موجود
        //setopection(maegen:true)عشان لما اعدل ماتخدف لي id تبع الديكومينت
        // await categories.doc(widget.categoryid).set({
        //   'name': name.text,
        // }, SetOptions(merge: true));
        Navigator.of(context).pushNamedAndRemoveUntil('home', (route) => false);
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
  void initState() {
    super.initState();
    name.text = widget.categoryname;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Edit Category'),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                  login: 'Save',
                  onPressed: () {
                    editcategories();
                  })
            ]),
          ),
        ));
  }
}
