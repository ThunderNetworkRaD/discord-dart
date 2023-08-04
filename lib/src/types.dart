// ignore_for_file: constant_identifier_names
import "dart:convert";
import "package:http/http.dart" as http;
import "main.dart";
import "requests.dart";

/// A list of all Gateway Intents Bits.
class GatewayIntentBits {
  static const Guilds = 1;
  static const GuildMembers = 2;
  static const GuildModeration = 4;
  static const GuildEmojisAndStickers = 8;
  static const GuildIntegrations = 16;
  static const GuildWebhooks = 32;
  static const GuildInvites = 64;
  static const GuildVoiceStates = 128;
  static const GuildPresences = 256;
  static const GuildMessages = 512;
  static const GuildMessageReactions = 1024;
  static const GuildMessageTyping = 2048;
  static const DirectMessages = 4096;
  static const DirectMessageReactions = 8192;
  static const DirectMessageTyping = 16384;
  static const MessageContent = 32768;
  static const GuildScheduledEvents = 65536;
  static const AutoModerationConfiguration = 1048576;
  static const AutoModerationExecution = 2097152;
}

/// A collection of variables. Like NodeJS' Map and discordjs' Collections
/// This will be moved to a separate package in the future.
class Collection {
  final Map<String, dynamic> _variables = {};
  /// Create a new Collection
  Collection();

  /// Adds a new element with key [key] and value [value] to the Map. If an element with the same key already exists, the element will be updated.
  dynamic set(String key, dynamic value) {
    _variables[key] = value;
    return value;
  }

  /// Returns [key] from the Map object. If the value that is associated to the provided key is an object, then you will get a reference to that object and any change made to that object will effectively modify it inside the Map.
  dynamic get(String key) {
    if (_variables[key] == null) {
      throw Exception("Variable not found for $key");
    }
    return _variables[key];
  }

  /// Removes [key] from the Map object.
  void remove(String key) {
    _variables.remove(key);
  }

  /// Alias of [remove]
  void delete(String key) {
    remove(key);
  }

  /// Sum to the value of [key] to [value].
  dynamic add(String key, num value) {
    _variables[key] += value;
    return value + _variables[key];
  }

  /// Subtract [value] from the value of [key].
  dynamic subtract(String key, num value) {
    _variables[key] -= value;
    return _variables[key] - value;
  }

  /// Returns all the variables as a Map.
  Map<String, dynamic> getAll() {
    return _variables;
  }

  /// Returns all the variables' keys as a List.
  List<String> keys() {
    return _variables.keys.toList();
  }

  /// Returns all the variables' values as a List.
  List<dynamic> values() {
    return _variables.values.toList();
  }
}

/// Represents a guild (aka server) on Discord.
class Guild {
  final Sender _sender;
  ChannelManager? channels;
  MemberManager? members;
  RoleManager? roles;
  String id = '';
  String? name = '';
  String? ownerId;
  String? description;
  String? joinedAt;
  bool? large;
  bool? unavailable;
  int? memberCount;

  Guild(this._sender, Map data) {
    id = data["id"];
    if (data["unavailable"] != null && data["unavailable"] == false) {
      unavailable = data["unavailable"];
      name = data["name"];
      description = data["description"];
      ownerId = data["owner_id"];
      if (data["joined_at"] != null) {
        joinedAt = data["joined_at"];
      }
      if (data["large"] != null) {
        large = data["large"];
      }
      if (data["member_count"] != null) {
        memberCount = data["member_count"];
      }

      if(data["channels"] != null && data["members"] != null && data["roles"] != null) {
        List<Channel> cc = [];
        for (var c in data["channels"]) {
          cc.add(Channel(_sender, c));
        }
        channels = ChannelManager(_sender, cc);

        List<Member> mm = [];
        for (var m in data["members"]) {
          mm.add(Member(m));
        }
        members = MemberManager(mm, id);

        List<Role> rr = [];
        for (var r in data["roles"]) {
          rr.add(Role(r));
        }
        roles = RoleManager(rr);
      } else {
        channels = ChannelManager(_sender, []);
        members = MemberManager([], id);
        roles = RoleManager([]);
      }
    } else {
      unavailable = data["unavailable"];
    }
  }
}

class GuildManager {
  final Collection cache = Collection();
  final Sender _sender;

  GuildManager(this._sender, List<Guild> guilds) {
    for (var guild in guilds) {
      cache.set(guild.id, guild);
    }
  }

  Future<Guild> fetch(String id) async {
    var res = await _sender.fetchGuild(id);
    final guild = Guild(_sender, res);
    final oldGuild = cache.get(guild.id);
    guild.joinedAt = oldGuild.joinedAt;
    guild.large = oldGuild.large;
    guild.unavailable = oldGuild.unavailable;
    guild.memberCount = oldGuild.memberCount;
    cache.set(guild.id, guild);
    return guild;
  }
}

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

class ChannelManager {
  final Collection cache = Collection();
  final Sender _sender;

  ChannelManager(this._sender, List<Channel> channels) {
    for (var channel in channels) {
      cache.set(channel.id, channel);
    }
  }

  Future<Channel> fetch(String id) async {
    var res = await _sender.fetchChannel(id);
    dynamic channel = Channel(_sender, res);
    cache.set(channel.id, channel);
    return channel;
  }
}

class Member {
  String id = '';
  User user = User({});

  Member(Map data) {
    id = data["user"]["id"];
    user = User(data["user"]);
  }
}

class MemberManager {
  final Collection cache = Collection();
  String id;

  MemberManager(List<Member> members, this.id) {
    for (var member in members) {
      cache.set(member.id, member);
    }
  }

  fetch(String id) async {
    dynamic res = await http.get(Uri.parse("$apiURL/guilds/${this.id}/members/$id"));
    if (res.statusCode != 200) {
      throw Exception("Error ${res.statusCode} receiving the member");
    }

    res = json.decode(res.body);
    cache.set(id, res);
    return res;
  }
}

class Role {
  String id = '';
  String name = '';

  Role(Map data) {
    id = data["id"];
    name = data["name"];
  }
}

class RoleManager {
  final Collection cache = Collection();

  RoleManager(List<Role> roles) {
    for (var role in roles) {
      cache.set(role.id, role);
    }
  }
}

class User {
  String id = '';
  bool bot = false;
  String username = '';
  String globalName = '';
  String displayName = '';
  int discriminator = 0;
  String avatar = '';

  User(Map data) {
    if (data["id"] == null) {
      return;
    }
    id = data["id"];
    // bot = data["bot"];
    username = data["username"];
    // globalName = data["global_name"];
    // displayName = data["display_name"];
    // discriminator = data["discriminator"];
    // avatar = "https://cdn.discordapp.com/avatars/$id/${data["avatar"]}.webp";
  }
}

class UserManager {
  final Collection cache = Collection();

  UserManager(List<User> users) {
    for (var user in users) {
      cache.set(user.id, user);
    }
  }

  Future<User> fetch(String id) async {
    var res = await http.get(Uri.parse("$apiURL/users/$id"));
    if (res.statusCode != 200) {
      throw Exception("Error ${res.statusCode} receiving the user");
    }
    dynamic user = User(json.decode(res.body));
    cache.set(user.id, user);
    return user;
  }
}

typedef Embed = Map<String, String>;

/// Represents a message on Discord.
class Message {
  String? content;
  Message({ this.content });

  /// Returns an object rapresentation of the message
  exportable() {
    return {
      "content": content,
    };
  }
}

/// Represents a sent message on Discord.
class MessageSent extends Message {
  String id = '';
  MessageSent(Message msg, { required this.id }) {
    content = msg.content;
  }
}
