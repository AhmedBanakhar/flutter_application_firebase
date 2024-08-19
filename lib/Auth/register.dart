import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_firebase/Components/logoauth.dart';
import 'package:flutter_application_firebase/Components/custombutton.dart';
import 'package:flutter_application_firebase/Components/textformfiled.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController username = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  CollectionReference addUser = FirebaseFirestore.instance.collection('Users');
  addUsers() async {
    String hashedPassword =
        sha256.convert(utf8.encode(password.text)).toString();

    DocumentReference responce = await addUser.add({
      'id': FirebaseAuth.instance.currentUser!.uid,
      'User_name': username.text,
      'Email': email.text,
      'Password': hashedPassword,
      'ImageUrl':'none'
      
      
    });

    print(responce);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 55, 0),
        title: const Text('SignUp'),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: ListView(children: [
          Form(
            key: formState,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 70,
                ),
                const LogoAuth(),
                Container(
                  height: 20,
                ),
                const Text(
                  'SignUp',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                Container(
                  height: 10,
                ),
                const Text(
                  'Login To Continue Using The App',
                  style: TextStyle(color: Colors.grey),
                ),
                Container(
                  height: 20,
                ),
                const Text(
                  'UserName',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Container(
                  height: 10,
                ),
                CustomTextForm(
                    hinttext: 'Enter Your Username',
                    mycontroller: username,
                    validator: (val) {
                      if (val == '') {
                        return 'Username is required';
                      }
                      return null;
                    }),
                Container(
                  height: 20,
                ),
                const Text(
                  'Email',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Container(
                  height: 10,
                ),
                CustomTextForm(
                    hinttext: 'Enter Your Email',
                    mycontroller: email,
                    validator: (val) {
                      if (val == '') {
                        return 'Email is required';
                      }
                      return null;
                    }),
                Container(
                  height: 10,
                ),
                const Text(
                  'Password',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Container(
                  height: 10,
                ),
                CustomTextForm(
                    hinttext: 'Enter Your Password',
                    mycontroller: password,
                    validator: (val) {
                      if (val == '') {
                        return 'Password is required';
                      }
                      return null;
                    }),
                Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 20),
                  alignment: Alignment.topRight,
                  child: const Text(
                    'Forgot Password ?',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
          CustomButton(
              login: 'SignUp',
              onPressed: () async {
                try {
                  await FirebaseAuth.instance.createUserWithEmailAndPassword(
                    email: email.text,
                    password: password.text,
                  );
                  addUsers();
                  Navigator.of(context).pushReplacementNamed('login');
                  setState(() {});
                  //بعد عمليه انشاء الحساب يتم ارسال رابط لتتحق من الايميل وبعده ينقلخ لصفحه تسجيل الدخول
                  // FirebaseAuth.instance.currentUser!.sendEmailVerification();
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'weak-password') {
                    print('The password provided is too weak.');
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.error,
                      animType: AnimType.rightSlide,
                      title: 'Error',
                      desc: 'The password provided is too weak.',
                      btnOkOnPress: () {},
                    ).show();
                  } else if (e.code == 'email-already-in-use') {
                    print('The account already exists for that email.');
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.error,
                      animType: AnimType.rightSlide,
                      title: 'Error',
                      desc: 'The account already exists for that email.',
                      btnOkOnPress: () {},
                    ).show();
                  }
                } catch (e) {
                  print(e);
                }
              }),
          Container(
            height: 20,
          ),
          Container(
            height: 20,
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).pushReplacementNamed('login');
            },
            child: const Center(
              child: Text.rich(TextSpan(children: [
                TextSpan(text: ' have an account? '),
                TextSpan(
                    text: 'Login ',
                    style: TextStyle(
                        color: Color.fromARGB(255, 255, 0, 0),
                        fontWeight: FontWeight.bold))
              ])),
            ),
          )
        ]),
      ),
    );
  }
}
