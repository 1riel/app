import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'package:app_1riel/routes/Routes.dart';
import 'package:app_1riel/themes/Theme_Data.dart';
import 'package:app_1riel/routes/Main_Drawer.dart';
import 'package:app_1riel/pages/product/Product.dart';
import 'package:app_1riel/routes/Main_Navigator.dart';

void main() {
  usePathUrlStrategy();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '1riel.com',
      theme: Theme_Data.get_theme(),
      home: Main_Navigator_Page(index: 3), //
      routes: Routes.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}
