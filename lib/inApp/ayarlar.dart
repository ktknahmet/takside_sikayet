import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taksiapp/models/auth_model.dart';
import 'package:taksiapp/models/colors.dart';
import 'package:taksiapp/models/database_model.dart';
import 'package:taksiapp/screen/acilisekrani.dart';
import 'package:taksiapp/screen/anket.dart';

class Ayarlar extends StatefulWidget {
  const Ayarlar({Key? key}) : super(key: key);

  @override
  _AyarlarState createState() => _AyarlarState();
}

class _AyarlarState extends State<Ayarlar> {
  AuthModel auth = AuthModel();
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  DatabaseModel databaseModel = DatabaseModel();
  var tftavsiye = TextEditingController();
  var tfsifreyenile = TextEditingController();
  double genislik = 0;
  double yukseklik = 0;
  File? file;
  UploadTask? uploadTask;
  String? resimadi;
  String? cekgonderUrl;
  String? mail;
  String? method;

  @override
  void initState() {
    kullaniciAl();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var ekranBilgisi = MediaQuery.of(context);
    genislik = ekranBilgisi.size.width;
    yukseklik = ekranBilgisi.size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            infoMail(),
            const SizedBox(
              height: 50,
            ),
            row1(),
            const SizedBox(
              height: 20,
            ),
            row2(),
          ],
        ),
      ),
    );
  }

  Align infoMail() {
    return Align(
      alignment: Alignment.center,
      child: Container(
          width: genislik / 1.5,
          height: yukseklik / 13,
          decoration: BoxDecoration(
            border: Border.all(
              width: 2,
              color: MyColors().sarirenk,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.markunread_outlined,
                  ),
                  Text(
                    "Bize Bildirin",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const Text(
                "info@taksidesikayet.com",
                style: TextStyle(color: Colors.lightBlueAccent),
              ),
            ],
          )),
    );
  }

  Padding row1() {
    return Padding(
      padding: const EdgeInsets.only(left: 40, right: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: hesapBilgilerim,
            child: Container(
              width: genislik / 3,
              height: yukseklik / 6.5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: const Color.fromRGBO(242, 233, 173, 1),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "Hesap\nBilgilerim",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Icon(
                    Icons.person,
                    color: Colors.black,
                  )
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const AnketScreen()));
            },
            child: Container(
              width: genislik / 3,
              height: yukseklik / 6.5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: const Color.fromRGBO(242, 233, 124, 1),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "Anketlerimiz",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Icon(
                    Icons.event_note_outlined,
                    color: Colors.black,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding row2() {
    return Padding(
      padding: const EdgeInsets.only(left: 40, right: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: cekgonder,
            child: Container(
              width: genislik / 3,
              height: yukseklik / 6.5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: const Color.fromRGBO(242, 224, 95, 1.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "??ek G??nder",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Icon(
                    Icons.photo_camera,
                    color: Colors.black,
                  )
                ],
              ),
            ),
          ),
          InkWell(
            onTap: tavsiye,
            child: Container(
              width: genislik / 3,
              height: yukseklik / 6.5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: const Color.fromRGBO(244, 229, 34, 1.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "Tavsiye\n??nerileriniz",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Icon(Icons.psychology_outlined, color: Colors.black),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future hesapBilgilerim() async {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (builder) {
          return Container(
            height: yukseklik / 14,
            color: MyColors().sarirenk,
            child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    method == 'Eposta'
                        ? ElevatedButton(
                            child: const Text(
                              "Parolam?? De??i??tir",
                              style: TextStyle(color: Colors.black),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () async {
                              Navigator.of(context, rootNavigator: true).pop();
                              parolaDegistir();
                            })
                        : Container(),
                    ElevatedButton(
                        child: const Text(
                          "Hesab??m?? Sil",
                          style: TextStyle(color: Colors.black),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () async {
                          Navigator.of(context, rootNavigator: true).pop();
                          hesapSilmeOnay();
                        }),
                  ],
                )),
          );
        });
  }

  Future hesapSilmeOnay() async {
    AlertDialog alertt = AlertDialog(
      content: const Text("Hesab??n??z?? Silmek ??stiyormusunuz?",
          style: TextStyle(fontWeight: FontWeight.bold)),
      actions: [
        ElevatedButton(
            child: const Text(
              "Hay??r",
              style: TextStyle(color: Colors.black),
            ),
            style: ElevatedButton.styleFrom(
              primary: MyColors().sarirenk,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
            }),
        ElevatedButton(
            child: const Text(
              "Evet",
              style: TextStyle(color: Colors.black),
            ),
            style: ElevatedButton.styleFrom(
              primary: MyColors().sarirenk,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              hesapSilindi();
              await databaseModel.yorumSil(auth.authid());
              await databaseModel.sikayetSil(auth.authid());
              await auth.deleteUser();
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const Acilisekrani()));
            }),
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alertt;
      },
    );
  }

  Future tavsiye() async {
    AlertDialog alertt = AlertDialog(
      title: const Text("Takside ??ikayet"),
      content: TextField(
        controller: tftavsiye,
        keyboardType: TextInputType.multiline,
        minLines: 7,
        maxLines: null,
        cursorColor: MyColors().sarirenk,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyColors().sarirenk, width: 1.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyColors().sarirenk, width: 1.0),
          ),
          hintText: '??neri & Tavsiye',
        ),
      ),
      actions: [
        ElevatedButton(
            child: const Text(
              "??pat Et",
              style: TextStyle(color: Colors.black),
            ),
            style: ElevatedButton.styleFrom(
              primary: MyColors().sarirenk,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              tftavsiye.clear();
            }),
        ElevatedButton(
            child: const Text(
              "G??nder",
              style: TextStyle(color: Colors.black),
            ),
            style: ElevatedButton.styleFrom(
              primary: MyColors().sarirenk,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              await databaseModel.oneriler(tftavsiye.text);
              tftavsiye.clear();
              oneriGonderildi();
            }),
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alertt;
      },
    );
  }

  Future cekgonder() async {
    resimadi = DateTime.now().millisecondsSinceEpoch.toString();
    final picker = ImagePicker();
    // ignore: deprecated_member_use
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      file = File(pickedFile!.path);
      cekGonderAlert();
      uploadTask =
          FirebaseStorage.instance.ref('CekGonder/$resimadi').putFile(file!);
    });
    cekgonderUrl = await (await uploadTask)!.ref.getDownloadURL();
  }

  Future cekGonderAlert() async {
    AlertDialog alert = AlertDialog(
      title: const Text("Takside ??ikayet"),
      content: Container(
        height: yukseklik / 3,
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            image: DecorationImage(
              fit: BoxFit.fill,
              filterQuality: FilterQuality.high,
              image: FileImage(file!),
            )),
      ),
      actions: [
        ElevatedButton(
            child: const Text(
              "??pat Et",
              style: TextStyle(color: Colors.black),
            ),
            style: ElevatedButton.styleFrom(
              primary: MyColors().sarirenk,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              await firebaseStorage
                  .ref('CekGonder')
                  .child('$resimadi')
                  .delete();
            }),
        ElevatedButton(
            child: const Text(
              "Yeni Fotograf ??ek",
              style: TextStyle(color: Colors.black),
            ),
            style: ElevatedButton.styleFrom(
              primary: MyColors().sarirenk,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              await firebaseStorage
                  .ref('CekGonder')
                  .child('$resimadi')
                  .delete();
              await cekgonder();
            }),
        ElevatedButton(
            child: const Text(
              "G??nder",
              style: TextStyle(color: Colors.black),
            ),
            style: ElevatedButton.styleFrom(
              primary: MyColors().sarirenk,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () async {
              await databaseModel.cekGonder(cekgonderUrl!, mail!);
              await cekGonderGonderildi();
              Navigator.of(context, rootNavigator: true).pop();
            }),
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future oneriGonderildi() async {
    var snackBar = SnackBar(
        content: const Text(
          "??neriniz Bize Ula??t??.",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: MyColors().sarirenk);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future cekGonderGonderildi() async {
    var snackBar = SnackBar(
        content: const Text(
          "Fotograf?? Ba??ar??yla G??nderdiniz.",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: MyColors().sarirenk);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future hesapSilindi() async {
    final snackBar = SnackBar(
      content: const Text(
        "Hesab??n??z Ba??ar??yla Silindi",
        style: TextStyle(
            color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),
      ),
      backgroundColor: MyColors().sarirenk,
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void parolaDegistir() async {
    AlertDialog alert = AlertDialog(
      title: const Text("Parola G??ncelleme"),
      content: SizedBox(
        height: yukseklik / 6,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: tfsifreyenile,
                cursorColor: MyColors().sarirenk,
                keyboardType: TextInputType.text,
                textAlign: TextAlign.center,
                obscureText: false,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: MyColors().sarirenk, width: 2.0),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: MyColors().sarirenk, width: 2.0),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    borderSide:
                        BorderSide(color: MyColors().sarirenk, width: 2),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    borderSide:
                        BorderSide(color: MyColors().sarirenk, width: 2),
                  ),
                  hintText: 'Parola',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                      child: const Text(
                        "??ptal Et",
                        style: TextStyle(color: Colors.black),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: MyColors().sarirenk,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () async {
                        Navigator.of(context, rootNavigator: true).pop();
                      }),
                  ElevatedButton(
                      child: const Text(
                        "G??ncelle",
                        style: TextStyle(color: Colors.black),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: MyColors().sarirenk,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () async {
                        Navigator.of(context, rootNavigator: true).pop();
                        await guncelleSifre();
                      }),
                ],
              )
            ],
          ),
        ),
      ),
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future guncelleSifre() async {
    if (tfsifreyenile.text.length < 6) {
      const snackBar = SnackBar(
        content: Text(
          "Parola 6 Haneden K??????k Olamaz",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      tfsifreyenile.clear();
    } else {
      await auth.changePassword(tfsifreyenile.text);
      final snackBar = SnackBar(
        content: const Text(
          "Parolan??z Ba??ar??yla G??ncellendi",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: MyColors().sarirenk,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      tfsifreyenile.clear();
    }
  }

  void kullaniciAl() async {
    FirebaseFirestore.instance
        .collection("Kullan??c??Bilgileri")
        .doc(auth.authid())
        .get()
        .then((gelenVeri) {
      setState(() {
        mail = gelenVeri.data()!['Kullan??c??'];
        method = gelenVeri.data()!['Method'];
      });
    });
  }
}
