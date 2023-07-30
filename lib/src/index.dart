import "package:events_emitter/events_emitter.dart";
import "package:http/http.dart";
import "package:tn_discord/src/error_handler.dart";
import "package:tn_discord/src/message.dart";
import "types.dart";
import "util.dart";

final version = "10";
final apiURL = "https://discord.com/api/v$version";

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

  void sendText(String content) async {
    Map<String, String> body = {"content": content};
    Response res = await sendWH(body, token, id);

    handleCode(res.statusCode, res);
  }

  void send({String content = "", List<Embed> embeds = const []}) async {
    Map body = {"content": content, "embeds": embeds};

    Response res = await sendWH(body, token, id);

    handleCode(res.statusCode, res);
  }

  void editText(String id, String content) async {
    Map<String, String> body = {"content": content};
    Response res = await editWH(body, token, this.id, id);

    handleCode(res.statusCode, res);
  }

  void edit(String id, {String content = "", List<Embed> embeds = const []}) async {
    Map body = {"content": content, "embeds": embeds};
    Response res = await editWH(body, token, this.id, id);

    handleCode(res.statusCode, res);
  }

  Future<void> get(String id) async {
    Response res = await getWH(token, this.id, id);

    handleCode(res.statusCode, res);

  }
}
