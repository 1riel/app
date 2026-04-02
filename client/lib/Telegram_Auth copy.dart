import 'package:app_1riel/telegram_auth_widget_stub.dart' if (dart.library.html) 'package:app_1riel/telegram_auth_widget_web.dart';
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Login with Telegram 1054', style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
                const SizedBox(height: 12),
                Text('Bot: @$telegramBotUsername', textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 16),
                Card(
                  clipBehavior: Clip.antiAlias,
                  child: Padding(padding: const EdgeInsets.all(24), child: _buildAuthSurface()),
                ),
                const SizedBox(height: 12),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    OutlinedButton(onPressed: openTelegramAuth, child: const Text('Open Auth URL')),
                    if (supportsEmbeddedWebView) OutlinedButton(onPressed: () => controller?.loadHtmlString(telegramHtml), child: const Text('Reload Widget')),
                  ],
                ),
                const SizedBox(height: 12),
                SelectableText(telegramAuthUrl, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAuthSurface() {
    if (kIsWeb) {
      return const SizedBox(
        height: 120,
        child: TelegramAuthWebWidget(botUsername: telegramBotUsername, authUrl: telegramAuthUrl, scriptUrl: telegramWidgetScriptUrl, requestAccess: 'write', size: 'large', radius: '0'),
      );
    }

    if (supportsEmbeddedWebView && controller != null) {
      return SizedBox(height: 220, child: WebViewWidget(controller: controller!));
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Embedded Telegram login is not available on this platform. Open the Telegram auth URL in your browser instead.', textAlign: TextAlign.center),
        const SizedBox(height: 12),
        OutlinedButton(onPressed: openTelegramAuth, child: const Text('Open Telegram Login')),
      ],
    );
  }

  Future<void> openTelegramAuth() async {
    final uri = Uri.parse(telegramAuthUrl);
    await launchUrl(uri, mode: LaunchMode.platformDefault);
  }
}
