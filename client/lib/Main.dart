import 'package:app_1riel/Telegram_Auth.dart';
import 'package:app_1riel/pages/product/stage/Product.dart';
import 'package:app_1riel/pages/product/stage/Search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'package:app_1riel/navigators/Routes.dart';
import 'package:app_1riel/themes/Theme_Data.dart';
import 'package:app_1riel/navigators/Main_Drawer.dart';
import 'package:app_1riel/pages/product/Product.dart';
import 'package:app_1riel/navigators/Main_Navigator.dart';

void main() {
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
      // home: Search_(), //
      // home: TelegramLoginScreen(),
      routes: Routes.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}
