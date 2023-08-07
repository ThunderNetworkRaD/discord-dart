import 'base_image.dart';

class GuildSplash extends BaseImage {
  late String id;

  GuildSplash(String hash, this.id) : super(hash) {
    this.hash = hash;
  }

  String url({String? extension = "jpeg"}) {
    return "https://cdn.discordapp.com/splashes/$id/$hash.$extension";
  }
}