// ignore_for_file: constant_identifier_names

/// A list of all Gateway Intents Bits.
class GatewayIntentBits {
  static const Guilds = 1;
  static const GuildMembers = 2;
  static const GuildModeration = 4;
  static const GuildEmojisAndStickers = 8;
  static const GuildIntegrations = 16;
  static const GuildWebhooks = 32;
  static const GuildInvites = 64;
  static const GuildVoiceStates = 128;
  static const GuildPresences = 256;
  static const GuildMessages = 512;
  static const GuildMessageReactions = 1024;
  static const GuildMessageTyping = 2048;
  static const DirectMessages = 4096;
  static const DirectMessageReactions = 8192;
  static const DirectMessageTyping = 16384;
  static const MessageContent = 32768;
  static const GuildScheduledEvents = 65536;
  static const AutoModerationConfiguration = 1048576;
  static const AutoModerationExecution = 2097152;
}