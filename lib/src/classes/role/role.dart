class Role {
  String id = '';
  String name = '';

  Role(Map data) {
    id = data["id"];
    name = data["name"];
  }
}
