import "guild.dart";

class UnavailableGuild {
  late String id;
  late bool unavailable;
  late Guild? notUpdatedGuild;

  UnavailableGuild(this.id, { this.notUpdatedGuild }) {
    unavailable = true;
  }
}