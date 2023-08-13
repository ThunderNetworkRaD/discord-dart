class GuildDiscoverySplash  {
  late String id;
  late String hash;

  GuildDiscoverySplash(this.hash, this.id);

  String url({String? extension = "jpeg"}) {
    return "https://cdn.discordapp.com/discovery-splashes/$id/$hash.$extension";
  }
}