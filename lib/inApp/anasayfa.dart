// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:taksiapp/models/auth_model.dart';
import 'package:taksiapp/models/colors.dart';
import 'package:intl/intl.dart';
import 'package:taksiapp/models/database_model.dart';
import 'package:taksiapp/screen/splashscreen.dart';
import 'package:taksiapp/tabbar/tabbar_anasayfa.dart';

class Anasayfa extends StatefulWidget {
  const Anasayfa({Key? key}) : super(key: key);

  @override
  _AnasayfaState createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {
  double genislik = 0;
  double yukseklik = 0;
  String? formatted;
  String? isim;
  String? fotograf;
  bool yorumBegenme = false;
  bool begenme = false;
  AuthModel auth = AuthModel();
  DatabaseModel databaseModel = DatabaseModel();
  var tfyorum = TextEditingController();

  @override
  void initState() {
    kullaniciBilgileri();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var ekranBilgisi = MediaQuery.of(context);
    genislik = ekranBilgisi.size.width;
    yukseklik = ekranBilgisi.size.height;
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    formatted = formatter.format(now);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: yukseklik / 9,
        backgroundColor: MyColors().sarirenk,
        title: Image.asset(
          "assets/taksibeyaz.png",
          height: genislik / 3.5,
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          FlatButton(
            child: const Text("Şikayetlerim"),
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const TabbarAnasayfa()));
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Colors.black,
            ),
            onPressed: () async {
              await cikisYap();
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Flex(
          direction: Axis.horizontal,
          children: [
            Expanded(
              child: Column(
                children: [
                  Flex(
                    direction: Axis.horizontal,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            iyiTaksiPlakasi(),
                            kotuTaksiPlakasi(),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Flex(
                    direction: Axis.horizontal,
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            tumunuGoruntuleiyi(),
                            tumunuGoruntuleKotu(),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SingleChildScrollView(
                      child: Column(
                    children: [
                      akis(),
                    ],
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  SizedBox akis() {
    return SizedBox(
      width: genislik / 1,
      height: yukseklik / 3,
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Sikayetlerim")
            .orderBy("Tarih", descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.size == 0) {
              return Column(
                children: [
                  Image.asset(
                    "assets/sikayetYok.png",
                    height: genislik / 3,
                  ),
                  const Text(
                    "Henüz Şikayet Oluşturulmadı",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  )
                ],
              );
            }
            return SizedBox(
              child: ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot course = snapshot.data!.docs[index];
                  return Stack(
                    children: [
                      Container(
                        height: yukseklik / 5.2,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Row(
                          children: [
                            course['ProfilFoto'] == null
                                ? const CircleAvatar(
                                    maxRadius: 20,
                                    backgroundColor: Colors.transparent,
                                    backgroundImage:
                                        AssetImage("assets/avatar.png"),
                                  )
                                : CircleAvatar(
                                    maxRadius: 20,
                                    backgroundColor: Colors.transparent,
                                    backgroundImage:
                                        NetworkImage(course['ProfilFoto']),
                                  ),
                            SizedBox(
                              width: genislik / 1.3,
                              height: yukseklik / 6,
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      course['AdSoyad'],
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 5),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5),
                                      child: Text(
                                        course['Detay'],
                                        style: const TextStyle(
                                            fontSize: 15, color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: SizedBox(
                                height: yukseklik / 5.2,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      course['Fotograf'] == null
                                          ? const Text('')
                                          : GestureDetector(
                                              onTap: () {
                                                olanFotoyuGoster(course);
                                              },
                                              child: const Icon(
                                                  Icons.perm_media_outlined)),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            yorumlariGoster(course);
                                          });
                                        },
                                        child: const Icon(
                                          Icons.chat_bubble_outline,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 2,
                                      ),
                                      GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              begenmeGoster(course);
                                            });
                                          },
                                          child: course["Begenme"]
                                              ? const Icon(
                                                  Icons.favorite,
                                                  color: Colors.red,
                                                )
                                              : const Icon(
                                                  Icons
                                                      .favorite_border_outlined,
                                                )),
                                      const SizedBox(
                                        height: 2,
                                      ),
                                      Icon(
                                        Icons.star,
                                        color: MyColors().sarirenk,
                                      ),
                                      Text(
                                        course['Puanlama'],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            );
          }
          return Container();
        },
      ),
    );
  }

  Flexible iyiTaksiPlakasi() {
    return Flexible(
      flex: 2,
      child: Container(
        width: genislik / 2,
        height: yukseklik / 2.5,
        color: const Color.fromRGBO(116, 183, 43, 1.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                "En İyi 10",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const Text(
                "Taksi Plakası",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              Text(
                "$formatted",
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 2,
              ),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("Sikayetlerim")
                    .orderBy('Puanlama', descending: true)
                    .limit(10)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return SingleChildScrollView(
                      child: SizedBox(
                        width: genislik / 2.4,
                        height: yukseklik / 3.2,
                        child: ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot course =
                                snapshot.data!.docs[index];
                            index = index + 1;
                            return Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    index.toString(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 15),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 1, right: 10),
                                  child: Container(
                                    width: genislik / 3,
                                    height: 25,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.white),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5),
                                          child: Text(course['Plaka']),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    );
                  }
                  return Container();
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Flexible kotuTaksiPlakasi() {
    return Flexible(
      flex: 2,
      child: Container(
        width: genislik / 2,
        height: yukseklik / 2.5,
        color: const Color.fromRGBO(229, 36, 33, 1.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                "En Kötü 10",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const Text(
                "Taksi Plakası",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              Text(
                "$formatted",
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 2,
              ),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("Sikayetlerim")
                    .orderBy('Puanlama')
                    .limit(10)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return SingleChildScrollView(
                      child: SizedBox(
                        width: genislik / 2.4,
                        height: yukseklik / 3.2,
                        child: ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot course =
                                snapshot.data!.docs[index];
                            index = index + 1;
                            return Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    index.toString(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 15),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 1, right: 10),
                                  child: Container(
                                    width: genislik / 3,
                                    height: 25,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.white),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5),
                                          child: Text(course['Plaka']),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    );
                  }
                  return Container();
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  ElevatedButton tumunuGoruntuleiyi() {
    return ElevatedButton(
        child: const Text(
          "Tümünü Görüntüle",
          style: TextStyle(color: Colors.black),
        ),
        style: ElevatedButton.styleFrom(
          primary: MyColors().sarirenk,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () async {
          hepsiniGoruntuleiyi();
        });
  }

  ElevatedButton tumunuGoruntuleKotu() {
    return ElevatedButton(
        child: const Text(
          "Tümünü Görüntüle",
          style: TextStyle(color: Colors.black),
        ),
        style: ElevatedButton.styleFrom(
          primary: MyColors().sarirenk,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () async {
          hepsiniGoruntulekotu();
        });
  }

  Future hepsiniGoruntulekotu() async {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (builder) {
          return Container(
            width: genislik / 2,
            height: yukseklik / 1.8,
            color: const Color.fromRGBO(229, 36, 33, 1.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  "En Kötü Taksi Plakaları",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  "$formatted",
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 5,
                ),
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("Sikayetlerim")
                      .orderBy('Puanlama')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return Expanded(
                      child: SizedBox(
                        width: genislik / 2.0,
                        height: yukseklik / 2.0,
                        child: ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot course =
                                snapshot.data!.docs[index];
                            index = index + 1;
                            return Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    index.toString(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 20),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 1),
                                  child: Container(
                                    width: genislik / 2.5,
                                    height: 30,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.white),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5),
                                          child: Text(course['Plaka']),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
          );
        });
  }

  Future hepsiniGoruntuleiyi() async {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (builder) {
          return Container(
            width: genislik / 2,
            height: yukseklik / 1.8,
            color: const Color.fromRGBO(116, 183, 43, 1.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  "En İyi Taksi Plakaları",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  "$formatted",
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 5,
                ),
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("Sikayetlerim")
                      .orderBy('Puanlama', descending: true)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return Expanded(
                      child: SizedBox(
                        width: genislik / 2,
                        height: yukseklik / 2.0,
                        child: ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot course =
                                snapshot.data!.docs[index];
                            index = index + 1;
                            return Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    index.toString(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 20),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 1),
                                  child: Container(
                                    width: genislik / 2.5,
                                    height: 30,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.white),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5),
                                          child: Text(course['Plaka']),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
          );
        });
  }

  Future cikisYap() async {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (builder) {
          return Container(
            height: yukseklik / 15,
            decoration: const BoxDecoration(
              shape: BoxShape.rectangle,
            ),
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

  Future olanFotoyuGoster(DocumentSnapshot documentSnapshot) async {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (builder) {
          return SizedBox(
            child:
                Image.network(documentSnapshot['Fotograf'], fit: BoxFit.fill),
          );
        });
  }

  void begenmeGoster(DocumentSnapshot documentSnapshot) async {
    begenme = !begenme;
    if (begenme == false) {
      FirebaseFirestore.instance
          .collection('Sikayetlerim')
          .doc(documentSnapshot.id)
          .update({"Begenme": false});
    }
    if (begenme == true) {
      FirebaseFirestore.instance
          .collection('Sikayetlerim')
          .doc(documentSnapshot.id)
          .update({"Begenme": true});
    }
  }

  void yorumlariGoster(DocumentSnapshot documentSnapshot) async {
    showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Flex(
            direction: Axis.vertical,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          fotograf == null
                              ? const CircleAvatar(
                                  maxRadius: 20,
                                  backgroundColor: Colors.transparent,
                                  backgroundImage:
                                      AssetImage("assets/avatar.png"),
                                )
                              : CircleAvatar(
                                  maxRadius: 20,
                                  backgroundColor: Colors.transparent,
                                  backgroundImage: NetworkImage(fotograf!),
                                ),
                          SizedBox(
                            width: genislik / 1.5,
                            child: TextField(
                              controller: tfyorum,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              cursorColor: MyColors().sarirenk,
                              decoration: const InputDecoration(
                                hintText: 'Yorum Ekle',
                              ),
                            ),
                          ),
                          ElevatedButton(
                              child: const Text(
                                "Gönder",
                                style: TextStyle(color: Colors.black),
                              ),
                              style: ElevatedButton.styleFrom(
                                primary: MyColors().sarirenk,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () async {
                                await databaseModel.tumyorumlar(
                                    isim!,
                                    tfyorum.text,
                                    fotograf,
                                    yorumBegenme,
                                    documentSnapshot);

                                tfyorum.clear();
                              })
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("Yorumlar")
                      .where("SikayetId", isEqualTo: documentSnapshot.id)
                      .orderBy("Tarih", descending: true)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text(
                          "Hata Oluştu !",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      );
                    }
                    if (snapshot.hasData) {
                      //veri yoksa
                      if (snapshot.data!.size == 0) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Image.asset("assets/yorumYok.png"),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              "Henüz Yorum Yapılmamış",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            )
                          ],
                        );
                      }
                      return SizedBox(
                        height: yukseklik / 1.3,
                        child: ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot tumyorum =
                                  snapshot.data!.docs[index];
                              return SingleChildScrollView(
                                child: Padding(
                                    padding:
                                        const EdgeInsets.only(left: 5, top: 30),
                                    child: SizedBox(
                                      height: yukseklik / 8,
                                      child: Row(
                                        children: [
                                          tumyorum['ProfilFoto'] == null
                                              ? const CircleAvatar(
                                                  maxRadius: 20,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  backgroundImage: AssetImage(
                                                      "assets/avatar.png"),
                                                )
                                              : CircleAvatar(
                                                  maxRadius: 20,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  backgroundImage: NetworkImage(
                                                      tumyorum['ProfilFoto']),
                                                ),
                                          SizedBox(
                                            width: genislik / 1.4,
                                            height: yukseklik / 8,
                                            child: SingleChildScrollView(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    tumyorum["AdSoyad"],
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  const SizedBox(height: 5),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 5),
                                                    child: Text(
                                                      tumyorum["Yorum"],
                                                      style: const TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              IconButton(
                                                onPressed: () {
                                                  yorumbegenmeGoster(tumyorum);
                                                },
                                                icon: tumyorum["Begenme"]
                                                    ? const Icon(
                                                        Icons.favorite,
                                                        color: Colors.red,
                                                      )
                                                    : const Icon(
                                                        Icons
                                                            .favorite_border_outlined,
                                                      ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    )),
                              );
                            }),
                      );
                    }
                    return Container();
                  })
            ],
          );
        });
  }

  void yorumbegenmeGoster(DocumentSnapshot documentSnapshot) async {
    yorumBegenme = !yorumBegenme;
    if (yorumBegenme == false) {
      FirebaseFirestore.instance
          .collection('Yorumlar')
          .doc(documentSnapshot.id)
          .update({"Begenme": false});
    }
    if (yorumBegenme == true) {
      FirebaseFirestore.instance
          .collection('Yorumlar')
          .doc(documentSnapshot.id)
          .update({"Begenme": true});
    }
  }

  void kullaniciBilgileri() async {
    FirebaseFirestore.instance
        .collection("KullanıcıBilgileri")
        .doc(auth.authid())
        .get()
        .then((gelenVeri) {
      setState(() {
        isim = gelenVeri.data()!['AdSoyad'];
        fotograf = gelenVeri.data()!['Fotograf'];
      });
    });
  }
}
