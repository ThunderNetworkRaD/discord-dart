import "dart:io";
import "package:events_emitter/events_emitter.dart";
import "types.dart";
import "dart:convert";

final version = "10";
final apiURL = "https://discord.com/api/v$version";
final websocket = "wss://gateway.discord.gg/?v=6&encoding=json";

class Client extends EventEmitter {
  String? token;
  List<GatewayIntentBits> intents = [];
  bool logged = false;
  dynamic ws;

  Client({List<GatewayIntentBits> intents = const []});

  login(String token) async {
    this.token = token;
    logged = true;

    ws = await WebSocket.connect(websocket);
    var interval = 0;
    var payload = {
      "op": 2,
      'd': {
        "token": token,
        "intents": 32767,
        "properties": {
          "\$os": "linux",
          "\$browser": "chrome",
          "\$device": "chrome",
        },
      }
    };

    print(json.encode(payload));

    ws.add(json.encode(payload));

    ws.listen((event) {
      event = json.decode(event);
      var eventName = event["t"];

      switch (eventName) {
        case "READY":
          emit("READY", {"user": event["d"]["user"]});
      }
    });
  }
}
