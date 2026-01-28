import 'package:app_1riel/routes/Routes.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'package:app_1riel/Environment.dart';
import 'package:app_1riel/utilities/Debug.dart';
import 'package:app_1riel/themes/Theme_Data.dart';
import 'package:app_1riel/routes/Main_Drawer.dart';

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
      routes: Routes.routes,
      home: const Update_Product_Page(
        input: {
          'name': 'Sample Product', //
          'description': 'This is a sample product description.', //
          'price': '1000', //
          'unit_price': 'Piece', //
        }, //
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Update_Product_Page extends StatefulWidget {
  const Update_Product_Page({super.key, required this.input});

  final dynamic input;

  @override
  State<Update_Product_Page> createState() => _Update_Product_PageState();
}

class _Update_Product_PageState extends State<Update_Product_Page> {
  //
  TextEditingController controller_name = TextEditingController();
  TextEditingController controller_description = TextEditingController();
  TextEditingController controller_price = TextEditingController();
  TextEditingController controller_unit_price = TextEditingController();

  @override
  void initState() {
    super.initState();

    controller_name.text = widget.input['name'] ?? '';
    controller_description.text = widget.input['description'] ?? '';
    controller_price.text = widget.input['price'] ?? '';
    controller_unit_price.text = widget.input['unit_price'] ?? '';

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text('Update Product Page')),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(
            child: SizedBox(
              width: 600,
              child: Column(
                children: [
                  SizedBox(
                    height: 200,
                    width: 200,
                    child: Placeholder(), // todo: image upload
                  ),
                  SizedBox(height: 8.0),
                  TextField(
                    controller: controller_name,
                    decoration: InputDecoration(labelText: 'Name'), //
                  ),
                  SizedBox(height: 8.0),
                  TextField(
                    controller: controller_description,
                    decoration: InputDecoration(labelText: 'Description'), //
                  ),
                  SizedBox(height: 8.0),
                  TextField(
                    controller: controller_price,
                    decoration: InputDecoration(labelText: 'Price'), //
                  ),
                  SizedBox(height: 8.0),
                  TextField(
                    controller: controller_unit_price,
                    decoration: InputDecoration(labelText: 'Unit Price'), //
                  ),

                  SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          // Handle update action
                          Navigator.of(context).pop();
                        },
                        child: Text('Cancel'),
                      ),
                      OutlinedButton(
                        onPressed: () {
                          // Handle update action

                          dynamic output = {
                            'name': controller_name.text,
                            'description': controller_description.text,
                            'price': controller_price.text,
                            'unit_price': controller_unit_price.text, //
                          };

                          Navigator.of(context).pop(output);
                        },
                        child: Text('Update'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
