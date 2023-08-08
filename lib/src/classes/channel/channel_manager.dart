import '../../collection.dart';
import '../../requests.dart';
import './channel.dart';

class ChannelManager {
  final Collection cache = Collection();
  final Sender _sender;
  late bool main;

  ChannelManager(this._sender, List<Channel> channels, { this.main = false }) {
    for (var channel in channels) {
      cache.set(channel.id, channel);
      if (!main) {
        _sender.channels.cache.set(channel.id, channel);
      }
    }
  }

  /// Fetch a channel from discord
  /// If you use the [fetch] method with client.channels, guild channels manager
  /// will not be updated
  Future<Channel> fetch(String id) async {
    var res = await _sender.fetchChannel(id);
    dynamic channel = Channel(_sender, res);
    cache.set(channel.id, channel);
    return channel;
  }
}