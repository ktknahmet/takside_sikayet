import 'package:email_auth/email_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taksiapp/models/Auth_model.dart';
import 'package:taksiapp/models/colors.dart';
import 'package:taksiapp/models/database_model.dart';

class Uyeolscreen extends StatefulWidget {
  const Uyeolscreen({Key? key}) : super(key: key);

  @override
  _UyeolscreenState createState() => _UyeolscreenState();
}

class _UyeolscreenState extends State<Uyeolscreen> {
  AuthModel? _auth;
  DatabaseModel database = DatabaseModel();
  bool verdigimBilgiler = false;
  bool sifregoster = true;
  bool sifregoster2 = true;
  double genislik = 0;
  double yukseklik = 0;
  var tfisim = GlobalKey<FormState>();
  var tfemail = GlobalKey<FormState>();
  var tfsifre = GlobalKey<FormState>();
  var tfsifre2 = GlobalKey<FormState>();
  var tftelefon = GlobalKey<FormState>();
  var tfililce = GlobalKey<FormState>();
  var tfdogrulama = TextEditingController();
  String? isim;
  String? email;
  String? sifre;
  String? sifre2;
  String? telefon;
  String? ililce;
  String? dogrulamaKodu;
  EmailAuth? emailAuth;

  @override
  void initState() {
    emailAuth = EmailAuth(
      sessionName: "Doğrulama Kodunuz",
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var ekranBilgisi = MediaQuery.of(context);
    genislik = ekranBilgisi.size.width;
    yukseklik = ekranBilgisi.size.height;
    _auth = Provider.of<AuthModel>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            formisim(),
            const SizedBox(
              height: 10,
            ),
            formemail(),
            const SizedBox(
              height: 10,
            ),
            formtelefon(),
            const SizedBox(
              height: 10,
            ),
            formsifre(),
            const SizedBox(
              height: 10,
            ),
            formsifre2(),
            const SizedBox(
              height: 10,
            ),
            formililce(),
            const SizedBox(
              height: 20,
            ),
            bilgileriDogrula(),
            const SizedBox(
              height: 10,
            ),
            uyelikTamamla(),
          ],
        ),
      ),
    );
  }

  CheckboxListTile bilgileriDogrula() {
    return CheckboxListTile(
      activeColor: MyColors().sarirenk,
      title: const Text("Verdiğim bilgilerin doğru olduğunu "
          "ve uygulamayı kötüye kullanmayacağıma dair teyit ederim."),
      value: verdigimBilgiler,
      controlAffinity: ListTileControlAffinity.leading,
      onChanged: (bool? veri) {
        setState(() {
          verdigimBilgiler = veri!;
        });
      },
    );
  }

  SizedBox uyelikTamamla() {
    return SizedBox(
      width: genislik / 1.5,
      height: yukseklik / 12,
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
          'Üyeliğimi Tamamla',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        onPressed: () async {
          uyeKayitol();
        },
      ),
    );
  }

  Padding formisim() {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30),
      child: Form(
        key: tfisim,
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
            hintText: 'İsim Soyisim',
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return '*Zorunlu Alan';
            }
            return null;
          },
          onSaved: (value) {
            isim = value;
          },
        ),
      ),
    );
  }

  Padding formemail() {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30),
      child: Form(
        key: tfemail,
        child: TextFormField(
          cursorColor: MyColors().sarirenk,
          keyboardType: TextInputType.emailAddress,
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
            hintText: 'Email',
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return '*Zorunlu Alan';
            }
            if (!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                .hasMatch(value.trim())) {
              return 'Lütfen Geçerli Mail Adresi Girin';
            }
            return null;
          },
          onSaved: (value) {
            email = value!.trim();
          },
        ),
      ),
    );
  }

  Padding formtelefon() {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30),
      child: Form(
        key: tftelefon,
        child: TextFormField(
          cursorColor: MyColors().sarirenk,
          keyboardType: TextInputType.phone,
          maxLength: 11,
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
            hintText: 'Telefon No',
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return '*Zorunlu Alan';
            }
            if (value.length < 11) {
              return 'Telefon Numarası 11 hane olmalıdır';
            }

            if (!RegExp(r'^(?:[0][1-9])?[0-9]{11}$').hasMatch(value.trim())) {
              return 'Lütfen Geçerli Telefon Numarası Giriniz';
            }
            return null;
          },
          onSaved: (value) {
            telefon = value!.trim();
          },
        ),
      ),
    );
  }

  Padding formsifre() {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30),
      child: Form(
        key: tfsifre,
        child: TextFormField(
          cursorColor: MyColors().sarirenk,
          keyboardType: TextInputType.text,
          textAlign: TextAlign.center,
          obscureText: sifregoster,
          decoration: InputDecoration(
            suffixIcon: IconButton(
              icon: Icon(sifregoster ? Icons.visibility_off : Icons.visibility),
              color: MyColors().sarirenk,
              onPressed: () {
                setState(() {
                  sifregoster = !sifregoster;
                });
              },
            ),
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
            hintText: 'Parola',
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return '*Zorunlu Alan';
            }
            if (value.length < 6) {
              return 'Parola 6 Haneden Küçük Olamaz';
            }
            return null;
          },
          onSaved: (value) {
            sifre = value!.trim();
          },
        ),
      ),
    );
  }

  Padding formsifre2() {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30),
      child: Form(
        key: tfsifre2,
        child: TextFormField(
          cursorColor: MyColors().sarirenk,
          obscureText: sifregoster2,
          keyboardType: TextInputType.text,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            suffixIcon: IconButton(
              icon:
              Icon(sifregoster2 ? Icons.visibility_off : Icons.visibility),
              color: MyColors().sarirenk,
              onPressed: () {
                setState(() {
                  sifregoster2 = !sifregoster2;
                });
              },
            ),
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
            hintText: 'Parolayı Tekrar Giriniz',
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return '*Zorunlu Alan';
            }
            if (value.length < 6) {
              return 'Parola 6 Haneden Küçük Olamaz ';
            }
            if (sifre != sifre2) {
              return 'HATA!!  Parolalar Aynı Değil';
            }
            return null;
          },
          onSaved: (value) {
            sifre2 = value!.trim();
          },
        ),
      ),
    );
  }

  Padding formililce() {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30),
      child: Form(
        key: tfililce,
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
            hintText: 'İkamet Edilen Şehir/İlçe',
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return '*Zorunlu Alan';
            }

            return null;
          },
          onSaved: (value) {
            ililce = value!.trim();
          },
        ),
      ),
    );
  }

  void uyeKayitol() async {
    tfisim.currentState!.validate();
    tfemail.currentState!.validate();
    tftelefon.currentState!.validate();
    tfsifre.currentState!.validate();
    tfsifre2.currentState!.validate();
    tfililce.currentState!.validate();

    tfisim.currentState!.save();
    tfemail.currentState!.save();
    tftelefon.currentState!.save();
    tfsifre.currentState!.save();
    tfsifre2.currentState!.save();
    tfililce.currentState!.save();

    if (isim!.isEmpty ||
        email!.isEmpty ||
        telefon!.isEmpty ||
        sifre!.isEmpty ||
        sifre2!.isEmpty ||
        ililce!.isEmpty ||
        verdigimBilgiler != true) {
      const snackBar = SnackBar(
        content: Text(
          "Lütfen Tüm Bilgileri Eksiksiz Doldurun!!",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (builder) {
            return Container(
              height: yukseklik / 14,
              color: MyColors().sarirenk,
              child: Padding(
                padding: const EdgeInsets.only(left: 10,right: 10),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        "Mail Adresinizi Doğrulayın..",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: ElevatedButton(
                        child: const Text(
                          "İptal Et",
                          style: TextStyle(color: Colors.black),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () async {
                          Navigator.of(context, rootNavigator: true).pop();
                        },
                      ),
                    ),
                    ElevatedButton(
                      child: const Text(
                        "Kodu Gönder",
                        style: TextStyle(color: Colors.black),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () async {
                        Navigator.of(context, rootNavigator: true).pop();
                        await sendOTP(email!);
                        await kodDogrula();
                      },
                    ),
                  ],
                ),
              ),
            );
          });
    }
  }
  Future sendOTP(String mail) async {
    var res = await emailAuth!.sendOtp(recipientMail: mail, otpLength: 6);
    if (res) {
    } else {
      showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (builder) {
            return Container(
              height: yukseklik / 14,
              color: MyColors().sarirenk,
              child: Padding(
                padding: const EdgeInsets.only(left: 10,right: 10),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        "Hata !! Doğrulama Kodu Gönderilemedi Tekrar Deneyiniz",
                        style:
                        TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ElevatedButton(
                        child: const Text(
                          "Tekrar Gönder",
                          style: TextStyle(color: Colors.black),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () async {
                          Navigator.of(context, rootNavigator: true).pop();
                          kodDogrula();
                          res;
                        }),
                  ],
                ),
              ),
            );
          });
    }
  }

  Future verifyOTP(String mail, String otpController) async {
    var res =
    emailAuth!.validateOtp(recipientMail: mail, userOtp: otpController);
    if (res) {
      await _auth!.signUpMailandPassword(
          isim!, email!, telefon!, sifre!, ililce!);
    } else {
      showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (builder) {
            return Container(
              height: yukseklik / 14,
              color: Colors.red,
              child: Padding(
                padding: const EdgeInsets.only(left: 10,right: 10),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        "Girdiğiniz Kod Hatalıdır !!",
                        style:
                        TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Wrap(
                      spacing: 20,
                      children: [
                        ElevatedButton(
                            child: const Text(
                              "İpatal Et",
                              style: TextStyle(color: Colors.black),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true).pop();
                            }),
                        ElevatedButton(
                            child: const Text(
                              "Tekrar Gönder",
                              style: TextStyle(color: Colors.black),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true).pop();
                              tfdogrulama.clear();
                              sendOTP(email!);
                              kodDogrula();
                            }),
                      ],
                    )
                  ],
                ),
              ),
            );
          });
    }
  }

  Future kodDogrula() async {
    AlertDialog alert = AlertDialog(
      title: Text("$email Adresinizi Doğrulayın"),
      content: TextField(
        controller: tfdogrulama,
        keyboardType: TextInputType.phone,
        cursorColor: MyColors().sarirenk,
        decoration: const InputDecoration(
          labelText: "Doğrulama Kodunu Giriniz",
          labelStyle: TextStyle(color: Colors.black),
        ),
        onChanged: (value) {
          setState(() {
            dogrulamaKodu = value.trim();
          });
        },
      ),
      actions: [
        ElevatedButton(
            child: const Text(
              "İpat Et",
              style: TextStyle(color: Colors.black),
            ),
            style: ElevatedButton.styleFrom(
              primary: MyColors().sarirenk,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
            }),
        ElevatedButton(
            child: const Text(
              "Doğrula",
              style: TextStyle(color: Colors.black),
            ),
            style: ElevatedButton.styleFrom(
              primary: MyColors().sarirenk,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              await verifyOTP(email!, tfdogrulama.text);
            }),
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
