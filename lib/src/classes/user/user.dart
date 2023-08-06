class User {
  String id = '';
  bool bot = false;
  String username = '';
  String globalName = '';
  String displayName = '';
  int discriminator = 0;
  String avatar = '';

  User(Map data) {
    if (data["id"] == null) {
      return;
    }
    id = data["id"];
    // bot = data["bot"];
    username = data["username"];
    // globalName = data["global_name"];
    // displayName = data["display_name"];
    // discriminator = data["discriminator"];
    // avatar = "https://cdn.discordapp.com/avatars/$id/${data["avatar"]}.webp";
  }
}