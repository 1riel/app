import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TelegramLoginScreen extends StatefulWidget {
  @override
  _TelegramLoginScreenState createState() => _TelegramLoginScreenState();
}

class _TelegramLoginScreenState extends State<TelegramLoginScreen> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadHtmlString('''
        <!doctype html>
        <html>
          <body style="display: flex; justify-content: center; align-items: center; height: 100vh;">
            <script
              async
              src="https://telegram.org/js/telegram-widget.js?23"
              data-telegram-login="muy_riel_otp_bot"
              data-size="large"
              data-auth-url="https://www.1riel.com/auth/telegram"
            ></script>
          </body>
        </html>
      ''');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Telegram Login")),
      body: WebViewWidget(controller: controller),
    );
  }
}
