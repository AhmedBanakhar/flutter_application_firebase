import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_firebase/Auth/addcategore.dart';
import 'package:flutter_application_firebase/Auth/editCategory.dart';
import 'package:flutter_application_firebase/Auth/home.dart';
import 'package:flutter_application_firebase/Auth/login.dart';
import 'package:flutter_application_firebase/Auth/register.dart';
import 'package:flutter_application_firebase/firebase_options.dart';
//import 'package:flutter_application_firebase/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFFAF8260),
              titleTextStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 25),
              iconTheme: IconThemeData(
                color: Colors.white,
              ))),
      debugShowCheckedModeBanner: false,
      home: (FirebaseAuth.instance.currentUser != null)
          ? HomePage()
          : const Login(),
      //اذا كنت تريد تفقيل شرط التحقق من الايميل بعنى لايسجل دخول الا بعد عمليه التحقق من الايميل
      // (FirebaseAuth.instance.currentUser != null &&
      //         FirebaseAuth.instance.currentUser!.emailVerified)
      /////     ? const HomePage()
      //     : const Login(),
      routes: {
        'home': (context) => HomePage(),
        'login': (context) => const Login(),
        'register': (context) => const Register(),
        'categories': (context) => const AddCategories(),
        'editCategories': (context) => const EditCategories(
              categoryid: '',
              categoryname: '',
            )
      },
    );
  }
}
