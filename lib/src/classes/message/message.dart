/// Represents a message on Discord.
class Message {
  String? content;
  Message({ this.content });

  /// Returns an object rapresentation of the message
  Map<String, dynamic> exportable() {
    return {
      "content": content,
    };
  }
}