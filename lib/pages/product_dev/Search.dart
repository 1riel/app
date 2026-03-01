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
      baseUrl: HOST_API, //
      connectTimeout: Duration(seconds: 10), //
      sendTimeout: Duration(seconds: 10), //
      receiveTimeout: Duration(seconds: 10), //
    ),
  );

  Set tmp = {
    'a',
    'b',
    'c',
    'a', //
  };
  final Set<Map<String, dynamic>> setOfMaps = {
    {'id': 1, 'name': 'Alice'},
    {'id': 2, 'name': 'Bob'},
    // {'id': 2, 'name': 'Bob'},
  };

  @override
  void initState() {
    super.initState();

    setOfMaps.add({'id': 2, 'name': 'Bob'});

    print(setOfMaps);

    init();
  }

  List<Map<String, dynamic>> data_all = [];

  TextEditingController controller_search = TextEditingController();

  void init() async {
    await dio
        .post(
          '/product/search', //
          data: FormData.fromMap({
            'query': "", //
          }),
        )
        .then((r) {
          data_all = List<Map<String, dynamic>>.from(r.data);
          // print(data_all);
          setState(() {});
        })
        .catchError((e) {});
    setState(() {});
  }

  Timer? _debounce;

  // ! make it faster
  void on_search() async {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () async {
      await dio
          .post(
            '/product/search', //
            data: FormData.fromMap({
              'query': controller_search.text, //
            }),
          )
          .then((r) {
            data_all = List<Map<String, dynamic>>.from(r.data);
            // print(data_all);
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
        title: TextField(
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
      body: Padding(
        padding: const EdgeInsets.only(top: 0, bottom: 0, left: 0, right: 0),
        child: data_all.isEmpty
            ? Center(child: Text('No data found'))
            : ListView.builder(
                itemCount: data_all.length,
                itemBuilder: (c, i) {
                  return ListTile(
                    contentPadding: const EdgeInsets.only(left: 8, right: 8, top: 0, bottom: 0),
                    title: Row(
                      children: [
                        Text(data_all[i]['name']?.toString() ?? ''), //
                        Spacer(),
                        Text(data_all[i]['price']?.toString() ?? ''),
                      ],
                    ),
                    subtitle: Row(
                      children: [
                        Text(data_all[i]['description']?.toString() ?? ''), //
                        Spacer(),
                        Text(data_all[i]['description']?.toString() ?? ''), //
                      ],
                    ),
                    onTap: () {
                      //
                    },
                  );
                },
              ), //
      ),
    );
  }
}
