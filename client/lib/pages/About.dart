import 'package:app_1riel/Environment.dart';
import 'package:flutter/material.dart';

import 'package:app_1riel/themes/Theme_Data.dart';
import 'package:app_1riel/navigators/Routes.dart';
import 'package:app_1riel/navigators/Main_Drawer.dart';

void main() {
  runApp(const About());
}

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: TITLE, //
      theme: Theme_Data.get_theme(),
      home: const About_Page(),
      routes: Routes.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}

class About_Page extends StatefulWidget {
  const About_Page({super.key});

  @override
  State<About_Page> createState() => _About_PageState();
}

class _About_PageState extends State<About_Page> {
  @override
  void initState() {
    super.initState();
    print('About Page Loaded');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("About")), //
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('About Page Content Here'), //
          ],
        ),
      ),
      drawer: const Main_Drawer(),
    );
  }
}
