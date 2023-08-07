import "guild.dart";

class UnavailableGuild {
  late String id;
  late bool unavailable;
  late Guild? notUpdatedData;

  UnavailableGuild(this.id, { this.notUpdatedData }) {
    unavailable = true;
  }
}