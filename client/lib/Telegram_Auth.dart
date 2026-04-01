import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Telegram Login Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: TelegramLoginWebView(),
    );
  }
}

class TelegramLoginWebView extends StatelessWidget {
  final String htmlData = """
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Login with Telegram</title>
    <style>
      body { display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
    </style>
  </head>
  <body>
    <script
      async
      src="https://telegram.org/js/telegram-widget.js?23"
      data-telegram-login="muy_riel_otp_bot"
      data-size="large"
      data-radius="0"
      data-auth-url="https://1riel.github.io/app/auth/telegram"
      data-request-access="write"
    ></script>
  </body>
</html>
""";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Telegram Login")),
      body: InAppWebView(
        initialData: InAppWebViewInitialData(data: htmlData),
        initialSettings: InAppWebViewSettings(
          javaScriptEnabled: true,
          // Required for some scripts to load external resources
          allowFileAccessFromFileURLs: true,
          allowUniversalAccessFromFileURLs: true,
        ),
        onWebViewCreated: (controller) {
          // You can listen for URL changes if you need to catch the auth-url redirect
        },
        onLoadStop: (controller, url) {
          print("Page finished loading: $url");
        },
      ),
    );
  }
}
