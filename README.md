# discord.dart
[![Pub](https://img.shields.io/pub/v/tn_discord?color=red&logo=dart)](https://github.com/ThunderNetworkRaD/discord.dart)

This package is work in progress.

## Webhooks

### Initializations
```dart
import 'package:tn_discord/tn_discord.dart';
main() {
    const webhook = WebookClient(/*Webhook Options*/);
}
```
### Webhook Options
- url: String
- id: String
- token: String
url overrides id and token

## Credits
We took inspiration from [discord.js](https://github.com/discordjs/discord.js) and [Grapes-discord.grapes](https://github.com/BlackdestinyXX/Grapes-discord.grapes).

### Packages
- [http](https://pub.dev/packages/http) by dart.dev (BSD-3-Clause)
- [events-emitter](https://pub.dev/packages/events_emitter) by drafakiller.com (MIT)
