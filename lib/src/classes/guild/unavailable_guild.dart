/// A guild involved in a server outage.
class UnavailableGuild {
  /// The guild's id
  late String id;
  /// Whether the guild is available to access. If it is not available, it indicates a server outage
  bool unavailable = true;

  UnavailableGuild(this.id);
}