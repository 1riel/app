import 'package:app_1riel/navigators/Routes.dart';
import 'package:dio/dio.dart';
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
      title: TITLE, //
      theme: Theme_Data.get_theme(),
      home: const Product_Dev(),
      routes: Routes.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}

class Product_Dev extends StatefulWidget {
  const Product_Dev({super.key});

  @override
  State<Product_Dev> createState() => _Product_DevState();
}

class _Product_DevState extends State<Product_Dev> {
  List<Map<String, dynamic>> all_data = [];
  List<Map<String, dynamic>> search_data = [];

  bool is_edit = false;
  bool is_search = false;
  TextEditingController controller_search = TextEditingController();

  final Dio dio = Dio(
    BaseOptions(
      baseUrl: HOST_API, //
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

  void init() async {
    await dio
        .post(
          '/product/read', //
          data: FormData.fromMap({}),
        )
        .then((r) {
          //   debug('Credential Data: ${r.data}');

          all_data = List<Map<String, dynamic>>.from(r.data);
          search_data = all_data;

          //   debug(search_data);
          print(search_data[0]['image_1']);

          setState(() {});
        })
        .catchError((e) {});

    setState(() {});
  }

  // ! make it slower
  void on_search(String query) {
    search_data = all_data.where((item) => item['name']?.toLowerCase().contains(query.toLowerCase()) == true || item['description']?.toLowerCase().contains(query.toLowerCase()) == true).toList();
    setState(() {});
  }

  void on_reorder(int old_index, int new_index) {
    if (old_index < new_index) {
      new_index -= 1;
    }
    final item = search_data.removeAt(old_index);
    search_data.insert(new_index, item);
    setState(() {});
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
                onChanged: (value) {
                  on_search(value);
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
                on_search('');
              }
              setState(() {});
            },
          ), //
        ],
      ),

      body: Center(
        child: SizedBox(
          width: 600,
          child: ReorderableListView.builder(
            itemCount: search_data.length,
            // itemCount: 3,
            onReorder: on_reorder,
            buildDefaultDragHandles: false,
            itemBuilder: (context, index) {
              final item = search_data[index];
              return ListTile(
                key: ValueKey(item['order']),
                minVerticalPadding: 2,
                contentPadding: const EdgeInsets.only(left: 0, right: 8, top: 0, bottom: 0),
                title: SizedBox(
                  height: 100,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(width: 4),

                      if (is_edit && !is_search)
                        ReorderableDragStartListener(
                          index: index,
                          child: InkResponse(
                            radius: 0,
                            child: const SizedBox(
                              height: 100, //
                              width: 40,
                              child: Icon(Icons.drag_indicator, color: Colors.blue),
                            ),
                          ),
                        ),

                      // ! make image smaller with fastapi
                      Container(
                        height: 100,
                        color: Colors.grey[300],
                        child: item['image_1'] != null
                            ? Image.network(
                                '$MINIO/public/${item['image_1']}',
                                fit: BoxFit.cover,
                                errorBuilder: (_, _, _) {
                                  return const Icon(Icons.broken_image, size: 100, color: Colors.grey);
                                },
                              )
                            : const Icon(Icons.image_not_supported, color: Colors.grey, size: 100),
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
                                        "${item['name'] ?? "N/A"}", //
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "${item['description'] ?? "N/A"}",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                                      ),
                                    ],
                                  ),
                                ),

                                if (is_edit)
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    icon: const Icon(Icons.edit),
                                    onPressed: () {
                                      print("edit");
                                    },
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
                                      item['rating']?.toStringAsFixed(2) ?? "N/A", //
                                      //   "${item['rating'] != null ? item['rating'].toStringAsFixed(2) : "0"}", //
                                      style: const TextStyle(fontSize: 16, color: Colors.orange),
                                    ),
                                    const Icon(Icons.star, color: Colors.orange, size: 18),
                                  ],
                                ),
                                Flexible(
                                  child: Text(
                                    "${item['price'] ?? "N/A"} KHR",
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
                // delete
                onLongPress: !is_edit
                    ? null
                    : () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Delete ${item['name']}?"),
                              content: Text("Are you sure?"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    all_data.removeWhere((element) => element['order'] == item['order']);
                                    on_search(controller_search.text);
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("Delete", style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            );
                          },
                        );
                      },
              );
            },
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
                  print("add");

                  var data = {
                    'order': search_data.length, //
                    'name': 'New Product', //
                    'description': 'Description of new product', //
                    'image': "https://pub.1riel.com/public/assets/logo.png", //
                    'price': 0, //
                    'rating': 0.0,
                  };
                  all_data.add(data);

                  setState(() {});
                }, //
                child: const Icon(Icons.add),
              ),
          ],
        ),
      ),
    );
  }
}
