import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_firebase/Components/logoauth.dart';
import 'package:flutter_application_firebase/Components/custombutton.dart';
import 'package:flutter_application_firebase/Components/textformfiled.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isloading = false;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey<FormState>();

  Future signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      return;
    }

    // Obtain the auth details from the request

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(credential);
    Navigator.of(context).pushReplacementNamed('home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: const Color.fromARGB(255, 255, 55, 0),
        title: const Text(
          'Login',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: isloading
          ?  Center(
              child: CircularProgressIndicator(),
            )
          : Container(
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
                        'Login',
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      Container(
                        height: 10,
                      ),
                      const Text(
                        'Login To Continue Using The App',
                        style: TextStyle(color: Color.fromARGB(255, 111, 109, 109)),
                      ),
                      Container(
                        height: 20,
                      ),
                      const Text(
                        'Email',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Container(
                        height: 10,
                      ),
                      CustomTextForm(
                          hinttext: 'Enter Your Email',
                          mycontroller: email,
                          validator: (val) {
                            if (val == '') {
                              return 'Emai is required';
                            }
                            return null;
                          }),
                      Container(
                        height: 10,
                      ),
                      const Text(
                        'Password',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
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
                        },
                      ),
                      InkWell(
                        onTap: () async {
                          if (email.text == "") {
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.error,
                              animType: AnimType.rightSlide,
                              title: 'Error',
                              desc: 'The Email Can not Be Empty.....!',
                              // btnCancelOnPress: () {},
                              btnOkOnPress: () {
                                // Navigator.of(context).pop();
                              },
                            ).show();
                          }
                          try {
                            await FirebaseAuth.instance
                                .sendPasswordResetEmail(email: email.text);
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.info,
                              animType: AnimType.rightSlide,
                              title: 'Info',
                              desc:
                                  'Verified your email we send alink to reset the password.....!',
                              // btnCancelOnPress: () {},
                              btnOkOnPress: () {
                                // Navigator.of(context).pop();
                              },
                            ).show();
                          } catch (e) {
                            print(e);
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.only(top: 10, bottom: 20),
                          alignment: Alignment.topRight,
                          child: const Text(
                            'Forgot Password ?',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                CustomButton(
                  login: 'Login',
                  onPressed: () async {
                    if (formState.currentState!.validate()) {
                      try {
                        isloading = true;
                        setState(() {});
                        final credential = await FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                                email: email.text, password: password.text);
                        Navigator.of(context).pushReplacementNamed('home');

                        //اذا كنت تريد التحقق من الايميل عبر ارسال رابط الى الربيد لتحقق منه
                        // if (credential.user!.emailVerified) {
                        //   Navigator.of(context).pushReplacementNamed('home');
                        // } else {
                        //   AwesomeDialog(
                        //     context: context,
                        //     dialogType: DialogType.info,
                        //     animType: AnimType.rightSlide,
                        //     title: 'Error',
                        //     desc: 'Verified your email.....!',
                        //     // btnCancelOnPress: () {},
                        //     btnOkOnPress: () {
                        //       // Navigator.of(context).pop();
                        //     },
                        //   ).show();
                        // }
                      } on FirebaseAuthException catch (e) {
                        isloading = false;
                        setState(() {});
                        if (e.code == 'user-not-found') {
                          print('No user found for that email.');
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.error,
                            animType: AnimType.rightSlide,
                            title: 'Error',
                            desc: 'No user found for that email.',
                            // btnCancelOnPress: () {},
                            btnOkOnPress: () {
                              // Navigator.of(context).pop();
                            },
                          ).show();
                        } else if (e.code == 'wrong-password') {
                          print('Wrong password provided for that user.');
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.error,
                            animType: AnimType.rightSlide,
                            title: 'Error',
                            desc: 'Wrong password provided for that user.',
                            // btnCancelOnPress: () {},
                            btnOkOnPress: () {},
                          ).show();
                        }
                      }
                    } else {
                      print('================================');
                    }
                  },
                ),
                Container(
                  height: 20,
                ),
                const Text(
                  'OR Login',
                  textAlign: TextAlign.center,
                ),
                Container(
                  height: 20,
                ),
                MaterialButton(
                  height: 40,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                  color: const Color(0xFFE4C59E),
                  onPressed: () {
                    signInWithGoogle();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Login With Goole  ',
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                      Image.asset(
                        'images/Google-Logo.png',
                        width: 30,
                        height: 30,
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed('register');
                  },
                  child: const Center(
                    child: Text.rich(TextSpan(children: [
                      TextSpan(text: 'Don\'t have an account? '),
                      TextSpan(
                          text: 'Register ',
                          style: TextStyle(
                              color: Color(0xFFE4C59E),
                              fontWeight: FontWeight.bold))
                    ])),
                  ),
                )
              ]),
            ),
    );
  }
}
