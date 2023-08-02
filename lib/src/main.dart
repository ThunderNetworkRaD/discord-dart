import "dart:async";
import "dart:io";
import "package:tn_discord/src/requests.dart";

import "types.dart";
import "dart:convert";
import "package:events_emitter/events_emitter.dart";

final version = "10";
final apiURL = "https://discord.com/api/v$version";

class Client extends EventEmitter {
  String? token;
  List<GatewayIntentBits> intents = [];
  bool logged = false;
  dynamic ws;
  String resume_gateway_url = "";
  String session_id = "";

  Client({List<GatewayIntentBits> intents = const []});

  login(String token) async {
    final websocket = await requestWebSocketURL();

    this.token = token;
    logged = true;

    ws = await WebSocket.connect(websocket);

    dynamic payload = {
      "op": 2,
      'd': {
        "token": token,
        "intents": 32767,
        "properties": {
          "os": "linux",
          "browser": "chrome",
          "device": "chrome",
        },
      }
    };
    ws.add(json.encode(payload));

    reconnect() {
      payload = {
        "op": 6,
        "d": {"token": token, "session_id": session_id, "seq": 1337}
      };

      ws = WebSocket.connect(resume_gateway_url);
      ws.add(json.encode(payload));
    }

    sendHeartBeat() {
      payload = {"op": 1, "d": null};
      ws.add(json.encode(payload));
      print("Sent Heartbeat");
    }

    heartbeatsender(int ms) {
      double jitter = 0.8; // number from 0 to 1
      Timer.periodic(Duration(milliseconds: (ms * jitter).round()), (timer) {
        sendHeartBeat();
      });
    }

    ws.listen((event) {
      event = json.decode(event);

      print(event);

      switch (event["op"]) {
        case 1:
          sendHeartBeat();
          break;
        case 10:
          heartbeatsender(event["d"]["heartbeat_interval"]);
          break;
        case 7:
        case 9:
        case 4000:
        case 4001:
        case 4002:
        case 4003:
        case 4005:
        case 4007:
        case 4008:
        case 4009:
          reconnect();
          break;
        case 4004:
          throw Exception("[4014] Disallowed Intents");
        case 4010:
          throw Exception("[4010] Invalid Shard");
        case 4011:
          throw Exception("[4011] Sharding Required");
        case 4012:
          throw Exception("[4012] Invalid API Version");
        case 4013:
          throw Exception("[4013] Invalid Intents");
        case 4014:
          throw Exception("[4014] Disallowed Intents");
      }

      var eventName = event["t"];

      switch (eventName) {
        case "READY":
          emit("READY", event);
      }
    });
  }
}
