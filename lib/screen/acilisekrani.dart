// ignore_for_file: deprecated_member_use

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:taksiapp/models/colors.dart';
import 'package:taksiapp/models/permission.dart';
import 'package:taksiapp/tabbar/tabuyegiris.dart';

class Acilisekrani extends StatefulWidget {
  const Acilisekrani({Key? key}) : super(key: key);

  @override
  _AcilisekraniState createState() => _AcilisekraniState();
}

int currentIndex = 0;
List<String> imagesList = [
  "assets/oyver.png",
  "assets/puanla.png",
  "assets/yorumla.png"
];
List<String> aciklama = [
  "İstanbuldaki en iyi & en kötü taksi plakaları.",
  "Sürücünü 5 yıldız üzerinden puanla",
  "Güvenli yolculuk,sürücü yorumları,şikayet ve olumlu yorumlar."
];
double genislik = 0;
double yukseklik = 0;
Izinler permission = Izinler();

class _AcilisekraniState extends State<Acilisekrani> {
  @override
  void initState() {
    super.initState();
    permission.getLocation();
  }

  @override
  Widget build(BuildContext context) {
    var ekranBilgisi = MediaQuery.of(context);
    genislik = ekranBilgisi.size.width;
    yukseklik = ekranBilgisi.size.height;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: genislik / 1,
            height: yukseklik / 1.4,
            child: CarouselSlider.builder(
              options: CarouselOptions(
                aspectRatio: 16 / 9,
                height: yukseklik / 1.8,
                enableInfiniteScroll: true,
                pageSnapping: false,
                onPageChanged: (index, reason) =>
                    setState(() => currentIndex = index),
              ),
              itemCount: imagesList.length,
              itemBuilder: (context, index, realIndex) {
                final resim = imagesList[index];
                return buildImage(resim, aciklama[index], index);
              },
            ),
          ),
          AnimatedSmoothIndicator(
            activeIndex: currentIndex,
            count: imagesList.length,
            effect: JumpingDotEffect(
              dotColor: MyColors().yaziKodu,
              activeDotColor: MyColors().sarirenk,
              dotWidth: 15,
            ),
          ),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(MyColors().sarirenk),
            ),
            child: const Text(
              'HEMEN BAŞLA',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () async {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const Tabuyegiris()));
            },
          ),
        ],
      ),
    );
  }
}

Widget buildImage(String urlImage, String yazilar, int index) => Stack(
      children: [
        Image.asset(
          urlImage,
          filterQuality: FilterQuality.high,
          fit: BoxFit.cover,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              yazilar,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: MyColors().yaziKodu),
            )
          ],
        )
      ],
    );
