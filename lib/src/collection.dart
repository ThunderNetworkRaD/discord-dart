/// A collection of variables. Like NodeJS' Map and discordjs' Collections
/// This will be moved to a separate package in the future.
class Collection {
  final Map<String, dynamic> _variables = {};
  /// Create a new Collection
  Collection();

  /// Adds a new element with key [key] and value [value] to the Map. If an element with the same key already exists, the element will be updated.
  dynamic set(String key, dynamic value) {
    _variables[key] = value;
    return value;
  }

  /// Returns [key] from the Map object. If the value that is associated to the provided key is an object, then you will get a reference to that object and any change made to that object will effectively modify it inside the Map.
  dynamic get(String key) {
    if (_variables[key] == null) {
      throw Exception("Variable not found for $key");
    }
    return _variables[key];
  }

  /// Removes [key] from the Map object.
  void remove(String key) {
    _variables.remove(key);
  }

  /// Alias of [remove]
  void delete(String key) {
    remove(key);
  }

  /// Sum to the value of [key] to [value].
  dynamic add(String key, num value) {
    _variables[key] += value;
    return value + _variables[key];
  }

  /// Subtract [value] from the value of [key].
  dynamic subtract(String key, num value) {
    _variables[key] -= value;
    return _variables[key] - value;
  }

  /// Returns all the variables as a Map.
  Map<String, dynamic> getAll() {
    return _variables;
  }

  /// Returns all the variables' keys as a List.
  List<String> keys() {
    return _variables.keys.toList();
  }

  /// Returns all the variables' values as a List.
  List<dynamic> values() {
    return _variables.values.toList();
  }

  bool has(String key) {
    return _variables.containsKey(key);
  }
}