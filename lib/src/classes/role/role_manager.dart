import '../../collection.dart';
import './role.dart';

class RoleManager {
  final Collection cache = Collection();

  RoleManager(List<Role> roles) {
    for (var role in roles) {
      cache.set(role.id, role);
    }
  }
}