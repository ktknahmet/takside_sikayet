import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taksiapp/models/auth_model.dart';
import 'package:taksiapp/models/colors.dart';
import 'package:taksiapp/models/database_model.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:taksiapp/models/permission.dart';
import 'package:taksiapp/tabbar/tabbar_anasayfa.dart';

class Sikayetekle extends StatefulWidget {
  const Sikayetekle({Key? key}) : super(key: key);

  @override
  _SikayetekleState createState() => _SikayetekleState();
}

class _SikayetekleState extends State<Sikayetekle> {
  DatabaseModel databaseModel = DatabaseModel();
  AuthModel auth = AuthModel();
  Izinler permission = Izinler();
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  var tfplaka = GlobalKey<FormState>();
  var tfkonu = GlobalKey<FormState>();
  var tfdetay = GlobalKey<FormState>();
  File? file;
  String? resimAdi;
  String? plaka;
  String? konu;
  String? detay;
  double puanlama = 3;
  String? imageUrl;
  String? mail;
  String? isim;
  String? fotograf;
  double genislik = 0;
  double yukseklik = 0;

  @override
  void initState() {
    kullaniciMail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var ekranBilgisi = MediaQuery.of(context);
    genislik = ekranBilgisi.size.width;
    yukseklik = ekranBilgisi.size.height;
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: const BackButton(color: Colors.black),
          title: const Text(
            "Yeni Şikayet",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          backgroundColor: MyColors().sarirenk,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              formplaka(),
              const SizedBox(
                height: 5,
              ),
              formsikayet(),
              const SizedBox(
                height: 5,
              ),
              formsikayetdetay(),
              const SizedBox(
                height: 10,
              ),
              puanla(),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Varsa Eklemek İstediğiniz",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(
                height: 20,
              ),
              fotoEkle(),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(
                height: 20,
              ),
              const SizedBox(
                height: 40,
              ),
              gonder(),
            ],
          ),
        ));
  }

  Future fotoGoster() async {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (builder) {
          return Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                  fit: BoxFit.cover,
                  image: FileImage(file!),
                )),
              ),
              SizedBox(
                  width: genislik,
                  height: yukseklik / 12,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                          onTap: () async {
                            Navigator.of(context, rootNavigator: true).pop();
                            await firebaseStorage
                                .ref('Image')
                                .child('$resimAdi')
                                .delete();
                            await addPhoto();
                            await fotoGoster();
                          },
                          //güncelleme
                          child: Image.asset(
                            "assets/guncelle.png",
                            height: 50,
                          )),
                      GestureDetector(
                          onTap: () async {
                            Navigator.of(context, rootNavigator: true).pop();
                            fotoYuklendi();
                          },
                          //yükleme
                          child: Image.asset(
                            "assets/gonder.png",
                            height: 50,
                          )),
                      GestureDetector(
                          onTap: () async {
                            await firebaseStorage
                                .ref('Image')
                                .child('$resimAdi')
                                .delete();
                            Navigator.of(context, rootNavigator: true).pop();
                            fotoYuklenmedi();
                          },
                          child: Image.asset(
                            "assets/delete.png",
                            height: 70,
                          )),
                    ],
                  ))
            ],
          );
        });
  }

  Row puanla() {
    return Row(
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 15),
          child: Text(
            "Şöför Puanı:",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        RatingBar.builder(
          initialRating: puanlama,
          minRating: 0.5,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
          itemBuilder: (context, _) =>
              Icon(Icons.star, color: MyColors().sarirenk),
          onRatingUpdate: (rating) {
            puanlama = rating;
            if (kDebugMode) {
              print(puanlama);
            }
          },
        ),
      ],
    );
  }

  Padding fotoEkle() {
    return Padding(
      padding: const EdgeInsets.only(left: 30),
      child: GestureDetector(
          onTap: () async {
            await addPhoto();
            await fotoGoster();
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Icon(
                Icons.add_photo_alternate_outlined,
              ),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text("Fotoğraf Ekle"),
              ),
            ],
          )),
    );
  }

  Padding formplaka() {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30),
      child: Form(
        key: tfplaka,
        child: TextFormField(
          cursorColor: MyColors().sarirenk,
          keyboardType: TextInputType.text,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyColors().sarirenk, width: 2.0),
              borderRadius: BorderRadius.circular(20),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyColors().sarirenk, width: 2.0),
              borderRadius: BorderRadius.circular(20),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              borderSide: BorderSide(color: MyColors().sarirenk, width: 2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              borderSide: BorderSide(color: MyColors().sarirenk, width: 2),
            ),
            hintText: 'Şikayetçi Olduğunuz Plaka',
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return '*Zorunlu Alan';
            }
            return null;
          },
          onSaved: (value) {
            plaka = value!.trim();
          },
        ),
      ),
    );
  }

  Padding formsikayet() {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30),
      child: Form(
        key: tfkonu,
        child: TextFormField(
          cursorColor: MyColors().sarirenk,
          keyboardType: TextInputType.text,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyColors().sarirenk, width: 2.0),
              borderRadius: BorderRadius.circular(20),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyColors().sarirenk, width: 2.0),
              borderRadius: BorderRadius.circular(20),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              borderSide: BorderSide(color: MyColors().sarirenk, width: 2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              borderSide: BorderSide(color: MyColors().sarirenk, width: 2),
            ),
            hintText: 'Şikayet Konusu',
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return '*Zorunlu Alan';
            }
            return null;
          },
          onSaved: (value) {
            konu = value;
          },
        ),
      ),
    );
  }

  Padding formsikayetdetay() {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30),
      child: Form(
        key: tfdetay,
        child: TextFormField(
          keyboardType: TextInputType.multiline,
          minLines: 5,
          maxLines: null,
          cursorColor: MyColors().sarirenk,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyColors().sarirenk, width: 2.0),
              borderRadius: BorderRadius.circular(20),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyColors().sarirenk, width: 2.0),
              borderRadius: BorderRadius.circular(20),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              borderSide: BorderSide(color: MyColors().sarirenk, width: 2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              borderSide: BorderSide(color: MyColors().sarirenk, width: 2),
            ),
            hintText: 'Şikayet Hakkında Daha Fazla Detay',
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return '*Zorunlu Alan';
            }
            return null;
          },
          onSaved: (value) {
            detay = value;
          },
        ),
      ),
    );
  }

  SizedBox gonder() {
    return SizedBox(
      width: genislik / 1.5,
      height: yukseklik / 14,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(MyColors().sarirenk),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
          ),
        ),
        child: const Text(
          'Gönder',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        onPressed: () async {
          veriGonder();
        },
      ),
    );
  }

  void veriGonder() async {
    tfplaka.currentState!.validate();
    tfdetay.currentState!.validate();
    tfkonu.currentState!.validate();

    tfplaka.currentState!.save();
    tfkonu.currentState!.save();
    tfdetay.currentState!.save();

    if (plaka!.isEmpty || konu!.isEmpty || detay!.isEmpty) {
      const snackBar = SnackBar(
        content: Text(
          "Lütfen Tüm Bilgileri Eksiksiz Doldurun!!",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      await databaseModel.sikayetlerim(
          plaka!.toUpperCase(),
          konu!.toUpperCase(),
          detay!.toUpperCase(),
          imageUrl,
          fotograf,
          puanlama,
          isim!.toUpperCase(),
          mail!,
          false);
      sikayetGonderildi();
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const TabbarAnasayfa()));
    }
  }

  Future addPhoto() async {
    await permission.storagePermission();
    UploadTask? uploadTask;
    resimAdi = DateTime.now().millisecondsSinceEpoch.toString();
    final picker = ImagePicker();
    // ignore: deprecated_member_use
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    file = File(pickedFile!.path);
    uploadTask = firebaseStorage.ref('Image/$resimAdi').putFile(file!);
    var snackBar = SnackBar(
        content: const Text(
          "Fotografınız Yükleniyor Lütfen Bekleyin",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: MyColors().sarirenk);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    imageUrl = await (await uploadTask).ref.getDownloadURL();
  }

  void fotoYuklendi() {
    var snackBar = SnackBar(
        content: const Text(
          "Fotografınız Başarıyla Yüklendi.",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: MyColors().sarirenk);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void fotoYuklenmedi() {
    var snackBar = SnackBar(
        content: const Text(
          "Fotograf Yüklenmesi İptal Edildi.",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: MyColors().sarirenk);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future sikayetGonderildi() async {
    var snackBar = const SnackBar(
        content: Text(
          "Şikayetiniz Başarıyla Gönderildi.",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future kullaniciMail() async {
    FirebaseFirestore.instance
        .collection("KullanıcıBilgileri")
        .doc(auth.authid())
        .get()
        .then((gelenVeri) {
      setState(() {
        isim = gelenVeri.data()!['AdSoyad'];
        fotograf = gelenVeri.data()!['Fotograf'];
        mail = gelenVeri.data()!['Kullanıcı'];
      });
    });
  }
}
