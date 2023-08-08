import "embed.dart";

/// Represents a message on Discord.
class Message {
  String? content;
  List<Embed>? embeds;

  Message({ this.content, this.embeds });

  /// Returns an object rapresentation of the message
  Map<String, dynamic> exportable() {
    Map<String, dynamic> a = {};
    List<Map<String, dynamic>> e = [];
    if (embeds != null && embeds!.isNotEmpty) {
      for (var embed in embeds!) {
        e.add(embed.exportable());
      }
    }
    if (e.isNotEmpty) {
      a["embeds"] = e;
    }
    if (content != null) {
      a["content"] = content;
    }
    return a;
  }
}