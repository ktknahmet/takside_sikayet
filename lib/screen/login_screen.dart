import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taksiapp/inApp/anasayfa.dart';
import 'package:taksiapp/models/Auth_model.dart';
import 'package:taksiapp/models/colors.dart';
import 'package:taksiapp/models/database_model.dart';


class Loginscreen extends StatefulWidget {
  const Loginscreen({Key? key}) : super(key: key);

  @override
  _LoginscreenState createState() => _LoginscreenState();
}

bool process = false;
DatabaseModel database = DatabaseModel();

class _LoginscreenState extends State<Loginscreen> {
  var emailKey = GlobalKey<FormState>();
  var sifreKey = GlobalKey<FormState>();
  bool parolagoster = true;
  String? emaill;
  String? sifree;
  AuthModel? user;
  double genislik = 0;
  double yukseklik = 0;

  @override
  Widget build(BuildContext context) {
    var ekranBilgisi = MediaQuery.of(context);
    genislik = ekranBilgisi.size.width;
    yukseklik = ekranBilgisi.size.height;
    user = Provider.of<AuthModel>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Flex(
          direction: Axis.horizontal,
          children: [
            Expanded(
              child: Column(
                children: [
                  Image.asset(
                    "assets/taksii.png",
                    height: yukseklik / 7,
                  ),
                  googleLogin(),

                  const SizedBox(
                    height: 10,
                  ),
                 facebookLogin(),

                  const SizedBox(
                    height: 5,
                  ),
                  const Text(
                    "ya da",
                    style: TextStyle(fontSize: 18),
                  ),
                  const Text(
                    "Kayıtlı e-posta adresinizle giriş yapın",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                    emailForm(),
                  const SizedBox(
                    height: 10,
                  ),
                  parolaForm(),
                  const SizedBox(
                    height: 20,
                  ),
                  parolamiUnuttum(),
                  const SizedBox(
                    height: 20,
                  ),
                  girisYap(),
                ],
              ),
            ),
          ],

        ),
        ),

    );
  }
  InkWell googleLogin(){
    return InkWell(
      splashColor: MyColors().sarirenk,
      onTap: signInGoogle,
      child: Container(
        width: genislik / 1.5,
        height: yukseklik / 13,
        decoration: BoxDecoration(
            border: Border.all(
              color: MyColors().sarirenk,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(40)),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Image.asset(
                "assets/google.png",
                height: 20,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                "Google",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            )
          ],
        ),
      ),
    );
  }
  InkWell facebookLogin(){
    return     InkWell(
      splashColor: MyColors().facebookButton,
      onTap: loginFacebook,
      child: Container(
        width: genislik / 1.5,
        height: yukseklik / 12,
        decoration: BoxDecoration(
            border: Border.all(
              color: MyColors().facebookButton,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(40)),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Image.asset(
                "assets/facebook.png",
                height: 30,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                "Facebook",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            )
          ],
        ),
      ),
    );
  }
  SizedBox emailForm(){
    return SizedBox(
      width: genislik/1.5,
      child: Form(
        key: emailKey,
        child: TextFormField(
          cursorColor: MyColors().sarirenk,
          keyboardType: TextInputType.emailAddress,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.mail_outline,
              color: MyColors().sarirenk,
            ),
            focusedBorder: OutlineInputBorder(
              borderSide:
              BorderSide(color: MyColors().sarirenk, width: 1.0),
              borderRadius: BorderRadius.circular(20),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide:
              BorderSide(color: MyColors().sarirenk, width: 1.0),
              borderRadius: BorderRadius.circular(20),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              borderSide: BorderSide(color: MyColors().sarirenk, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              borderSide: BorderSide(color: MyColors().sarirenk, width: 1),
            ),
            hintText: 'Email',
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return 'Boş Olamaz';
            }
            if (!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                .hasMatch(value.trim())) {
              return 'Lütfen Geçerli Mail Adresi Girin';
            }
            return null;
          },
          onSaved: (value) {
            emaill = value!.trim();
          },
        ),
      ),
    );
  }
  SizedBox parolaForm(){
    return SizedBox(
      width: genislik/1.5,
      child: Form(
        key: sifreKey,
        child: TextFormField(
          cursorColor: MyColors().sarirenk,
          keyboardType: TextInputType.text,
          textAlign: TextAlign.center,
          obscureText: parolagoster,
          decoration: InputDecoration(
            suffixIcon: IconButton(
              icon: Icon(
                  parolagoster ? Icons.visibility_off : Icons.visibility),
              color: MyColors().sarirenk,
              onPressed: () {
                setState(() {
                  parolagoster = !parolagoster;
                });
              },
            ),
            prefixIcon: Icon(
              Icons.lock_outlined,
              color: MyColors().sarirenk,
            ),
            focusedBorder: OutlineInputBorder(
              borderSide:
              BorderSide(color: MyColors().sarirenk, width: 1.0),
              borderRadius: BorderRadius.circular(20),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide:
              BorderSide(color: MyColors().sarirenk, width: 1.0),
              borderRadius: BorderRadius.circular(20),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              borderSide: BorderSide(color: MyColors().sarirenk, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              borderSide: BorderSide(color: MyColors().sarirenk, width: 1),
            ),
            hintText: 'Parola',
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return 'Boş Olamaz';
            }
            if (value.length < 6) {
              return 'Parola 6 Haneden Küçük Olamaz';
            }
            return null;
          },
          onSaved: (value) {
            sifree = value!.trim();
          },
        ),
      ),
    );
  }
  InkWell parolamiUnuttum() {
    return InkWell(
      onTap: resetPassword,
      child: SizedBox(
          width: genislik / 1.5,
          child: const Align(
            alignment: Alignment.centerRight,
            child: Text(
              "Parolamı unuttum ?",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          )),
    );
  }


  SizedBox girisYap() {
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
          'Giriş Yap',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        onPressed: () {
          mailsifreGirisYap();
        },
      ),
    );
  }


  void mailsifreGirisYap() async {
    emailKey.currentState!.validate();
    sifreKey.currentState!.validate();
    emailKey.currentState!.save();
    sifreKey.currentState!.save();

    if (emaill!.isNotEmpty && sifree!.isNotEmpty) {

      await user!.signInMailandPassword(emaill!, sifree!).then((value) {
        if (value.toString().contains("Hata")) {
          const snackBar = SnackBar(
            content: Text(
              "Kullanıcı Adınız Veya Şifreniz Hatalı !!",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.red,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const Anasayfa()));
        }
      });
    }
  }

  void loginFacebook() async {
    await user!.signInWithFacebook();
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => const Anasayfa()));
  }

  void signInGoogle() async {
    await user!.signInGoogle();
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => const Anasayfa()));
  }

  Future<void> resetPassword() async {
    emailKey.currentState!.validate();
    emailKey.currentState!.save();

    if (emaill!.isEmpty) {
      const snackBar = SnackBar(
        content: Text(
          "Parolanızı Sıfırlamak için Mail Adresinizi Girin !!",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
        ),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      final snackBar = SnackBar(
        content: Text(
          "$emaill Adresine Parolama Sıfırlama Bağlantısı Gönderildi",
          style: const TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),
        ),
        backgroundColor: MyColors().sarirenk,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      await user!.resetPassword(emaill!);
    }
  }
}
