import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:taksiapp/models/colors.dart';
import 'package:taksiapp/models/database_model.dart';

enum KullaniciDurumu {
  oturumAcilmis,
  oturumAcilmamis,
  oturumAciliyor,
}

class AuthModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn googleSignIn = GoogleSignIn();
  DatabaseModel database = DatabaseModel();
  User? _user;

  User? get user => _user;
  KullaniciDurumu _durum = KullaniciDurumu.oturumAcilmamis;
  KullaniciDurumu get durum => _durum;

  set durum(KullaniciDurumu value) {
    _durum = value;
    notifyListeners();
  }

  authModel() {
    _auth.authStateChanges().listen((event) {
      _authstateChanged(_user!);
      notifyListeners();
    });
  }

  void _authstateChanged(User user) {
    // ignore: unnecessary_null_comparison
    if (user == null) {
      _user = null;
      durum = KullaniciDurumu.oturumAcilmamis;
    } else {
      _user = user;
      durum = KullaniciDurumu.oturumAcilmis;
    }
    notifyListeners();
  }

  String authid() {
    final User? user = _auth.currentUser;
    final String uid = user!.uid;
    notifyListeners();
    return uid;
  }

  Future signInGoogle() async {
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
    final UserCredential authResult =
        await _auth.signInWithCredential(credential);

    final User? user = authResult.user;
    _user = user;
    database.googlefacebookKullanicilariniYaz(user!, "Google");
    notifyListeners();
    return '$user';
  }

  Future<UserCredential> signInWithFacebook() async {
    final LoginResult loginResult = await FacebookAuth.instance.login();
    final OAuthCredential facebookCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);

    final UserCredential authResult =
        await _auth.signInWithCredential(facebookCredential);
    final User? user = authResult.user;
    _user = user;
    database.googlefacebookKullanicilariniYaz(user!, "Facebook");
    notifyListeners();
    return _auth.signInWithCredential(facebookCredential);
  }

  Future signInMailandPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = userCredential.user;
      _user = user;
      database.kadiKullaniciVerileriGuncelle(authid(), password);
      notifyListeners();
      return user;
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return "Hata" + e.toString();
    }
  }

  Future signUpMailandPassword(String isim, String email, String telefon,
      String password, String ikamet) async {
    durum = KullaniciDurumu.oturumAciliyor;
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      _user = user;
      database.kadiKullaniciVerileriniYaz(
          user!, "Eposta", isim, email, telefon, password, ikamet);
      Fluttertoast.showToast(
        msg: "Üyeliğiniz Başarıyla Oluşturuldu.Giriş Yapabilirsiniz",
        textColor: Colors.black,
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: MyColors().sarirenk,
        gravity: ToastGravity.TOP,
      );
      notifyListeners();
      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(
          msg:
              "Üyeliğiniz Oluşturulamadı!!! $email Adresi İle Daha Önce Giriş Yapılmış.",
          textColor: Colors.white,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.red,
          gravity: ToastGravity.TOP,
        );
        if (kDebugMode) {
          print(
              "------------------------------------------${e.toString()}-------------------------------------");
        }
      }

      return "--------------Kullanıcı Hatası Bu Kullanıcı Mevcut $email---------------";

      //[firebase_auth/email-already-in-use] The email address is already in use by another account. hatası veriyor
      // email adresi kullanılmaktadır hatası veriyor

    }
  }

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);

    notifyListeners();
  }

  Future<void> changePassword(String password) async {
    _user = _auth.currentUser;
    await _user!.updatePassword(password).then((_) {
      database.kadiKullaniciVerileriGuncelle(authid(), password);
    }).catchError((error) {
      if (kDebugMode) {
        print("Password can't be changed" + error.toString());
      }
    });
    await database.kadiKullaniciVerileriGuncelle(authid(), password);
    notifyListeners();
  }

  Future<void> deleteUser() async {
    await FirebaseAuth.instance.currentUser!.delete();
    notifyListeners();
  }

  Future signOut() async {
    try {
      _user = null;

      return await _auth.signOut();
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      notifyListeners();
      return null;
    }
  }
}
