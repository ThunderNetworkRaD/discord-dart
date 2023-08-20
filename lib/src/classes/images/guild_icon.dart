class GuildIcon {
  late String id;
  late String hash;

  GuildIcon(this.hash, this.id);

  String url({String? extension = "jpeg"}) {
    return "https://cdn.discordapp.com/icons/$id/$hash.$extension";
  }
}