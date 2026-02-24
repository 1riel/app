import 'package:app_1riel/navigators/Routes.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'package:app_1riel/Environment.dart';
import 'package:app_1riel/utilities/Debug.dart';
import 'package:app_1riel/themes/Theme_Data.dart';
import 'package:app_1riel/navigators/Main_Drawer.dart';

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
      theme: Theme_Data.get_theme(),
      home: const Product_Page(),
      routes: Routes.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}

class Product_Page extends StatefulWidget {
  const Product_Page({super.key});

  @override
  State<Product_Page> createState() => _Product_PageState();
}

class _Product_PageState extends State<Product_Page> {
  String VERSION = '0.0.0+0';

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    final info = await PackageInfo.fromPlatform();
    VERSION = '${info.version}+${info.buildNumber}';
    debug(VERSION);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Column(
          children: [
            Text('បញ្ជីទំនិញ'),
            Text(
              'Version: $VERSION',
              style: const TextStyle(fontSize: 12, color: Colors.blue, fontWeight: FontWeight.w500),
            ),
          ],
        ),

        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}), //
          SizedBox(width: 10),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            //
            Text('Home Page', style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      ),
      drawer: Main_Drawer(),
    );
  }
}
