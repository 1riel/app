import 'dart:html' as html;
import 'dart:ui_web' as ui_web;

import 'package:flutter/widgets.dart';

int _telegramAuthViewCounter = 0;

class TelegramAuthWebWidget extends StatefulWidget {
  final String botUsername;
  final String authUrl;
  final String scriptUrl;
  final String requestAccess;
  final String size;
  final String radius;

  const TelegramAuthWebWidget({
    super.key, //
    required this.botUsername,
    required this.authUrl,
    required this.scriptUrl,
    required this.requestAccess,
    required this.size,
    required this.radius,
  });

  @override
  State<TelegramAuthWebWidget> createState() => _TelegramAuthWebWidgetState();
}

class _TelegramAuthWebWidgetState extends State<TelegramAuthWebWidget> {
  late final String viewType;

  @override
  void initState() {
    super.initState();
    viewType = 'telegram-auth-widget-${_telegramAuthViewCounter++}';

    ui_web.platformViewRegistry.registerViewFactory(viewType, (int viewId) {
      final host = html.DivElement()
        ..style.width = '100%'
        ..style.height = '100%'
        ..style.display = 'flex'
        ..style.alignItems = 'center'
        ..style.justifyContent = 'center';

      final script = html.ScriptElement()
        ..async = true
        ..src = widget.scriptUrl;

      script.setAttribute('data-telegram-login', widget.botUsername);
      script.setAttribute('data-size', widget.size);
      script.setAttribute('data-radius', widget.radius);
      script.setAttribute('data-auth-url', widget.authUrl);
      script.setAttribute('data-request-access', widget.requestAccess);

      host.append(script);
      return host;
    });
  }

  @override
  Widget build(BuildContext context) {
    return HtmlElementView(viewType: viewType);
  }
}
