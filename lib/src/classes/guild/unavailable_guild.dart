import '../../requests.dart';
import "guild.dart";

class UnavailableGuild {
  final Sender _sender;
  late String id;
  late bool unavailable;
  late Guild? notUpdatedData;

  UnavailableGuild(this._sender, this.id, { this.notUpdatedData }) {
    unavailable = true;
  }
} 