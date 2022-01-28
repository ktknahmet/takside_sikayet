import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:taksiapp/inApp/sikayetekle.dart';
import 'package:taksiapp/models/auth_model.dart';
import 'package:taksiapp/models/colors.dart';

class Sikayetlerim extends StatefulWidget {
  const Sikayetlerim({Key? key}) : super(key: key);

  @override
  _SikayetlerimState createState() => _SikayetlerimState();
}

class _SikayetlerimState extends State<Sikayetlerim> {
  double genislik = 0;
  double yukseklik = 0;
  bool begenme = false;
  AuthModel auth = AuthModel();

  @override
  Widget build(BuildContext context) {
    var ekranBilgisi = MediaQuery.of(context);
    genislik = ekranBilgisi.size.width;
    yukseklik = ekranBilgisi.size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Flex(
          direction: Axis.horizontal,
          children: [
            Expanded(
              child: Column(
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  bilgiEkrani(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const Sikayetekle()));
        },
        backgroundColor: MyColors().sarirenk,
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
    );
  }

  Align bilgiEkrani() {
    return Align(
        alignment: Alignment.center,
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("Sikayetlerim")
                .orderBy("Tarih", descending: true)
                .where("Uid", isEqualTo: auth.authid())
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text(
                    "Hata Oluştu !",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                );
              }

              if (snapshot.hasData) {
                if (snapshot.data!.size == 0) {
                  return Column(
                    children: [
                      Image.asset(
                        "assets/sikayetYok.png",
                        height: genislik / 2,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "Şikayet Listen Boş",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      )
                    ],
                  );
                }
                return SizedBox(
                  height: yukseklik / 1.5,
                  child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot veri = snapshot.data!.docs[index];
                      return Dismissible(
                          key: UniqueKey(),
                          background: Container(
                            color: Colors.red,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: const [
                                Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                                Text(
                                  "Sil",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          onDismissed: (direction) {
                            setState(() {
                              sikayetSil(veri);
                              yorumSil(veri);
                            });
                          },
                          child: Stack(
                            children: [
                              Container(
                                height: yukseklik / 5.2,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Row(
                                  children: [
                                    veri['ProfilFoto'] == null
                                        ? const CircleAvatar(
                                            maxRadius: 20,
                                            backgroundColor: Colors.transparent,
                                            backgroundImage:
                                                AssetImage("assets/avatar.png"),
                                          )
                                        : CircleAvatar(
                                            maxRadius: 20,
                                            backgroundColor: Colors.transparent,
                                            backgroundImage: NetworkImage(
                                                veri['ProfilFoto']),
                                          ),
                                    SizedBox(
                                      width: genislik / 1.3,
                                      height: yukseklik / 6,

                                      child: SingleChildScrollView(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              veri['AdSoyad'],
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(height: 5),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 5),
                                              child: Text(
                                                veri['Detay'],
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.black),
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
                                          padding: const EdgeInsets.only(
                                              right: 10, top: 5),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              veri['Fotograf'] == null
                                                  ? const Text('')
                                                  : GestureDetector(
                                                      onTap: () {
                                                        olanFotoyuGoster(veri);
                                                      },
                                                      child: const Icon(Icons
                                                          .perm_media_outlined)),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    yorumlariGoster(veri);
                                                  });
                                                },
                                                child: const Icon(
                                                  Icons.chat_bubble_outline,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              veri["Begenme"]
                                                  ? GestureDetector(
                                                onTap: (){

                                                },
                                                    child: const Icon(
                                                        Icons.favorite,
                                                        color: Colors.red,
                                                      ),
                                                  )
                                                  : const Icon(
                                                      Icons
                                                          .favorite_border_outlined,
                                                    ),
                                              const SizedBox(
                                                height: 2,
                                              ),
                                              Icon(
                                                Icons.star,
                                                color: MyColors().sarirenk,
                                              ),
                                              Text(
                                                veri['Puanlama'],
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
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
                          ));
                    },
                  ),
                );
              } else {
                return Container();
              }
            }));
  }

  sikayetSilindi() {
    const snackBar = SnackBar(
        content: Text(
          "Şikayetiniz Silindi",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  sikayetSil(DocumentSnapshot documentSnapshot) {
    FirebaseFirestore.instance
        .collection('Sikayetlerim')
        .doc(documentSnapshot.id)
        .delete();
  }

  Future yorumSil(DocumentSnapshot documentSnapshot) async {
    var sorgu = await FirebaseFirestore.instance
        .collection("Yorumlar")
        .where("SikayetId", isEqualTo: documentSnapshot.id)
        .get();
    for (var doc in sorgu.docs) {
      await doc.reference.delete();
    }
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
  Future yorumlariGoster(DocumentSnapshot documentSnapshot) async {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Column(
            children: [
              Container(
                height: 40,
                color: MyColors().sarirenk
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset("assets/yorumYok.png"),
                            const Text(
                              "Henüz Yorum Yapılmamış",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            )
                          ],
                        );
                      }
                      return SizedBox(
                        height: yukseklik / 2.2,
                        child: ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot tumyorum =
                                snapshot.data!.docs[index];
                            return SingleChildScrollView(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 5, top: 30),
                                child: Row(
                                  children: [
                                    tumyorum['ProfilFoto'] == null
                                        ? const CircleAvatar(
                                            maxRadius: 20,
                                            backgroundColor: Colors.transparent,
                                            backgroundImage:
                                                AssetImage("assets/avatar.png"),
                                          )
                                        : CircleAvatar(
                                            maxRadius: 20,
                                            backgroundColor: Colors.transparent,
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
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(height: 5),
                                            Padding(
                                              padding: const EdgeInsets.only(
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
                                        tumyorum["Begenme"]
                                            ? const Icon(
                                                Icons.favorite,
                                                color: Colors.red,
                                              )
                                            : const Icon(
                                                Icons.favorite_border_outlined,
                                              ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }
                    return Container();
                  }),
            ],
          );
        });
  }
}
