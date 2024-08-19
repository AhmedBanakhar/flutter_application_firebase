// ignore_for_file: prefer_const_constructors

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_firebase/Auth/editCategory.dart';
import 'package:flutter_application_firebase/Auth/editinfouser.dart';
import 'package:flutter_application_firebase/notes/viewnote.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String imagestorage = '';
  String emailuser = '';
  String imageuser = '';
  String nameuser = '';
  String iduser = '';
  String documentId = '';
  final searchname = TextEditingController();
  bool isloading = true;
  List<QueryDocumentSnapshot> data = [];
  List<QueryDocumentSnapshot> dataUser = [];

  getData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Categories')
        .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    data.addAll(querySnapshot.docs);
    isloading = false;
    setState(() {});
  }

  getDatauser() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
      return {
        'documentId': documentSnapshot.id,
        'data': documentSnapshot.data(),
      };
    } else {
      return null;
    }
  }

  _getinfouser() async {
    final result = await getDatauser();
    if (result != null) {
      setState(() {
        emailuser = result['data']['Email'];
        nameuser = result['data']['User_name'];
        iduser = result['data']['id'];
        imagestorage = result['data']['ImageUrl'];
        documentId = result['documentId'];
      });
    } else {
      print('No user data found');
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
    getDatauser();
    _getinfouser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(
          child: Container(
            color: Colors.grey[20],
            child: ListView(
              children: [
                Column(
                  children: [
                    Container(
                      height: 150,
                      color: const Color(0xFFAF8260),
                      child: Center(
                        child: Column(
                          children: [
                            Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                child: ListTile(
                                  title: Text(
                                    FirebaseAuth.instance.currentUser!.email ??
                                        emailuser,
                                    style: TextStyle(
                                      color: Colors.grey[50],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  leading: (FirebaseAuth
                                              .instance.currentUser!.photoURL !=
                                          null)
                                      ? CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              FirebaseAuth.instance.currentUser!
                                                  .photoURL!),
                                          radius: 30,
                                        )
                                      : (imagestorage == 'none')
                                          ? CircleAvatar(
                                              backgroundImage: AssetImage(
                                                  'images/user (2).png'),
                                              radius: 30,
                                            )
                                          : CircleAvatar(
                                              backgroundImage:
                                                  NetworkImage(imagestorage),
                                              radius: 30,
                                            ),
                                )),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 40)),
                                MaterialButton(
                                  color: Color.fromARGB(255, 243, 233, 229),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      side: BorderSide(color: Colors.black)),
                                  onPressed: () {
                                    if (FirebaseAuth
                                            .instance.currentUser!.photoURL !=
                                        null) {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  EditUserAccount(
                                                    nameuser: nameuser,
                                                    iduser: documentId,
                                                    imagestorage: FirebaseAuth
                                                        .instance
                                                        .currentUser!
                                                        .photoURL!,
                                                  )));
                                    } else {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  EditUserAccount(
                                                    nameuser: nameuser,
                                                    iduser: documentId,
                                                    imagestorage: imagestorage,
                                                  )));
                                    }
                                  },
                                  child: Container(
                                    child: Text(
                                      " Mange Account",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                ListTile(
                  leading: const Icon(
                    Icons.home,
                    size: 40,
                    color: Colors.black,
                  ),
                  title: const Text(
                    "Home",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('home', (route) => false);
                  },
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
            backgroundColor: const Color(0xFFAF8260),
            onPressed: () {
              Navigator.of(context).pushNamed('categories');
            },
            child: Icon(Icons.add)),
        appBar: AppBar(
          title: const Text('Home Page'),
          //  backgroundColor: const Color.fromARGB(255, 255, 55, 0),
          actions: [
            IconButton(
              onPressed: () async {
                GoogleSignIn googleSignIn = GoogleSignIn();
                await googleSignIn.signOut();
                await FirebaseAuth.instance.signOut();
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('login', (route) => false);
              },
              icon: const Icon(Icons.exit_to_app),
            ),
          ],
        ),
        body: isloading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 15.0),
                    child: TextFormField(
                      controller: searchname,
                      decoration: InputDecoration(
                        labelText: 'Search',
                        labelStyle: TextStyle(
                          color: Color.fromARGB(255, 109, 77, 52),
                        ),
                        suffixIcon: Icon(Icons.search),
                        suffixIconColor: Color(0xFFAF8260),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFFAF8260),
                            ),
                            borderRadius: BorderRadius.circular(20)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(color: Colors.grey)),
                      ),
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                  ),
                  Expanded(
                    child: GridView.builder(
                        itemCount: data.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2, mainAxisExtent: 200),
                        itemBuilder: (context, i) {
                          final name = data[i]['name'].toString();
                          if (searchname.text.isEmpty) {
                            return InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => VeiwNote(
                                        nameCategory: data[i]['name'],
                                        idCategory: data[i].id)));
                              },
                              onLongPress: () {
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.warning,
                                  animType: AnimType.rightSlide,
                                  title: 'Waring',
                                  desc: 'Chose One of this....!',
                                  btnCancelText: 'Delete',
                                  btnOkText: 'Edit',
                                  btnCancelOnPress: () async {
                                    await FirebaseFirestore.instance
                                        .collection('Categories')
                                        .doc(data[i].id)
                                        .delete();
                                    Navigator.of(context)
                                        .pushNamedAndRemoveUntil(
                                            'home', (route) => false);
                                  },
                                  btnOkOnPress: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                EditCategories(
                                                    categoryid: data[i].id,
                                                    categoryname: data[i]
                                                        ['name'])));
                                  },
                                ).show();
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25, vertical: 25),
                                child: Card(
                                    child: Column(children: [
                                  Image.asset(
                                    'images/file2.jpg',
                                    height: 100,
                                  ),
                                  Text('${data[i]['name']}'),
                                ])),
                              ),
                            );
                          } else if (name
                              .toLowerCase()
                              .contains(searchname.text.toLowerCase())) {
                            return InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => VeiwNote(
                                        nameCategory: data[i]['name'],
                                        idCategory: data[i].id)));
                              },
                              onLongPress: () {
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.warning,
                                  animType: AnimType.rightSlide,
                                  title: 'Waring',
                                  desc: 'Chose One of this....!',
                                  btnCancelText: 'Delete',
                                  btnOkText: 'Edit',
                                  btnCancelOnPress: () async {
                                    await FirebaseFirestore.instance
                                        .collection('Categories')
                                        .doc(data[i].id)
                                        .delete();
                                    Navigator.of(context)
                                        .pushNamedAndRemoveUntil(
                                            'home', (route) => false);
                                  },
                                  btnOkOnPress: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                EditCategories(
                                                    categoryid: data[i].id,
                                                    categoryname: data[i]
                                                        ['name'])));
                                  },
                                ).show();
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25, vertical: 25),
                                child: Card(
                                    child: Column(children: [
                                  Image.asset(
                                    'images/folder.png',
                                    height: 100,
                                  ),
                                  Text('${data[i]['name']}'),
                                ])),
                              ),
                            );
                          } else {
                            return Container();
                          }
                        }),
                  )
                ],
              ));
  }
}
