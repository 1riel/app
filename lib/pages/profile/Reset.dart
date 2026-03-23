import 'package:app_1riel/navigators/Routes.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'package:app_1riel/Environment.dart';
import 'package:app_1riel/utilities/Debug.dart';
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
      home: const Reset_Page(),
      routes: Routes.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}

class Reset_Page extends StatefulWidget {
  const Reset_Page({super.key});

  @override
  State<Reset_Page> createState() => _Reset_PageState();
}

class _Reset_PageState extends State<Reset_Page> {
  //
  FlutterSecureStorage secure_storage = FlutterSecureStorage();

  final Dio dio = Dio(
    BaseOptions(
      baseUrl: API_HOST, //
      connectTimeout: Duration(seconds: 10), //
      sendTimeout: Duration(seconds: 10), //
      receiveTimeout: Duration(seconds: 10), //
    ),
  );

  bool is_new_password_visible = false;
  bool is_confirm_new_password_visible = false;

  final controller_telegram_id = TextEditingController();
  final controller_reset_otp = TextEditingController();
  final controller_new_username = TextEditingController();
  final controller_new_password = TextEditingController();
  final controller_confirm_new_password = TextEditingController();

  final focus_telegram_id = FocusNode();
  final focus_reset_otp = FocusNode();
  final focus_new_username = FocusNode();
  final focus_new_password = FocusNode();
  final focus_confirm_new_password = FocusNode();

  @override
  void initState() {
    super.initState();
    debug('Reset Page Loaded');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Reset Page")),
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
                      // errorText: controller_telegram_id.text.isNotEmpty ? null : "Telegram ID is required.",
                      labelText: 'Telegram ID',
                      suffixIcon: TextButton(
                        child: Text("Get Telegram ID"),
                        onPressed: () => on_telegram_id_get(), //
                      ),
                    ),
                    onSubmitted: (v) => FocusScope.of(context).requestFocus(focus_reset_otp),
                  ),

                  SizedBox(height: 8),

                  TextField(
                    focusNode: focus_reset_otp,
                    controller: controller_reset_otp,
                    // ? need to update
                    // enabled: controller_telegram_id.text.isNotEmpty,
                    decoration: InputDecoration(
                      // errorText: controller_reset_otp.text.length == 6 ? null : "OTP must be 6 numbers.",
                      labelText: 'Reset OTP', //
                      suffixIcon: TextButton(
                        child: Text("Get Reset OTP"),
                        onPressed: () => on_request_reset_otp(), //
                      ),
                    ),
                    onSubmitted: (v) => FocusScope.of(context).requestFocus(focus_new_username),
                  ),

                  SizedBox(height: 8),

                  TextField(
                    focusNode: focus_new_username,
                    controller: controller_new_username,
                    // enabled: controller_reset_otp.text.length == 6,
                    decoration: InputDecoration(labelText: 'New Username'),
                    onSubmitted: (v) => FocusScope.of(context).requestFocus(focus_new_password),
                  ),

                  SizedBox(height: 8),

                  TextField(
                    focusNode: focus_new_password,
                    controller: controller_new_password,
                    // enabled: controller_reset_otp.text.length == 6,
                    decoration: InputDecoration(
                      labelText: 'New Password',
                      suffixIcon: IconButton(
                        icon: !is_new_password_visible ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
                        onPressed: () => on_new_password_visibility_toggle(), //
                      ),
                    ),
                    obscureText: !is_new_password_visible,
                    onSubmitted: (v) => FocusScope.of(context).requestFocus(focus_confirm_new_password),
                  ),

                  SizedBox(height: 8),

                  TextField(
                    focusNode: focus_confirm_new_password,
                    controller: controller_confirm_new_password,
                    // enabled: controller_reset_otp.text.length == 6,
                    decoration: InputDecoration(
                      labelText: 'Confirm New Password',
                      error: controller_confirm_new_password.text == controller_new_password.text ? null : Text('Passwords do not match.'),
                      suffixIcon: IconButton(
                        icon: !is_confirm_new_password_visible ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
                        onPressed: () => on_confirm_new_password_visibility_toggle(), //
                      ),
                    ),
                    obscureText: !is_confirm_new_password_visible,
                    onSubmitted: (v) => on_reset(),
                  ),

                  SizedBox(height: 8),

                  OutlinedButton(
                    onPressed: on_reset_button_enabled() ? null : () => on_reset(), //
                    child: Text('Reset'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void on_confirm_new_password_visibility_toggle() {
    is_confirm_new_password_visible = !is_confirm_new_password_visible;
    setState(() {});
  }

  void on_new_password_visibility_toggle() {
    is_new_password_visible = !is_new_password_visible;
    setState(() {});
  }

  void on_telegram_id_get() async {
    await launchUrl(Uri.parse('https://t.me/muy_riel_otp_bot'));
  }

  void on_request_reset_otp() async {
    await dio
        .post(
          '/credential/reset_otp', //
          data: FormData.fromMap({
            'telegram_id': controller_telegram_id.text, //
          }),
        )
        .then((r) {
          show_snackbar(
            context: context, //
            message: 'OTP sent successfully.',
            color: Colors.green,
          );
        })
        .catchError((e) {
          show_snackbar(
            context: context, //
            message: 'Failed to send OTP.',
            color: Colors.red,
          );
        });
  }

  bool on_reset_button_enabled() {
    return controller_telegram_id.text.isNotEmpty && //
        controller_reset_otp.text.length == 6 && //
        controller_new_username.text.isNotEmpty && //
        controller_new_password.text.isNotEmpty && //
        controller_confirm_new_password.text.isNotEmpty && //
        controller_new_password.text == controller_confirm_new_password.text;
  }

  void on_reset() async {
    await dio
        .post(
          '/credential/reset', //
          data: FormData.fromMap({
            'telegram_id': controller_telegram_id.text, //
            'reset_otp': controller_reset_otp.text, //
            'new_username': controller_new_username.text, //
            'new_password': controller_new_password.text, //
          }),
        )
        .then((r) {
          show_snackbar(context: context, message: 'Reset Successful', color: Colors.green);
          Navigator.of(context).pop(true); // reset successful
        })
        .catchError((e) {
          show_snackbar(context: context, message: 'Reset Failed', color: Colors.red);
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
