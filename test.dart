import 'package:tn_discord/tn_discord.dart';

main() {
  var client = Client();

  client.login(
      "OTU2NTczNDc3NzEwNzUzODMy.GmvBek.GEaV7uk-XPcpZ7Xbiohgp_0mm_5NVs5SeAAh7M");

  client.on("READY", (data) {
    print("Hi $data");
  });
}
