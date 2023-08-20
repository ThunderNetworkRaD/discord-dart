import '../images/guild_discovery_splash.dart';
import '../images/guild_icon.dart';

import '../../requests.dart';
import '../channel/channel.dart';
import '../channel/channel_manager.dart';
import '../images/guild_splash.dart';
import '../member/member.dart';
import '../member/member_manager.dart';
import '../role/role.dart';
import '../role/role_manager.dart';

/// Represents a guild (aka server) on Discord.
class Guild {
  final Sender _sender;

  ChannelManager? channels;
  MemberManager? members;
  RoleManager? roles;

  /// The guild's id
  late String id;
  /// Whether the guild is available to access. If it is not available, it indicates a server outage
  bool unavailable = false;
  /// The name of this guild
  late String name;
  /// The icon hash of this guild
  late String? iconHash;
  /// The icon of this guild
  late GuildIcon? icon;
  /// The hash of the guild invite splash image
  late String? splashHash;
  /// The guild invite splash image of this guild
  late GuildSplash? splash;
  /// The hash of the guild discovery splash image
  late String? discoverySplashHash;
  /// The guild discovery splash image of this guild
  late GuildDiscoverySplash? discoverySplash;
  /// The owner of this guild
  late Future<Member>? owner;
  /// The owner id of this guild
  String? ownerId;
  String? permissions;            //              |       |      x
  String? afkChannelId;           //       x      |   x   |
  int? afkTimeout;                //       x      |   x   |
  bool? widgetEnabled;            //       x      |   x   |
  String? widgetChannelId;        //       x      |   x   |
  int? verificationLevel;         //       x      |   x   |
  int? defaultMessageNotifications; //     x      |   x   |
  int? explicitContentFilter;     //       x      |   x   |
  List? features;                 //              |       |      x
  int? mfaLevel;                  //       x      |   x   |
  String? applicationId;          //       x      |   x   |
  String? systemChannelId;        //       x      |   x   |
  int? systemChannelFlags;        //       x      |   x   |
  String? rulesChannelId;         //       x      |   x   |
  int? maxPresences;              //       x      |   x   |
  int? maxMembers;                //       x      |   x   |
  String? vanityUrlCode;          //       x      |   x   |
  String? description;            //       x      |   x   |
  String? banner;                 //       x      |   x   |
  int? premiumTier;               //       x      |   x   |
  int? premiumSubscriptionCount;  //       x      |   x   |
  String? preferredLocale;        //       x      |   x   |
  String? publicUpdatesChannelId; //       x      |   x   |
  int? maxVideoChannelUsers;      //       x      |   x   |
  int? maxStageVideoChannelUsers; //              |   x   |      x
  int? approximateMemberCount;    //              |   x   |      x
  int? approximatePresenceCount;  //              |   x   |      x
  bool? premiumProgressBarEnabled;//       x      |   x   |
  String? safetyAlertsChannelId;  //       x      |   x   |
  String? joinedAt;               //       x      |       |
  bool? large;                    //       x      |       |
  int? memberCount;               //       x      |       |
  // Param                           guild create | fetch | fetch-servers

  Guild(this._sender, Map data) {
    id = data["id"];
    if(data["channels"] != null && data["members"] != null && data["roles"] != null) {
      List<Channel> cc = [];
      for (var c in data["channels"]) {
        cc.add(Channel(_sender, c));
      }
      channels = ChannelManager(_sender, cc);

      List<Member> mm = [];
      for (var m in data["members"]) {
        mm.add(Member(m));
      }
      members = MemberManager(_sender, mm, id);

      List<Role> rr = [];
      for (var r in data["roles"]) {
        rr.add(Role(r));
      }
      roles = RoleManager(rr);
    } else {
      channels = ChannelManager(_sender, []);
      members = MemberManager(_sender, [], id);
      roles = RoleManager([]);
    }

    name = data["name"];

    iconHash = data["icon_hash"];
    if (iconHash != null) {
      icon = GuildIcon(iconHash!, id);
    } else {
      icon = null;
    }

    splashHash = data["splash"];
    if (splashHash != null) {
      splash = GuildSplash(splashHash!, id);
    } else {
      splash = null;
    }

    discoverySplashHash = data["discovery_splash"];
    if (discoverySplashHash != null) {
      discoverySplash = GuildDiscoverySplash(discoverySplashHash!, id);
    } else {
      discoverySplash = null;
    }

    ownerId = data["owner_id"];
    if (ownerId != null) {
      owner = members!.fetch(ownerId.toString());
    } else {
      owner = null;
    }
    permissions = data["permissions"];
    afkChannelId = data["afk_channel_id"];
    afkTimeout = data["afk_timeout"];
    widgetEnabled = data["widget_enabled"];
    widgetChannelId = data["widget_channel_id"];
    verificationLevel = data["verification_level"];
    defaultMessageNotifications = data["default_message_notifications"];
    explicitContentFilter = data["explicit_content_filter"];
    features = data["features"];
    mfaLevel = data["mfa_level"];
    applicationId = data["application_id"];
    systemChannelId = data["system_channel_id"];
    systemChannelFlags = data["system_channel_flags"];
    rulesChannelId = data["rules_channel_id"];
    maxPresences = data["max_presences"];
    maxMembers = data["max_members"];
    vanityUrlCode = data["vanity_url_code"];
    description = data["description"];
    banner = data["banner"];
    premiumTier = data["premium_tier"];
    premiumSubscriptionCount = data["premium_subscription_count"];
    preferredLocale = data["preferred_locale"];
    publicUpdatesChannelId = data["public_updates_channel_id"];
    maxVideoChannelUsers = data["max_video_channel_users"];
    maxStageVideoChannelUsers = data["max_stage_video_channel_users"];
    premiumProgressBarEnabled = data["premium_progress_bar_enabled"];
    safetyAlertsChannelId = data["safety_alerts_channel_id"];

    if (data["approximate_member_count"] != null) {
      approximateMemberCount = data["approximate_member_count"];
    }
    if (data["approximate_presence_count"] != null) {
      approximatePresenceCount = data["approximate_presence_count"];
    }

    // GuildCreate only
    if (data["joined_at"] != null) {
      joinedAt = data["joined_at"];
    }
    if (data["large"] != null) {
      large = data["large"];
    }
    if (data["member_count"] != null) {
      memberCount = data["member_count"];
    }
  }
}