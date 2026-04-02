import 'package:flutter/material.dart';

import 'dart:html' as html;
import 'dart:ui_web' as ui_web;

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
      // <script
      //       async
      //       src="https://telegram.org/js/telegram-widget.js?23"
      //       data-telegram-login="muy_riel_otp_bot"
      //       data-size="large"
      //       data-radius="0"
      //       data-auth-url="https://www.1riel.com/auth/telegram"
      //       data-request-access="write"
      //     ></script>

      final script = html.ScriptElement();
      script.async = true;
      script.src = telegramWidgetScriptUrl;
      script.setAttribute('data-telegram-login', telegramBotUsername);
      script.setAttribute('data-size', 'large');
      script.setAttribute('data-radius', '0');
      script.setAttribute('data-auth-url', telegramAuthUrl);
      script.setAttribute('data-request-access', 'write');

      final host = html.DivElement();
      host.append(script);

      return host;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Telegram Login 1217')),
      body: Center(
        child: HtmlElementView(viewType: viewType), //
      ),
    );
  }
}
