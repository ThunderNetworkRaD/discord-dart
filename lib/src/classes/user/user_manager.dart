import 'dart:convert';

import "package:http/http.dart" as http;

import '../../../tn_discord.dart';
import '../../collection.dart';

class UserManager {
  final Collection cache = Collection();

  UserManager(List<User> users) {
    for (var user in users) {
      cache.set(user.id, user);
    }
  }

  Future<User> fetch(String id) async {
    var res = await http.get(Uri.parse("$apiURL/users/$id"));
    if (res.statusCode != 200) {
      throw Exception("Error ${res.statusCode} receiving the user");
    }
    dynamic user = User(json.decode(res.body));
    cache.set(user.id, user);
    return user;
  }
}