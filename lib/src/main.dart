import "dart:async";
import "dart:io";
import "package:tn_discord/src/types.dart";

import "requests.dart";

import "dart:convert";
import "package:events_emitter/events_emitter.dart";

final version = "10";
final apiURL = "https://discord.com/api/v$version";

int calculateIntents(List<int> intents) {
  int intentsNumber = 0;

  for (var element in intents) {
    intentsNumber += element;
  }

  return intentsNumber;
}

class Client extends EventEmitter {
  String? token;
  int intents;
  dynamic ws;
  String resumeGatewayURL = "";
  String sessionID = "";
  dynamic guilds;
  dynamic ready;

  Client({this.intents = 0});

  login(String token) async {
    final websocket = await requestWebSocketURL();

    this.token = token;

    ws = await WebSocket.connect(websocket);

    dynamic payload = {
      "op": 2,
      'd': {
        "token": token,
        "intents": intents,
        "properties": {
          "os": "linux",
          "browser": "tn_discord",
          "device": "tn_discord",
        },
      }
    };

    ws.add(json.encode(payload));

    reconnect() async {
      payload = {
        "op": 6,
        "d": {"token": token, "session_id": sessionID, "seq": 1337}
      };

      ws = await WebSocket.connect(resumeGatewayURL);
      ws.add(json.encode(payload));
    }

    sendHeartBeat() {
      payload = {"op": 1, "d": null};
      ws.add(json.encode(payload));
    }

    heartbeatsender(int ms) {
      double jitter = 0.8; // number from 0 to 1
      Timer.periodic(Duration(milliseconds: (ms * jitter).round()), (timer) {
        sendHeartBeat();
      });
    }

    Sender sender = Sender(token);
    var i = await sender.getServers();

    List<Guild> gg = [];

    for (dynamic g in i) {
      gg.add(Guild(g));
    }

    guilds = GuildManager(gg);

    int n = i.length;

    ws.listen((event) {
      event = json.decode(event);

      switch (event["op"]) {
        case 1:
          sendHeartBeat();
          break;
        case 10:
          heartbeatsender(event["d"]["heartbeat_interval"]);
          break;
        case 7:
        case 9:
          reconnect();
          break;
      }

      var eventName = event["t"];

      switch (eventName) {
        case "READY":
          resumeGatewayURL = event["d"]["resume_gateway_url"];
          sessionID = event["d"]["session_id"];
          break;
        case "GUILD_CREATE":
          guilds.cache.set(event["d"]["id"], Guild(event["d"]));
          if (n > 1) {
            n--;
          } else {
            emit("READY");
          }
          break;
      }
    }, onDone: () {
      switch (ws.closeCode) {
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
          throw Exception("[4004] Disallowed Intents");
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
    });
  }
}
