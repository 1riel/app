import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'package:app_1riel/Environment.dart';
import 'package:app_1riel/utilities/Debug.dart';
import 'package:app_1riel/navigators/Routes.dart';
import 'package:app_1riel/themes/Theme_Data.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '1riel.com', //
      theme: Theme_Data.get_theme(),
      home: const Sign_In_Page(),
      routes: Routes.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}

class Sign_In_Page extends StatefulWidget {
  const Sign_In_Page({super.key});

  @override
  State<Sign_In_Page> createState() => _Sign_In_PageState();
}

class _Sign_In_PageState extends State<Sign_In_Page> {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: API_HOST, //
      connectTimeout: Duration(seconds: 10), //
      sendTimeout: Duration(seconds: 10), //
      receiveTimeout: Duration(seconds: 10), //
    ),
  );

  bool is_password_visible = false;

  final controller_username = TextEditingController();
  final controller_password = TextEditingController();

  final focus_username = FocusNode();
  final focus_password = FocusNode();

  FlutterSecureStorage secure_storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    debug('Sign In Page Loaded');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sign In Page")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: SizedBox(
              width: 600,
              child: Column(
                children: [
                  TextField(
                    autofocus: true,
                    focusNode: focus_username,
                    controller: controller_username,
                    decoration: InputDecoration(labelText: 'Username'),
                    onSubmitted: (_) => FocusScope.of(context).requestFocus(focus_password),
                  ),

                  SizedBox(height: 8),

                  TextField(
                    focusNode: focus_password,
                    controller: controller_password,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      suffixIcon: IconButton(
                        icon: Icon(!is_password_visible ? Icons.visibility : Icons.visibility_off),
                        onPressed: () => on_password_visibility_toggle(), //
                      ),
                    ),
                    obscureText: !is_password_visible,
                    onSubmitted: (_) => on_sign_in(), //
                  ),

                  SizedBox(height: 8),

                  OutlinedButton(
                    child: Text('Sign In'),
                    onPressed: () => on_sign_in(), //
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void on_password_visibility_toggle() {
    is_password_visible = !is_password_visible;
    setState(() {});
  }

  void on_sign_in() async {
    await dio
        .post(
          '/credential/signin', //
          data: FormData.fromMap({
            'username': controller_username.text, //
            'password': controller_password.text, //
          }),
        )
        .then((r) async {
          show_snackbar(
            context: context, //
            message: 'Sign In Successful',
            color: Colors.green,
          );
          debug(r.data['access_token']);
          await secure_storage.write(
            key: 'access_token', //
            value: r.data['access_token'],
          );
          Navigator.pop(context); //
        })
        .catchError((e) {
          show_snackbar(
            context: context, //
            message: 'Sign In Failed',
            color: Colors.red,
          );
        });
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
