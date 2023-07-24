# discord.dart
This package is work in progress.

## Webhooks
```dart
import 'package:tn_discord/tn_discord.dart';
main() {
    const webhook = WebookClient(options);
    webhook.send(String message);
}
```
### Webhook Options
- url: String
- id: String
- token: String
url overrides id and token
