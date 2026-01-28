import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'package:app_1riel/pages/product/Product.dart';
import 'package:app_1riel/themes/Theme_Data.dart';
import 'package:app_1riel/routes/Main_Drawer.dart';
import 'package:app_1riel/pages/driver/Driver.dart';
import 'package:app_1riel/routes/Routes.dart';
import 'package:app_1riel/pages/profile/Profile.dart';
import 'package:app_1riel/pages/store/Store.dart';

void main() {
  usePathUrlStrategy();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '1riel.com', //
      theme: Theme_Data.get_theme(), //
      home: const Main_Navigator_Page(), //
      debugShowCheckedModeBanner: false, //
    );
  }
}

class Main_Navigator_Page extends StatefulWidget {
  const Main_Navigator_Page({super.key, this.index = 0});

  final int index;

  @override
  State<Main_Navigator_Page> createState() => _Main_Navigator_PageState();
}

class _Main_Navigator_PageState extends State<Main_Navigator_Page> {
  late int _nav_index;

  final List<Widget> _nav_pages = [
    Product_Page(), //
    Store_Page(), //
    Driver_Page(), //
    Profile_Page(), //
  ];

  @override
  void initState() {
    super.initState();
    _nav_index = widget.index;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //
      body: IndexedStack(index: _nav_index, children: _nav_pages),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _nav_index,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.inventory_2_outlined), label: 'បញ្ជីទំនិញ'),
          BottomNavigationBarItem(icon: Icon(Icons.store_outlined), label: 'បញ្ជីហាង'),
          BottomNavigationBarItem(icon: Icon(Icons.drive_eta_outlined), label: 'បញ្ជីអ្នកដឹក'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'ប្រវត្តិរូប'),
        ],
        onTap: (index) {
          if (index == 0) {
            _nav_index = 0;
          } else if (index == 1) {
            _nav_index = 1;
          } else if (index == 2) {
            _nav_index = 2;
          } else if (index == 3) {
            _nav_index = 3;
          }
          Main_Drawer.close_drawer(context);
          setState(() {});
        },
      ),
    );
  }
}
