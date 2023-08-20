import "dart:async";
import 'dart:io' if (dart.library.html) 'dart:html';
import "dart:convert";
import "package:events_emitter/events_emitter.dart";
import "package:tn_discord/src/classes/channel/channel_manager.dart";
import "package:tn_discord/src/classes/commands/command_manager.dart";

import "classes/guild/guild.dart";
import "classes/guild/guild_manager.dart";
import "classes/interaction.dart";
import "classes/message/embed.dart";
import "classes/message/message.dart";
import "classes/guild/unavailable_guild.dart";
import "classes/message/message_sent.dart";
import "classes/user/user.dart";
import "requests.dart";

final version = "10";
final apiURL = "https://discord.com/api/v$version";

/// This function calculate the intent number required from the gateway.
/// [intents] is a list of multiples of two. You can use GatewayIntentBits class.
/// Return a number.
int intentsCalculator(List<int> intents) {
  int intentsNumber = 0;

  for (var element in intents) {
    intentsNumber += element;
  }

  return intentsNumber;
}


/// The main hub for interacting with the Discord API, and the starting point for any bot.
class Client extends EventEmitter {
  String? token;
  int intents;
  late WebSocket ws;
  String resumeGatewayURL = "";
  String sessionID = "";
  late GuildManager guilds;
  late ChannelManager channels;
  bool ready = false;
  late User user;
  late CommandManager commands;


  /// Create a new Client.
  /// [intents] Intents to enable for this connection, it's a multiple of two.
  Client({this.intents = 0});

  /// Logs the client in, establishing a WebSocket connection to Discord.
  /// [token] is the token of the account to log in with.
  /// Get the token from https://discord.dev
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
          "os": Platform.operatingSystem,
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

    late Sender sender;
    late int n;

    ws.listen((event) async {
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
          sender = Sender(token, event["d"]["user"]["id"]);
          var i = await sender.fetchGuilds(withCounts: true);

          List<Guild> gg = [];

          for (dynamic g in i) {
            gg.add(Guild(sender, g));
          }

          channels = ChannelManager(sender, [], main: true);

          sender.channels = channels;
          guilds = GuildManager(sender, gg);

          n = i.length;

          commands["set"] = sender.setCommands;

          resumeGatewayURL = event["d"]["resume_gateway_url"];
          sessionID = event["d"]["session_id"];
          user = User(event["d"]["user"]);
          sender.setID(user.id);
          ready = true;
          commands = CommandManager(sender);
          break;
        case "GUILD_CREATE":
          if (guilds.cache.has(event["d"]["id"])) {
            Guild oldGuild = guilds.cache.get(event["d"]["id"]);
            if (oldGuild.permissions != null) {
              event['d']["permissions"] = oldGuild.permissions;
            }
          }
          guilds.cache.set(event['d']["id"], Guild(sender, event['d']));
          if (n > 1) {
            n--;
          } else if (n == 1) {
            n--;
            emit("READY");
          } else {
            emit("GUILD_CREATE");
          }
          break;
        case "GUILD_DELETE":
          if (guilds.cache.has(event["d"]["id"])) {
            guilds.cache.delete(event["d"]["id"]);
            guilds.cache.set(event["d"]["id"], UnavailableGuild(event["d"]["id"],));
          }
          var guild = event["d"];
          emit("GUILD_DELETE", guild);
          break;
        case "INTERACTION_CREATE":
          if (!ready) return;
          emit("INTERACTION_CREATE", Interaction(event["d"]));
          break;
        case "MESSAGE_CREATE":
          if (!ready) return;
          var content = event["d"]["content"];
          var embeds = event["d"]["embeds"];
          List<Embed> e = [];
          for (var embed in embeds) {
            var title = embed["title"];
            var description = embed["description"];
            var url = embed["url"];
            var timestamp = embed["timestamp"];
            var color = embed["color"];
            var footer = embed["footer"];
            var image = embed["image"];
            var thumbnail = embed["thumbnail"];
            var author = embed["author"];
            var fields = embed["fields"];
            e.add(Embed(
              author: author,
              fields: fields,
              footer: footer,
              image: image,
              thumbnail: thumbnail,
              title: title,
              description: description,
              url: url,
              timestamp: timestamp,
              color: color
            ));
          }
          emit(
            "MESSAGE_CREATE",
            MessageSent(
              Message(
                content: content,
                embeds: e
              ),
              event["d"]["author"]["id"],
              event["d"]["channel_id"],
              event["d"]["id"]
            )
          );
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
