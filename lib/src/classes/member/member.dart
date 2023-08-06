import '../user/user.dart';

class Member {
  String id = '';
  User user = User({});

  Member(Map data) {
    id = data["user"]["id"];
    user = User(data["user"]);
  }
}