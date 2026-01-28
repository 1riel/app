import 'package:app_1riel/routes/Routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'package:app_1riel/routes/Main_Drawer.dart';
import 'package:app_1riel/themes/Theme_Data.dart';

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
      home: const Store_Page(),
      routes: Routes.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}

class Store_Page extends StatefulWidget {
  const Store_Page({super.key});

  @override
  State<Store_Page> createState() => _Store_PageState();
}

class _Store_PageState extends State<Store_Page> {
  @override
  void initState() {
    super.initState();
    print('Store Page Loaded');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("បញ្ចីហាង"),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}), //
          SizedBox(width: 10),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('សូមចុះឈ្មោះដើម្បីបង្កើតហាង'), //
          ],
        ),
      ),

      drawer: const Main_Drawer(),
    );
  }
}
