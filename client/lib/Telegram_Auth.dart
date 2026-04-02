import 'dart:html' as html;
import 'dart:ui_web' as ui_web;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

const String telegramBotUsername = 'muy_riel_otp_bot';
const String telegramAuthUrl = 'https://www.1riel.com/auth/telegram';
const String telegramWidgetScriptUrl = 'https://telegram.org/js/telegram-widget.js?23';

class TelegramLoginScreen extends StatefulWidget {
  const TelegramLoginScreen({super.key});

  @override
  State<TelegramLoginScreen> createState() => _TelegramLoginScreenState();
}

class _TelegramLoginScreenState extends State<TelegramLoginScreen> {
  late final String viewType;

  @override
  void initState() {
    super.initState();
    viewType = '';

    ui_web.platformViewRegistry.registerViewFactory(viewType, (int _) {
      final script = html.ScriptElement();

      script.async = true;
      script.src = telegramWidgetScriptUrl;
      script.setAttribute('data-telegram-login', telegramBotUsername);
      script.setAttribute('data-size', 'large');
      script.setAttribute('data-radius', '0');
      script.setAttribute('data-auth-url', telegramAuthUrl);
      script.setAttribute('data-request-access', 'write');

      // <script
      //       async
      //       src="https://telegram.org/js/telegram-widget.js?23"
      //       data-telegram-login="muy_riel_otp_bot"
      //       data-size="large"
      //       data-radius="0"
      //       data-auth-url="https://www.1riel.com/auth/telegram"
      //       data-request-access="write"
      //     ></script>

      final host = html.DivElement();
      // ..style.width = '100%'
      // ..style.height = '100%'
      // ..style.display = 'flex'
      // ..style.alignItems = 'center'
      // ..style.justifyContent = 'center';
      host.append(script);
      return host;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Telegram Login 1209')),
      body: Center(
        child: HtmlElementView(viewType: viewType), //
      ),
    );
  }
}
