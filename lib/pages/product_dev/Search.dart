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

  bool has_more = true;

  void load_more() async {
    if (!has_more) return;
    // Run in background without blocking UI
    Future.microtask(() async {
      try {
        final r = await dio.post(
          '/product/search', //
          data: FormData.fromMap({'q': controller_search.text, 'offset': data_all.length}),
        );

        if (r.data is List) {
          has_more = r.data.length >= 100;
        } else {
          has_more = false;
        }

        data_all.addAll(List<Map<String, dynamic>>.from(r.data));
        setState(() {});
      } catch (e) {
        // Handle error silently
      }
    });
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
            controller_listview.jumpTo(0);
            has_more = true;
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
              hintText: 'Search ...', //
              border: UnderlineInputBorder(),
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
              //   focus on text field
              FocusScope.of(context).requestFocus(FocusNode());
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
            itemCount: data_all.length + (has_more ? 1 : 0),
            itemBuilder: (c, i) {
              if (i == data_all.length) {
                load_more();
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
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
