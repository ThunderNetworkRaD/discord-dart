import 'command.dart';
import '../../requests.dart';

class CommandManager {
  final Sender _sender;

  CommandManager(this._sender);

  create(Command cmd, { String? guildID }) async {
    if (guildID != null) {
      await _sender.createGuildCommands(guildID, cmd);
    } else {
      await _sender.createGlobalCommands(cmd);
    }
  }
}