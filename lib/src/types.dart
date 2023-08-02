// ignore_for_file: constant_identifier_names

import "dart:convert";

import "package:http/http.dart" as http;

import "main.dart";

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

class Collection {
  final Map<String, dynamic> _variables = {};
  Collection();

  dynamic set(String key, dynamic value) {
    _variables[key] = value;
    return value;
  }

  dynamic get(String key) {
    return _variables[key];
  }

  void remove(String key) {
    _variables.remove(key);
  }

  dynamic add(String key, num value) {
    _variables[key] += value;
    return value + _variables[key];
  }

  dynamic subtract(String key, num value) {
    _variables[key] -= value;
    return value - _variables[key];
  }
}

class Guild {
  String id = '';
  String name = '';
  String owner = '';
  String description = '';

  Guild(Map data) {
    id = data["id"];
    name = data["name"];
    description = data["description"];
    owner = data["owner_id"];
  }
}

class GuildManager {
  final Collection cache = Collection();

  GuildManager(List<Guild> guilds) {
    for (var guild in guilds) {
      cache.set(guild.id, guild);
    }
  }

  Future<Guild> fetch(String id) async {
    var res = await http.get(Uri.parse("$apiURL/guilds/$id"));
    if (res.statusCode != 200) {
      throw Exception("Error ${res.statusCode} receiving the guild");
    }
    final guild = Guild(json.decode(res.body));
    cache.set(guild.id, guild);
    return guild;
  }
}

class Channel {
  String id = '';
  String name = '';

  Channel(Map data) {
    id = data["id"];
    name = data["name"];
  }
}

class ChannelManager {
  final Collection cache = Collection();

  ChannelManager(List<Channel> channels) {
    for (var channel in channels) {
      cache.set(channel.id, channel);
    }
  }

  Future<Channel> fetch(String id) async {
    var res = await http.get(Uri.parse("$apiURL/channels/$id"));
    if (res.statusCode != 200) {
      throw Exception("Error ${res.statusCode} receiving the channel");
    }
    dynamic channel = Channel(json.decode(res.body));
    cache.set(channel.id, channel);
    return channel;
  }
}

class Role {
  //
}

class RoleManager {
  //
}

class Member {
  User? user;
  RoleManager? roles;
  String joinedAt = '';
  int flags = 0;


  Member(Map data) {
    user = User(data["user"]);
    joinedAt = data["joined_at"];
    int flags = 0;
  }
}


class MemberManager {
  //
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
    id = data["id"];
    bot = data["bot"];
    username = data["username"];
    globalName = data["global_name"];
    displayName = data["display_name"];
    discriminator = data["discriminator"];
    avatar = "https://cdn.discordapp.com/avatars/$id/${data["avatar"]}.webp";
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
typedef Message = Map<String, String>;
