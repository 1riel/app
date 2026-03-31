import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
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
      home: Sign_Up_Page(),
      routes: Routes.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}

class Sign_Up_Page extends StatefulWidget {
  const Sign_Up_Page({super.key});

  @override
  State<Sign_Up_Page> createState() => _Sign_Up_PageState();
}

class _Sign_Up_PageState extends State<Sign_Up_Page> {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: API_HOST, //
      connectTimeout: Duration(seconds: 10), //
      sendTimeout: Duration(seconds: 10), //
      receiveTimeout: Duration(seconds: 10), //
    ),
  );

  FlutterSecureStorage secure_storage = FlutterSecureStorage();

  bool is_password_visible = false;
  bool is_confirm_password_visible = false;

  TextEditingController controller_telegram_id = TextEditingController();
  TextEditingController controller_signup_otp = TextEditingController();
  TextEditingController controller_username = TextEditingController();
  TextEditingController controller_password = TextEditingController();
  TextEditingController controller_confirm_password = TextEditingController();

  FocusNode focus_telegram_id = FocusNode();
  FocusNode focus_signup_otp = FocusNode();
  FocusNode focus_username = FocusNode();
  FocusNode focus_password = FocusNode();
  FocusNode focus_confirm_password = FocusNode();

  @override
  void initState() {
    super.initState();
    debug('Sign Up Page Loaded');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sign Up Page")),
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
                    focusNode: focus_telegram_id,
                    controller: controller_telegram_id,
                    decoration: InputDecoration(
                      labelText: 'Telegram ID',
                      suffixIcon: TextButton(
                        child: Text("Get Telegram ID"),
                        onPressed: () => on_telegram_id_get(), //
                      ),
                    ),
                    onSubmitted: (_) => FocusScope.of(context).requestFocus(focus_signup_otp),
                  ),

                  SizedBox(height: 8),

                  TextField(
                    focusNode: focus_signup_otp,
                    controller: controller_signup_otp,
                    decoration: InputDecoration(
                      labelText: 'Sign Up OTP', //
                      suffixIcon: TextButton(
                        child: Text("Get OTP"),
                        onPressed: () => on_sign_up_otp_request(), //
                      ),
                    ),
                    onSubmitted: (_) => FocusScope.of(context).requestFocus(focus_username),
                  ),

                  SizedBox(height: 8),

                  TextField(
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
                    onSubmitted: (_) => FocusScope.of(context).requestFocus(focus_confirm_password),
                  ),

                  SizedBox(height: 8),

                  TextField(
                    focusNode: focus_confirm_password,
                    controller: controller_confirm_password,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      suffixIcon: IconButton(
                        icon: Icon(!is_confirm_password_visible ? Icons.visibility : Icons.visibility_off),
                        onPressed: () => on_confirm_password_visibility_toggle(), //
                      ),
                    ),
                    obscureText: !is_confirm_password_visible,
                    onSubmitted: (v) => on_sign_up(), //
                  ),

                  SizedBox(height: 8),

                  OutlinedButton(
                    child: Text('Sign Up'),
                    onPressed: () => on_sign_up(), //
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //

  void on_confirm_password_visibility_toggle() {
    is_confirm_password_visible = !is_confirm_password_visible;
    setState(() {});
  }

  void on_password_visibility_toggle() {
    is_password_visible = !is_password_visible;
    setState(() {});
  }

  void on_telegram_id_get() async {
    await launchUrl(Uri.parse('https://t.me/muy_riel_otp_bot'));
  }

  void on_sign_up_otp_request() async {
    await dio
        .post(
          '/credential/signup_otp', //
          data: FormData.fromMap({
            'telegram_id': controller_telegram_id.text, //
          }),
        )
        .then((r) {
          show_snackbar(context: context, message: 'OTP sent successfully.', color: Colors.green);
        })
        .catchError((e) {
          show_snackbar(context: context, message: 'Failed to send OTP.', color: Colors.red);
        });
  }

  void on_sign_up() async {
    await dio
        .post(
          '/credential/signup', //
          data: FormData.fromMap({
            'username': controller_username.text, //
            'password': controller_password.text, //
            'telegram_id': controller_telegram_id.text, //
            'signup_otp': controller_signup_otp.text, //
          }),
        )
        .then((r) {
          show_snackbar(context: context, message: 'Sign Up Successful', color: Colors.green);
          Navigator.of(context).pop(true); // sign up successful
        })
        .catchError((e) {
          show_snackbar(context: context, message: 'Sign Up Failed', color: Colors.red);
        });
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
}
