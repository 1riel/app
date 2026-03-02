import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'package:app_1riel/navigators/Routes.dart';
import 'package:app_1riel/Environment.dart';
import 'package:app_1riel/utilities/Debug.dart';
import 'package:app_1riel/themes/Theme_Data.dart';
import 'package:app_1riel/navigators/Main_Drawer.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: TITLE, //
      theme: Theme_Data.get_theme(),
      home: const Search_(),
      routes: Routes.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}

class Search_ extends StatefulWidget {
  const Search_({super.key});

  @override
  State<Search_> createState() => _Search_State();
}

class _Search_State extends State<Search_> {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: API_HOST, //
      connectTimeout: Duration(seconds: 10), //
      sendTimeout: Duration(seconds: 10), //
      receiveTimeout: Duration(seconds: 10), //
    ),
  );

  @override
  void initState() {
    super.initState();
    init();
  }

  List<Map<String, dynamic>> data_all = [];

  TextEditingController controller_search = TextEditingController();
  ScrollController controller_listview = ScrollController();

  void init() async {
    await dio
        .post(
          '/product/search', //
          data: FormData.fromMap({
            'query': '', //
          }),
        )
        .then((r) {
          data_all = List<Map<String, dynamic>>.from(r.data);
          setState(() {});
        })
        .catchError((e) {});
    setState(() {});
  }

  Timer? _debounce;

  // ! make it faster
  void on_search() async {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 200), () async {
      await dio
          .post(
            '/product/search', //
            data: FormData.fromMap({
              'q': controller_search.text, //
            }),
          )
          .then((r) {
            data_all = List<Map<String, dynamic>>.from(r.data);
            // print(data_all);
            // move scroll to top
            controller_listview.jumpTo(0);
            setState(() {});
          })
          .catchError((e) {});
    });
    //
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: SizedBox(
          width: 600,
          child: TextField(
            controller: controller_search,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Search ...',
              border: InputBorder.none, //
            ),
            onChanged: (v) {
              on_search();
            },
          ),
        ),
        actionsPadding: EdgeInsets.only(right: 8),
        actions: [
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              controller_search.clear();
              on_search();
            },
          ),
        ],
      ), //
      body: Center(
        child: SizedBox(
          width: 600,
          child: ListView.builder(
            controller: controller_listview,
            itemCount: data_all.length,
            itemBuilder: (c, i) {
              return ListTile(
                contentPadding: const EdgeInsets.only(left: 8, right: 8, top: 0, bottom: 0),
                visualDensity: VisualDensity(vertical: -4),
                minVerticalPadding: 0,

                title: Row(
                  children: [
                    Text(data_all[i]['name']?.toString() ?? ''), //
                    Spacer(),
                    Text('${data_all[i]['price']?.toString() ?? ''} KHR'), //,
                  ],
                ),
                onTap: () {
                  //
                },
              );
            },
          ), //
        ), //
      ),
    );
  }
}
