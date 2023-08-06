import '../../requests.dart';
import '../message/message.dart';
import '../message/message_sent.dart';

class Channel {
  String id = '';
  String name = '';
  final Sender _sender;

  Channel(this._sender, data) {
    id = data["id"];
    name = data["name"];
  }

  Future<MessageSent> send(Message message) async {
    await _sender.send(message, id);
    return MessageSent(message, id: id);
  }
}