import 'package:tn_discord/src/classes/events.dart';
import 'package:tn_discord/src/classes/message/message.dart';
import 'package:tn_discord/src/classes/message/message_sent.dart';
import 'package:tn_discord/tn_discord.dart';

main() async {
  var client = Client(
    intents: calculateIntents([
      GatewayIntentBits.Guilds,
      GatewayIntentBits.GuildMessages,
      GatewayIntentBits.MessageContent
      // What do you want from GatewayIntentBits
    ])
  );

  client.login("Your Bot Token");

  client.on("READY", (data) async {
    // Let we get a guild name
    var a = await client.guilds.fetch("a guild id");
    print(a.name);
  });

  client.on(Events.MessageCreate, (MessageSent message) async {
    // When a message is sent print author id and reply with the same message
    print(message.authorID);
    if (message.authorID != client.user.id) {
      client.channels.cache.get(message.id).send(Message(content: message.content));
    }
  });
}
