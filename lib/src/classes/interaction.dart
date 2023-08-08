import 'package:tn_discord/src/requests.dart';

import 'message/message.dart';

class Interaction {
  late String token;
  late String id;

  Interaction(dynamic data) {
    token = data["token"];
    id = data["id"];
  }

  reply(Message message) {
    return interactionReply(id, token, message.exportable());
  }
}