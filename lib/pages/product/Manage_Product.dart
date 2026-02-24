import 'package:app_1riel/navigators/Routes.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:app_1riel/pages/product/Update_Product.dart';
import 'package:app_1riel/Environment.dart';
import 'package:app_1riel/utilities/Debug.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

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
      home: const Manage_Product_Page(),
      routes: Routes.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}

class Manage_Product_Page extends StatefulWidget {
  const Manage_Product_Page({super.key});

  @override
  State<Manage_Product_Page> createState() => _Manage_Product_PageState();
}

class _Manage_Product_PageState extends State<Manage_Product_Page> {
  //
  dynamic products = [];
  dynamic search_products = [];

  final Dio dio = Dio(
    BaseOptions(
      baseUrl: HOST_API, //
      connectTimeout: Duration(seconds: 10), //
      sendTimeout: Duration(seconds: 10), //
      receiveTimeout: Duration(seconds: 10), //
    ),
  );

  void init() async {
    dio
        .post(
          "/product/read", //
          data: FormData.fromMap({}),
        )
        .then((r) {
          // debug(r.data);
          products = r.data;
          if (mounted) {
            setState(() {});
          }
        })
        .catchError((e) {
          debug("Error");
        });
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("គ្រប់គ្រងផលិតផល"),
        actions: [
          // IconButton(icon: const Icon(Icons.barcode_reader), onPressed: () {}), //
          // IconButton(icon: const Icon(Icons.camera), onPressed: () {}), //
          IconButton(icon: const Icon(Icons.search), onPressed: () {}), //
          SizedBox(width: 10),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: SizedBox(
            width: 600,
            child: ListView.builder(
              itemCount: products.length + 1,
              itemBuilder: (context, index) {
                if (index == products.length) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () async {
                          await dio
                              .post('/product/create', data: FormData.fromMap({}))
                              .then((r) {
                                init(); //
                                show_snackbar(context: context, message: "Added Succeed", color: Colors.green);
                              })
                              .catchError((e) {
                                debug(e);
                                show_snackbar(context: context, message: "Added Fail", color: Colors.red);
                              });
                          //
                        },
                        label: Text("បន្ថែម"),
                        icon: Icon(Icons.add),
                      ),
                    ],
                  );
                }

                return InkWell(
                  // delete on long press
                  onLongPress: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text("Delete ${products[index]['name'] ?? ''}"),
                        content: const Text("Are you sure you want to delete this product?"),
                        actions: [
                          TextButton(
                            child: const Text("Cancel"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: const Text("Delete", style: TextStyle(color: Colors.red)),
                            onPressed: () async {
                              dio
                                  .post(
                                    '/product/delete', //
                                    data: FormData.fromMap({
                                      'id': products[index]['_id']['\$oid'], //
                                    }),
                                  )
                                  .then((r) {
                                    debug(r.data);
                                    init(); //
                                    show_snackbar(context: context, message: "Delete Succeed", color: Colors.green);
                                  })
                                  .catchError((e) {
                                    debug("Error: $e");
                                    show_snackbar(context: context, message: "Delete Fail", color: Colors.red);
                                  });

                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 48),
                      Image.asset('assets/logo.png', fit: BoxFit.cover, width: 40, height: 40),
                      SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${products[index]['name'] ?? ''}", style: TextStyle(fontWeight: FontWeight.bold)),
                          Text("${products[index]['description'] ?? ''}"),
                        ],
                      ),
                      Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // Text("*****"), // todo: add rating later
                          Text("${products[index]['price'] ?? '0'} រៀល / ${products[index]['unit_price'] ?? 'Piece'}", style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      // edit button
                      IconButton(
                        onPressed: () {
                          Navigator.of(context)
                              .push(
                                MaterialPageRoute(
                                  builder: (context) => Update_Product_Page(
                                    input: {
                                      'name': products[index]['name'] ?? '',
                                      'description': products[index]['description'] ?? '',
                                      'price': (products[index]['price'] ?? '').toString(),
                                      'unit_price': products[index]['unit_price'] ?? '', //
                                    },
                                  ),
                                ),
                              )
                              .then((output) async {
                                debug("Update Output: $output");
                                if (output != null) {
                                  await dio
                                      .post(
                                        '/product/update', //
                                        data: FormData.fromMap({
                                          'id': products[index]['_id']['\$oid'], //
                                          'name': output['name'],
                                          'description': output['description'],
                                          'price': output['price'],
                                          'unit_price': output['unit_price'], //
                                        }),
                                      )
                                      .then((r) {
                                        init(); //
                                        show_snackbar(context: context, message: "Update Succeed", color: Colors.green);
                                      })
                                      .catchError((e) {
                                        show_snackbar(context: context, message: "Update Fail", color: Colors.red);
                                      });
                                }
                              });
                        }, //
                        icon: Icon(Icons.edit),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

void show_snackbar({
  required BuildContext context, //
  required String message, //
  required Color color, //
}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.info_outline, color: Colors.white),
            SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: color,
      ),
    );
}
