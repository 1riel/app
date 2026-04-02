import 'package:flutter/widgets.dart';

class TelegramAuthWebWidget extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
