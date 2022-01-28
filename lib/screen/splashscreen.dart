import 'package:flutter/material.dart';
import 'package:taksiapp/models/colors.dart';
import 'package:taksiapp/screen/acilisekrani.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({Key? key}) : super(key: key);

  @override
  _SplashscreenState createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
         Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const Acilisekrani()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors().sarirenk,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset("assets/taksibeyaz.png"),
            const SizedBox(
              height: 50,
            ),
            const Text(
              "Takside Şikayet!",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 30),
            ),
          ],
        ),
      ),
    );
  }
}
