import '../../requests.dart';
import '../channel/channel.dart';
import '../channel/channel_manager.dart';
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

  // Param                           guild create | fetch | fetch-servers
  late String id;                 //       x      |   x   |      x
  late bool unavailable;          //       x      |   x   |
  String? name;                   //       x      |   x   |      x
  String? icon;                   //       x      |   x   |      x
  String? iconHash;               //       x      |   x   |
  String? splash;                 //       x      |   x   |
  String? discoverySplash;        //       x      |   x   |
  bool? appIsOwner;               //              |       |      x
  Future<Member>? owner;          //              |       |
  String? ownerId;                //       x      |   x   |
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
  
  String? description;
  String? joinedAt;               //       x      |       |
  bool? large;                    //       x      |       |
  int? memberCount;               //       x      |       |

  Guild(this._sender, Map data) {
    id = data["id"];

    // Without discord outages
    if (data["unavailable"] != null && !data["unavailable"]) {
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

      unavailable = data["unavailable"] ?? false;
      name = data["name"];
      icon = data["icon"];
      iconHash = data["icon_hash"];
      splash = data["splash"];
      if (data["discovery_splash"] != null) {
        discoverySplash = data["discovery_splash"];
      } else {
        discoverySplash = null;
      }
      appIsOwner = data["owner"];
      ownerId = data["owner_id"];
      owner = members?.fetch(ownerId.toString());
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
      description = data["description"];

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
    } else if (data["unavailable"] != null) {
      unavailable = data["unavailable"];
    }
  }
}