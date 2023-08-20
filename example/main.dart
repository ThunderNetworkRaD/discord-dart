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

  client.login("ODkwMz1g");

  client.on("READY", (data) async {
    // Let we get a guild name
    var a = await client.guilds.fetch("913388008307302410");
    print(a.name);
    client.commands.create(Command(name: "test", description: "test1"));
  });

  client.on(Events.MessageCreate, (MessageSent message) async {
    // When a message is sent print author id and reply with the same message
    print(message.authorID);
    if (message.authorID != client.user.id) {
      client.channels.cache.get(message.id).send(Message(content: message.content));
    }
  });
}
