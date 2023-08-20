class Command {
  late String name;
  late String description;
  late int type;

  Command({ required this.name, required this.description, this.type = 1 });

  exportable () {
    return {
      "type": type,
      "name": name,
      "description": description
    };
  }
}