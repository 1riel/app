import 'package:app_1riel/navigators/Routes.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

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
      routes: Routes.routes,
      home: const View_Product_(
        input: {
          'name': 'Apple', //
          'description': 'This is a sample product description.', //
          'price': '1000', //
          'rating': '4.5', //
        }, //
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class View_Product_ extends StatefulWidget {
  const View_Product_({super.key, required this.input});

  final dynamic input;

  @override
  State<View_Product_> createState() => _View_Product_State();
}

class _View_Product_State extends State<View_Product_> {
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
      appBar: AppBar(title: Text('${widget.input['name'] ?? 'N/A'}')),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(
            child: SizedBox(
              width: 600,
              child: Column(
                children: [
                  SizedBox(height: 200, width: 200, child: Placeholder()),

                  SizedBox(height: 8.0),

                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(right: 8),
                          child: SizedBox(height: 100, width: 100, child: Placeholder()),
                        );
                      },
                    ),
                  ),

                  SizedBox(height: 8.0),

                  // description
                  SizedBox(
                    height: 100, //
                    child: Text(
                      widget.input['description'] ?? '', //
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: null,
                    ),
                  ),

                  // price
                  Text('Price: ${widget.input['price'] ?? 'N/A'}'),

                  SizedBox(height: 8.0),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // like button
                      OutlinedButton.icon(
                        onPressed: () {
                          // Handle like action
                        },
                        icon: const Icon(Icons.thumb_up_outlined),
                        label: const Text('Like'),
                      ),

                      // rating
                      Text('Rating: ${widget.input['rating'] ?? 'N/A'}'),

                      // dislike button
                      OutlinedButton.icon(
                        onPressed: () {
                          // Handle dislike action
                        },
                        icon: const Icon(Icons.thumb_down_outlined),
                        label: const Text('Dislike'),
                      ),
                    ],
                  ),

                  SizedBox(height: 16.0),

                  const Text('Contact'),
                  const Text('Comments'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
