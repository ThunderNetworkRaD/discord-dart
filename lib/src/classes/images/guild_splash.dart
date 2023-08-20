class GuildSplash  {
  late String id;
  late String hash;

  GuildSplash(this.hash, this.id);

  String url({String? extension = "jpeg"}) {
    return "https://cdn.discordapp.com/splashes/$id/$hash.$extension";
  }
}