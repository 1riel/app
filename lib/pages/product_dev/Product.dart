import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'package:app_1riel/Environment.dart';
import 'package:app_1riel/navigators/Routes.dart';
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
      home: const Product_(),
      routes: Routes.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}

class Product_ extends StatefulWidget {
  const Product_({super.key});

  @override
  State<Product_> createState() => _Product_State();
}

class _Product_State extends State<Product_> {
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

  bool is_edit = false;

  bool is_search = false;
  List<Map<String, dynamic>> data_all = [];
  TextEditingController controller_search = TextEditingController();
  ScrollController controller_listview = ScrollController();

  int limit = 100;

  void init() async {
    await dio
        .post(
          '/product/read', //
          data: FormData.fromMap({}),
        )
        .then((r) {
          data_all = List<Map<String, dynamic>>.from(r.data);
          // print(data_all[0]['images'][0]);
          print('$MINIO_PUBLIC/${data_all[0]['image_1']}');

          setState(() {});
        })
        .catchError((e) {});
    setState(() {});
  }

  // ! make it faster
  Timer? _debounce;
  void on_search() async {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 200), () async {
      await dio
          .post(
            '/product/read', //
            data: FormData.fromMap({
              'query': controller_search.text, //
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

  bool has_more = true;
  void load_more() async {
    if (!has_more) return;
    dio
        .post(
          '/product/read', //
          data: FormData.fromMap({
            'query': controller_search.text, //
            'offset': data_all.length,
          }),
        )
        .then((r) {
          if (r.data is List) {
            has_more = r.data.length >= limit;
          } else {
            has_more = false;
          }

          data_all.addAll(List<Map<String, dynamic>>.from(r.data));
          setState(() {});
        })
        .catchError((e) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: !is_search
            ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Product'), //
                ],
              )
            : TextField(
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
        actionsPadding: EdgeInsets.only(right: 10),

        actions: [
          IconButton(
            icon: is_search ? Icon(Icons.close) : Icon(Icons.search),
            onPressed: () {
              is_search = !is_search;
              if (!is_search) {
                controller_search.clear();
                init();
              }
              setState(() {});
            },
          ), //
        ],
      ),

      body: Center(
        child: SizedBox(
          width: 600,
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: controller_listview,
                  itemCount: data_all.length + 1,
                  itemBuilder: (context, i) {
                    if (i == data_all.length) {
                      if (!has_more) {
                        return Padding(
                          padding: const EdgeInsets.all(16),
                          child: Center(child: Text("Loaded ${data_all.length}/${data_all.length} items")),
                        );
                      }

                      load_more();

                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    return ListTile(
                      key: ValueKey(data_all[i]['order']),
                      minVerticalPadding: 2,
                      contentPadding: const EdgeInsets.only(left: 0, right: 8, top: 0, bottom: 0),
                      title: SizedBox(
                        height: 100,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(width: 4),

                            // ? good
                            SizedBox(
                              height: 100, //
                              width: 100, //
                              child:
                                  data_all[i]['image_1'] !=
                                      null //
                                  ? Image.network('$MINIO_PUBLIC/128/${data_all[i]['image_1']}', fit: BoxFit.contain)
                                  : const Icon(Icons.image_not_supported),
                            ),

                            const SizedBox(width: 4),

                            Expanded(
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${i + 1}. ${data_all[i]['name'] ?? "N/A"}", //
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              "${data_all[i]['description'] ?? "N/A"}",
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),

                                  const Spacer(),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            data_all[i]['rating']?.toStringAsFixed(2) ?? "N/A", //
                                            //   "${data_search[index]['rating'] != null ? data_search[index]['rating'].toStringAsFixed(2) : "0"}", //
                                            style: const TextStyle(fontSize: 16, color: Colors.orange),
                                          ),
                                          const Icon(Icons.star, color: Colors.orange, size: 18),
                                        ],
                                      ),
                                      Flexible(
                                        child: Text(
                                          "${data_all[i]['price'] ?? "N/A"} KHR",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 16, //
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      onTap: () {
                        debug("view");
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      drawer: Main_Drawer(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FloatingActionButton(
              child: is_edit ? Icon(Icons.close) : Icon(Icons.edit),
              onPressed: () {
                is_edit = !is_edit;
                setState(() {});
              }, //
            ),

            if (is_edit)
              FloatingActionButton(
                onPressed: () {
                  //   print("add");

                  //   var data = {
                  //     'order': search_data.length, //
                  //     'name': 'New Product', //
                  //     'description': 'Description of new product', //
                  //     'image': "https://pub.1riel.com/public/assets/logo.png", //
                  //     'price': 0, //
                  //     'rating': 0.0,
                  //   };
                  //   all_data.add(data);

                  //   setState(() {});
                }, //
                child: const Icon(Icons.add),
              ),
          ],
        ),
      ),
    );
  }
}
