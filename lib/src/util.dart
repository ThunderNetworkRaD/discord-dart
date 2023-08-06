import 'classes/message/embed.dart';

class Utils {
  static Map<String, String> parseWebhookURL(String url) {
    final RegExp regex = RegExp(
      r'https?://(?:ptb\.|canary\.)?discord\.com/api(?:/v\d{1,2})?/webhooks/(\d{17,19})/([\w-]{68})',
      caseSensitive: false,
    );
    final Match? match = regex.firstMatch(url);

    if (match == null || match.groupCount < 2) {
      throw Exception('Invalid webhook url');
    }

    final String id = match.group(1)!;
    final String token = match.group(2)!;

    return {
      "id": id,
      "token": token,
    };
  }

  Map<String, dynamic> createMessage({String? text, List<Embed>? embeds}) {
    Map<String, dynamic> message = {};

    if (text != null && text != "") message["content"] = text;
    if (embeds != null && embeds.isNotEmpty) message["embeds"] = embeds;

    return message;
  }
}
