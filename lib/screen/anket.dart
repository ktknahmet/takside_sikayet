import 'package:flutter/material.dart';
import 'package:taksiapp/models/colors.dart';
import 'package:taksiapp/models/database_model.dart';
import 'package:taksiapp/tabbar/tabbar_anasayfa.dart';

class AnketScreen extends StatefulWidget {
  const AnketScreen({Key? key}) : super(key: key);

  @override
  _AnketScreenState createState() => _AnketScreenState();
}

class _AnketScreenState extends State<AnketScreen> {
  double genislik = 0;
  double yukseklik = 0;
  String? qOne;
  String? qTwo;
  String? qThree;
  String? qFour;
  DatabaseModel databaseModel = DatabaseModel();
  @override
  Widget build(BuildContext context) {
    var ekranBilgisi = MediaQuery.of(context);
    genislik = ekranBilgisi.size.width;
    yukseklik = ekranBilgisi.size.height;

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: const BackButton(
            color: Colors.black,
          ),
          backgroundColor: MyColors().sarirenk,
          title: const Text(
            "Takside Şikayet !",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Flex(
            direction: Axis.vertical,
            children: [
              const SizedBox(
                height: 20,
              ),
              anketSorulari(),
              gonder(),
            ],
          ),
        ));
  }

  Align anketSorulari() {
    return Align(
        alignment: Alignment.center,
        child: Column(
          children: [
            const Text(
              "Bizi nereden duydunuz?",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 18),
            ),
            RadioListTile(
              title: const Text("Reklam"),
              groupValue: qOne,
              value: "Reklam",
              activeColor: MyColors().sarirenk,
              onChanged: (String? q1) {
                setState(() {
                  qOne = q1!;
                });
              },
            ),
            RadioListTile(
              title: const Text("Sosyal Medya"),
              groupValue: qOne,
              value: "Sosyal Medya",
              activeColor: MyColors().sarirenk,
              onChanged: (String? q1) {
                setState(() {
                  qOne = q1!;
                });
              },
            ),
            RadioListTile(
              title: const Text("Arkadaş Tavsiyesi"),
              groupValue: qOne,
              value: "Arkadaş Tavsiyesi",
              activeColor: MyColors().sarirenk,
              onChanged: (String? q1) {
                setState(() {
                  qOne = q1!;
                });
              },
            ),
            const Divider(
              thickness: 1,
            ),
            const Text(
              "Uygulamayı geliştirmek için bir fikrin var mı?",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 18),
            ),
            RadioListTile(
              title: const Text("Evet bir fikrim var"),
              groupValue: qTwo,
              value: "Evet bir fikrim var",
              activeColor: MyColors().sarirenk,
              onChanged: (String? q2) {
                setState(() {
                  qTwo = q2!;
                });
              },
            ),
            RadioListTile(
              title: const Text("Hayır, uygulama yeterince işlevsel."),
              groupValue: qTwo,
              value: "Hayır, uygulama yeterince işlevsel.",
              activeColor: MyColors().sarirenk,
              onChanged: (String? q2) {
                setState(() {
                  qTwo = q2!;
                });
              },
            ),
            const Divider(
              thickness: 1,
            ),
            const Text(
              "Uygulama kullanım kolaylığı açısından nasıl?",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 18),
            ),
            RadioListTile(
              title: const Text("Oldukça pratik."),
              groupValue: qThree,
              value: "Oldukça pratik.",
              activeColor: MyColors().sarirenk,
              onChanged: (String? q3) {
                setState(() {
                  qThree = q3!;
                });
              },
            ),
            RadioListTile(
              title: const Text("Karmaşık, aradığımı bulamıyorum."),
              groupValue: qThree,
              value: "Karmaşık, aradığımı bulamıyorum.",
              activeColor: MyColors().sarirenk,
              onChanged: (String? q3) {
                setState(() {
                  qThree = q3!;
                });
              },
            ),
            const Divider(
              thickness: 1,
            ),
            const Text(
              "Takside Şikayet uygulamasını arkadaşına tavsiye eder misin?",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 18),
            ),
            RadioListTile(
              title: const Text("Memnuniyetle."),
              groupValue: qFour,
              value: "Memnuniyetle.",
              activeColor: MyColors().sarirenk,
              onChanged: (String? q4) {
                setState(() {
                  qFour = q4!;
                });
              },
            ),
            RadioListTile(
              title: const Text("Şimdilik düşünmüyorum."),
              groupValue: qFour,
              value: "Şimdilik düşünmüyorum.",
              activeColor: MyColors().sarirenk,
              onChanged: (String? q4) {
                setState(() {
                  qFour = q4!;
                });
              },
            ),
          ],
        ));
  }

  SizedBox gonder() {
    return SizedBox(
      width: genislik,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(MyColors().sarirenk),
        ),
        child: const Text(
          'Gönder',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        onPressed: () async {
          await databaseModel.anketGonder(qOne.toString(), qTwo.toString(),
              qThree.toString(), qFour.toString());
          anketGonderildi();
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const TabbarAnasayfa()));
        },
      ),
    );
  }

  Future anketGonderildi() async {
    var snackBar = SnackBar(
        content: const Text(
          "Ankete katılımınız için teşekkür ederiz ",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: MyColors().sarirenk);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
