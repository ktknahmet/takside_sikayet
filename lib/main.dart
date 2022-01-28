import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:taksiapp/inApp/anasayfa.dart';
import 'package:taksiapp/models/Auth_model.dart';
import 'package:taksiapp/screen/splashscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Future<bool> control() async {
    if (FirebaseAuth.instance.currentUser == null) {
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Takside Şikayet!',
        theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: FutureBuilder<bool>(
          future: control(),
          builder: (context, snopshot) {
            if (snopshot.hasData) {
              bool izin = snopshot.data!;
              return izin ? const Anasayfa() : const Splashscreen();
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
