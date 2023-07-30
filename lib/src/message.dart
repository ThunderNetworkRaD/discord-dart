import 'package:tn_discord/src/index.dart';
import 'package:http/http.dart' as http;

Future<http.Response> sendWH(Map content, String token, String id) {
  final url = Uri.parse("$apiURL/webhooks/$id/$token");
  return http.post(url, body: content);
}

Future<http.Response> editWH(Map content, String token, String id, String mid) {
  final url = Uri.parse("$apiURL/webhooks/$id/$token/messages/$mid");
  return http.patch(url, body: content);
}

Future<http.Response> getWH(String token, String id, String mid) {
  final url = Uri.parse("$apiURL/webhooks/$id/$token/messages/$mid");
  return http.get(url);
}
