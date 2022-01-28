import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:taksiapp/inApp/anasayfa.dart';
import 'package:taksiapp/inApp/ayarlar.dart';
import 'package:taksiapp/inApp/sikayetlerim.dart';
import 'package:taksiapp/models/auth_model.dart';
import 'package:taksiapp/models/colors.dart';
import 'package:taksiapp/models/database_model.dart';
import 'package:taksiapp/screen/splashscreen.dart';

class TabbarAnasayfa extends StatefulWidget {
  const TabbarAnasayfa({Key? key}) : super(key: key);

  @override
  _TabbarAnasayfaState createState() => _TabbarAnasayfaState();
}

class _TabbarAnasayfaState extends State<TabbarAnasayfa>
    with TickerProviderStateMixin {
  AuthModel auth = AuthModel();
  DatabaseModel databaseModel = DatabaseModel();
  late TabController tabController;
  double genislik = 0;
  double yukseklik = 0;
  String isim = '';
  String mail = '';
  String? fotograf;
  String currentAdress = '';

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    getAdress();
    yaziGetir();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    tabController = TabController(length: 2, vsync: this);
    var ekranBilgisi = MediaQuery.of(context);
    genislik = ekranBilgisi.size.width;
    yukseklik = ekranBilgisi.size.height;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.home_outlined,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const Anasayfa()));
            },
          ),
          toolbarHeight: yukseklik / 4.5,
          backgroundColor: MyColors().sarirenk,
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: true,
            title: appbarTasarim(),
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.logout,
                color: Colors.black,
              ),
              onPressed: () async {
                await cikisYap();
              },
            ),
          ],
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(
                text: "Şikayetlerim",
              ),
              Tab(
                text: "Değerlendirme Ve Ayarlar",
              )
            ],
            labelColor: Colors.black,
            indicatorColor: Colors.black,
          ),
        ),
        body: const TabBarView(
          children: [
            Sikayetlerim(),
            Ayarlar(),
          ],
        ),
      ),
    );
  }

  Column appbarTasarim() {
    return Column(
      children: [
        const SizedBox(
          height: 30,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              "Takside Şikayet!",
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const Divider(
              thickness: 1,
            ),
            fotograf == null
                ? const CircleAvatar(
                    maxRadius: 20,
                    backgroundColor: Colors.transparent,
                    backgroundImage: AssetImage("assets/avatar.png"),
                  )
                : CircleAvatar(
                    maxRadius: 20,
                    backgroundColor: Colors.transparent,
                    backgroundImage: NetworkImage(fotograf.toString()),
                  ),
            Text(
              isim.toUpperCase(),
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: Colors.black),
            ),
            Text(
              mail.toString(),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),
            ),
            const SizedBox(
              height: 2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.location_on_outlined),
                currentAdress == ''
                    ? const Text(
                        "Konum Alınıyor",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      )
                    : Text(
                        currentAdress,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      )
              ],
            ),
            const Divider(
              thickness: 1,
            ),
          ],
        ),
      ],
    );
  }

  Future cikisYap() async {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (builder) {
          return SizedBox(
            height: yukseklik / 15,
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Row(
                children: [
                  const Expanded(
                      child: Text(
                    "Çıkış Yapmak İstiyormusunuz ?",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  )),
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
                      onPressed: () {
                        setState(() {
                          auth.signOut();
                        });
                        Navigator.of(context, rootNavigator: true).pop();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Splashscreen()));


                      }),
                ],
              ),
            ),
          );
        });
  }

  void yaziGetir() async {
    FirebaseFirestore.instance
        .collection("KullanıcıBilgileri")
        .doc(auth.authid())
        .get()
        .then((gelenVeri) {
      setState(() {
        isim = gelenVeri.data()!['AdSoyad'];
        mail = gelenVeri.data()!['Kullanıcı'];
        fotograf = gelenVeri.data()!['Fotograf'];
      });
    });
  }

  void getAdress() async {
    try {
      var enlemBoylam = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placemark = await GeocodingPlatform.instance
          .placemarkFromCoordinates(
              enlemBoylam.latitude, enlemBoylam.longitude);
      Placemark place = placemark[0];
      currentAdress = ("${place.administrativeArea}/${place.locality}");
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
