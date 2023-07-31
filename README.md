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
