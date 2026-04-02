import 'package:app_1riel/telegram_auth_widget_web.dart';
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
  WebViewController? controller;

  bool get supportsEmbeddedWebView {
    if (kIsWeb) {
      return false;
    }

    return defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.macOS;
  }

  String get telegramHtml =>
      '''
<!doctype html>
<html lang="en">
	<head>
		<meta charset="utf-8" />
		<meta name="viewport" content="width=device-width, initial-scale=1" />
		<title>Login with Telegram</title>
		<style>
			body {
				margin: 0;
				min-height: 100vh;
				display: flex;
				align-items: center;
				justify-content: center;
				background: #f5f7fb;
				font-family: Arial, sans-serif;
			}

			.wrap {
				text-align: center;
			}

			h2 {
				margin: 0 0 20px;
				color: #1f2937;
				font-size: 24px;
			}
		</style>
	</head>
	<body>
		<div class="wrap">
			<h2>Login with Telegram 1054</h2>
			<script
				async
				src="$telegramWidgetScriptUrl"
				data-telegram-login="$telegramBotUsername"
				data-size="large"
				data-radius="0"
				data-auth-url="$telegramAuthUrl"
				data-request-access="write"
			></script>
		</div>
	</body>
</html>
''';

  @override
  void initState() {
    super.initState();

    if (supportsEmbeddedWebView) {
      controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(Colors.transparent)
        ..loadHtmlString(telegramHtml);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Telegram Login')),
      body: Center(
        //
        child: supportsEmbeddedWebView
            ? WebViewWidget(controller: controller!)
            : ElevatedButton(
                onPressed: () async {
                  final uri = Uri.parse(telegramAuthUrl);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not launch Telegram login')));
                  }
                },
                child: const Text('Login with Telegram'),
              ),

        // TelegramAuthWebWidget(
        //   botUsername: telegramBotUsername, //
        //   authUrl: telegramAuthUrl,
        //   scriptUrl: telegramWidgetScriptUrl,
        //   requestAccess: 'write',
        //   size: 'large',
        //   radius: '0',
        // ),
      ),
    );
  }
}
