import "../../collection.dart";
import "../../requests.dart";
import './guild.dart';

class GuildManager {
  final cache = Collection();
  final Sender _sender;

  GuildManager(this._sender, List<Guild> guilds) {
    for (var guild in guilds) {
      cache.set(guild.id, guild);
    }
  }

  Future<Guild> fetch(String id) async {
    var res = await _sender.fetchGuild(id);
    final guild = Guild(_sender, res);
    Guild oldGuild = cache.get(guild.id);
    oldGuild.members?.cache.values().forEach((member) {
      guild.members?.cache.set(member.id, member);
    });
    oldGuild.channels?.cache.values().forEach((channel) {
      guild.channels?.cache.set(channel.id, channel);
    });
    guild.joinedAt = oldGuild.joinedAt;
    guild.large = oldGuild.large;
    guild.unavailable = oldGuild.unavailable;
    guild.memberCount = oldGuild.memberCount;
    guild.owner = oldGuild.owner;
    cache.set(guild.id, guild);
    return guild;
  }
}