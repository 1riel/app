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

  List<Map<String, dynamic>> all_data = [
    {'order': 0, 'name': 'Product 1 is the best product best product best product best product best product best product', 'description': 'Product 1 is the best product best product best product best product best product best product', 'image': null, 'price': 1000, 'rating': 4.5},
    {'order': 1, 'name': 'Name #1', 'description': 'Position 2', 'image': null, 'price': 2000, 'rating': 4.0},
    {'order': 2, 'name': 'Product 3', 'description': 'Position 3', 'image': null, 'price': 3000, 'rating': 5.0},
  ];
  late List<Map<String, dynamic>> search_data = all_data;

  bool is_edit = false;
  bool is_search = false;
  TextEditingController c_search = TextEditingController();

  void on_search(String query) {
    search_data = all_data.where((item) => item['name']?.toLowerCase().contains(query.toLowerCase()) == true || item['description']?.toLowerCase().contains(query.toLowerCase()) == true).toList();
    setState(() {});
  }

  void on_edit(int index) {
    // edit product at index
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
        title: is_search
            ? TextField(
                controller: c_search,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search ...',
                  border: InputBorder.none, //
                ),
                onChanged: (value) {
                  on_search(value);
                },
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Product'),
                  Text(
                    'Version: $VERSION',
                    style: const TextStyle(fontSize: 12, color: Colors.blue, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
        actionsPadding: EdgeInsets.only(right: 10),

        actions: [
          IconButton(
            icon: is_search ? Icon(Icons.close) : Icon(Icons.search),
            onPressed: () {
              setState(() {
                is_search = !is_search;
              });
            },
          ), //
        ],
      ),

      body: Center(
        child: SizedBox(
          width: 600,
          child: ReorderableListView.builder(
            itemCount: search_data.length,
            onReorder: on_reorder,
            buildDefaultDragHandles: false,
            itemBuilder: (context, index) {
              final item = search_data[index];
              return ListTile(
                key: ValueKey(item['order']),
                contentPadding: const EdgeInsets.only(left: 8, right: 8),
                leading: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (is_edit) ReorderableDragStartListener(index: index, child: Icon(Icons.drag_indicator)), //
                    if (is_edit) SizedBox(width: 8),
                    Image.network('$MINIO/public/assets/logo.png', width: 50, height: 50, fit: BoxFit.contain), //
                  ],
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text(item['name'] ?? '', overflow: TextOverflow.ellipsis)),
                    Text(
                      '${item['price'] ?? 0.0} R',
                      style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
                    ), //
                  ],
                ),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text(item['description'] ?? '', overflow: TextOverflow.ellipsis)),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('${item['rating'] ?? 0.0}'),
                        SizedBox(width: 4),
                        Icon(Icons.thumb_up, color: Colors.blue, size: 16),
                      ],
                    ),
                  ],
                ),

                //
                trailing: is_edit
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(icon: Icon(Icons.edit), onPressed: () {}), //
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {},
                          ), //
                        ],
                      )
                    : null,
                // view details
                onTap: () {},
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
                onPressed: () {}, //
                child: const Icon(Icons.add),
              ),
          ],
        ),
      ),
    );
  }
}
