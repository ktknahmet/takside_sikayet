import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:taksiapp/models/auth_model.dart';

class DatabaseModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? user;

  Future checkUserExist(String docID) async {
    bool exists = false;
    try {
      await _firestore.doc("KullanıcıBilgileri/$docID").get().then((doc) {
        if (doc.exists) {
          exists = true;
        } else {
          exists = false;
        }
      });
      notifyListeners();
      return exists;
    } catch (e) {
      return false;
    }
  }

  Future googlefacebookKullanicilariniYaz(User user, String method) async {
    await _firestore.collection("KullanıcıBilgileri").doc(user.uid).set({
      "Method": method,
      "AdSoyad": user.displayName,
      "Kullanıcı": user.email,
      "Fotograf": user.photoURL,
    }, SetOptions(merge: true));
    notifyListeners();
  }

  Future kadiKullaniciVerileriniYaz(User user, String method, String isim,
      String email, String tel, String parola, String ikamet) async {
    await _firestore.collection("KullanıcıBilgileri").doc(user.uid).set({
      "Method": method,
      "AdSoyad": isim,
      "Kullanıcı": email,
      "Telefon": tel,
      "Şifre": parola,
      "İkamet": ikamet,
      "Fotograf": user.photoURL,
    }, SetOptions(merge: true));
    notifyListeners();
  }

  Future tumyorumlar(String adsoyad, String yorum, profilFoto,
      bool yorumBegenme, DocumentSnapshot documentSnapshot) async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd-MM-yyyy HH-mm:ss').format(now);
    await _firestore.collection("Yorumlar").doc().set({
      "Yorum": yorum,
      "Tarih": formattedDate,
      "ProfilFoto": profilFoto,
      "SikayetId": documentSnapshot.id,
      "AdSoyad": adsoyad,
      "Begenme": yorumBegenme,
      "Uid": AuthModel().authid(),

    }, SetOptions(merge: true));
    notifyListeners();
  }

  Future kadiKullaniciVerileriGuncelle(String kullanici, String parola) async {
    await _firestore.collection("KullanıcıBilgileri").doc(kullanici).update({
      "Şifre": parola,
    });
    notifyListeners();
  }

  Future kullaniciSil(String userUid) async {
    await _firestore.collection("KullanıcıBilgileri").doc(userUid).delete();
    notifyListeners();
  }

  Future sikayetlerim(
      String plakaa,
      String konuu,
      String detayy,
      photo,
      profilFoto,
      double puanlamaa,
      String isim,
      String mail,
      int begenmeSayisi,
      int yorumSayisi,
      bool begenme) async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd-MM-yyyy HH-mm:ss').format(now);
    await _firestore.collection("Sikayetlerim").doc().set({
      "Plaka": plakaa,
      "Konu": konuu,
      "Detay": detayy,
      "Fotograf": photo,
      "ProfilFoto": profilFoto,
      "Puanlama": puanlamaa.toString(),
      "AdSoyad": isim,
      "Kullanıcı": mail,
      "Tarih": formattedDate,
      "Begenme": begenme,
      "BegenmeSayısı" :begenmeSayisi,
      "YorumSayısı":yorumSayisi,
      "Uid": AuthModel().authid(),
    }, SetOptions(merge: true));

    notifyListeners();
  }

  Future oneriler(String oneri) async {
    await _firestore
        .collection("Oneriler")
        .doc()
        .set({"Öneri": oneri}, SetOptions(merge: true));
    notifyListeners();
  }

  Future cekGonder(String cekGonderUrl, String mail) async {
    await _firestore.collection("CekGonder").doc().set({
      "Fotograf": cekGonderUrl,
      "Kullanıcı": mail,
    }, SetOptions(merge: true));
    notifyListeners();
  }

  Future anketGonder(
      String soru1, String soru2, String soru3, String soru4) async {
    await _firestore.collection("Anketler").doc().set({
      "Soru1": soru1,
      "Soru2": soru2,
      "Soru3": soru3,
      "Soru4": soru4,
      "Uid": AuthModel().authid(),
    }, SetOptions(merge: true));
    notifyListeners();
  }

  Future sikayetSil(String authId) async {
    var sikayetsil = await FirebaseFirestore.instance
        .collection("Sikayetlerim")
        .where("Uid", isEqualTo: authId)
        .get();
    for (var doc in sikayetsil.docs) {
      await doc.reference.delete();
    }
    notifyListeners();
  }

  Future yorumSil(String authId) async {
    var yorumsil = await FirebaseFirestore.instance
        .collection("Yorumlar")
        .where("Uid", isEqualTo: authId)
        .get();
    for (var doc in yorumsil.docs) {
      await doc.reference.delete();
    }
    notifyListeners();
  }


}
