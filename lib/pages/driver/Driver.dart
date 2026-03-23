import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'package:app_1riel/navigators/Routes.dart';
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
      home: const Driver_Page(),
      routes: Routes.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}

class Driver_Page extends StatefulWidget {
  const Driver_Page({super.key});

  @override
  State<Driver_Page> createState() => _Driver_PageState();
}

class _Driver_PageState extends State<Driver_Page> {
  @override
  void initState() {
    super.initState();
    print('Driver Page Loaded');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Driver Page"), //
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}), //
          SizedBox(width: 10),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('This is the Driver Page'), //
          ],
        ),
      ),

      drawer: const Main_Drawer(),
    );
  }
}
