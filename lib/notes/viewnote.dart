import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_firebase/notes/addnote.dart';
import 'package:flutter_application_firebase/notes/editnote.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';

class VeiwNote extends StatefulWidget {
  final String nameCategory;
  final String idCategory;
  const VeiwNote(
      {super.key, required this.nameCategory, required this.idCategory});

  @override
  State<VeiwNote> createState() => _VeiwNoteState();
}

class _VeiwNoteState extends State<VeiwNote> {
  bool isloading = true;
  List<QueryDocumentSnapshot> data = [];
  getData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Categories')
        .doc(widget.idCategory)
        .collection('notes')
        .get();
    data.addAll(querySnapshot.docs);
    isloading = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
            backgroundColor: const Color(0xFFAF8260),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AddNote(
                      idcategory: widget.idCategory,
                      namecategory: widget.nameCategory)));
            },
            child: Icon(Icons.add)),
        appBar: AppBar(
          title: Text(widget.nameCategory),
        ),
        body: WillPopScope(
            child: isloading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : GridView.builder(
                    itemCount: data.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1, mainAxisExtent: 160),
                    itemBuilder: (context, i) {
                      return InkWell(
                          onLongPress: () {
                            AwesomeDialog(
                                context: context,
                                dialogType: DialogType.warning,
                                animType: AnimType.rightSlide,
                                title: 'Waring',
                                desc: 'Chose One.....!',
                                btnCancelText: 'Delete',
                                btnOkText: 'Edit',
                                btnCancelOnPress: () async {
                                  await FirebaseFirestore.instance
                                      .collection('Categories')
                                      .doc(widget.idCategory)
                                      .collection('notes')
                                      .doc(data[i].id)
                                      .delete();
                                  if (data[i]['Url_Image'] != 'null') {
                                    FirebaseStorage.instance
                                        .refFromURL(data[i]['Url_Image'])
                                        .delete();
                                  }
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) => VeiwNote(
                                            nameCategory: widget.nameCategory,
                                            idCategory: widget.idCategory)),
                                  );
                                },
                                btnOkOnPress: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) => EditNote(
                                              categoryid: widget.idCategory,
                                              categoryname: widget.nameCategory,
                                              notedocid: data[i].id,
                                              textnote: data[i]['note'],
                                              imageUrl: data[i]['Url_Image'],
                                            )),
                                  );
                                }).show();
                          },
                          child: Card(
                            color: Colors.grey[200],
                            borderOnForeground: false,
                            clipBehavior: Clip.hardEdge,
                            margin: EdgeInsets.all(10),
                            elevation: 20.0,
                            shadowColor: Colors.grey.withOpacity(0.9),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: BorderSide(color: Colors.grey),
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  if (data[i]['Url_Image'] != 'null')
                                    Flexible(
                                      child: InstaImageViewer(
                                        child: Image.network(
                                          '${data[i]['Url_Image']}',
                                        ),
                                      ),
                                    ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Flexible(
                                    child: Text('${data[i]['note']}',
                                        overflow: TextOverflow.fade),
                                  ),
                                ],
                              ),
                            ),
                          ));
                    }),
            onWillPop: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('home', (route) => false);
              return Future.value(false);
            }));
  }
}
