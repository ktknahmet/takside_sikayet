import 'package:flutter/material.dart';
import 'package:taksiapp/models/colors.dart';
import 'package:taksiapp/screen/login_screen.dart';
import 'package:taksiapp/screen/uyeolscreen.dart';

class Tabuyegiris extends StatefulWidget {
  const Tabuyegiris({Key? key}) : super(key: key);

  @override
  _TabuyegirisState createState() => _TabuyegirisState();
}

class _TabuyegirisState extends State<Tabuyegiris>
    with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: MyColors().sarirenk,
            title: const Text(
              "TAKSİDE ŞİKAYET!",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Column(children: [
              SizedBox(
                height: 40,
                child: TabBar(
                  controller: tabController,
                  indicatorColor: MyColors().sarirenk,
                  indicatorWeight: 2,
                  labelColor: Colors.black,
                  tabs: const [
                    Tab(
                      text: 'GİRİŞ YAP',
                    ),
                    Tab(
                      text: 'ÜYE OL',
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(controller: tabController, children: const [
                  Loginscreen(),
                  Uyeolscreen(),
                ]),
              ),
            ]),
          ),
        ));
  }
}
