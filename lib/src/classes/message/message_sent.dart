import 'message.dart';

/// Represents a sent message on Discord.
class MessageSent extends Message {
  late String id;
  late String channelID;
  late String authorID;

  MessageSent(Message msg, this.authorID, this.id, this.channelID): super(content: msg.content, embeds: msg.embeds);
}
