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
      title: '1riel.com', //
      theme: Theme_Data.get_theme(),
      routes: Routes.routes,
      home: const Update_Profile_Page(
        title: 'Title', //
        input: 'Input',
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Update_Profile_Page extends StatefulWidget {
  const Update_Profile_Page({
    super.key,
    required this.title, //
    required this.input, //
    this.keyboard_type = TextInputType.text,
  });

  final String title;
  final String input;
  final TextInputType keyboard_type;

  @override
  State<Update_Profile_Page> createState() => _Update_Profile_PageState();
}

class _Update_Profile_PageState extends State<Update_Profile_Page> {
  //
  TextEditingController controller_input = TextEditingController();

  @override
  void initState() {
    super.initState();

    controller_input.text = widget.input;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text('Update ${widget.title}')),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(
            child: SizedBox(
              width: 600,
              child: Column(
                children: [
                  TextField(
                    controller: controller_input,
                    autofocus: true,
                    decoration: InputDecoration(labelText: widget.title), //
                    keyboardType: widget.keyboard_type,
                    onSubmitted: (_) => Navigator.of(context).pop(controller_input.text),
                  ),

                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text('Cancel'), //
                      ),
                      OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(controller_input.text),
                        child: Text('Save'), //
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
