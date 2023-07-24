import "package:events_emitter/events_emitter.dart";
import "types.dart";
import "util.dart";
import 'package:http/http.dart' as http;

class Client extends EventEmitter {
  Client({List<GatewayIntentBits> intents = const []});
}

class WebhookClient {
  String token = "";
  String id = "";

  WebhookClient({dynamic url, dynamic token, dynamic id}) {
    if (url != null) {
      final regexed = Utils.parseWebhookURL(url);
      this.id = regexed["id"].toString();
      this.token = regexed["token"].toString();
    } else {
      this.token = token;
      this.id = id;
    }
  }

  void send(String content) async {
    final url = Uri.parse("https://discord.com/api/webhooks/$id/$token");

    final body = {"content": content};
    
    await http.post(url, body: body);
  }
}
