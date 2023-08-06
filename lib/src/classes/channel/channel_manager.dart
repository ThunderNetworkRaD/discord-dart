import '../../collection.dart';
import '../../requests.dart';
import './channel.dart';

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