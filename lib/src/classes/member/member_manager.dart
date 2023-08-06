import '../../collection.dart';
import 'member.dart';
import "../../requests.dart";

class MemberManager {
  final Collection cache = Collection();
  String id;
  final Sender _sender;

  MemberManager(this._sender, List<Member> members, this.id) {
    for (var member in members) {
      cache.set(member.id, member);
    }
  }

  Future<Member> fetch(String id) async {
    var res = await _sender.fetchMember(this.id, id);
    cache.set(id, Member(res));
    return Member(res);
  }
}