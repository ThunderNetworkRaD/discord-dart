import 'base_image.dart';

class GuildIcon extends BaseImage {
  late String id;

  GuildIcon(String hash, this.id) : super(hash) {
    this.hash = hash;
  }

  String url({String? extension = "jpeg"}) {
    return "https://cdn.discordapp.com/icons/$id/$hash.$extension";
  }
}