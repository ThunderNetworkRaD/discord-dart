import 'base_image.dart';

class GuildIcon extends BaseImage {
  late String id;
  GuildIcon(String hash, this.id) : super(hash) {
    this.hash = hash;
  }

  String url(String? extension) {
    return "https://cdn.discordapp.com/guild-icons/$id/$hash.$extension";
  }
}