import 'message.dart';

/// Represents a sent message on Discord.
class MessageSent extends Message {
  String id = '';
  MessageSent(Message msg, { required this.id }) {
    content = msg.content;
  }
}
