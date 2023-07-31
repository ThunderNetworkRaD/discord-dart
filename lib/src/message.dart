import 'package:tn_discord/src/index.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final headers = {'Content-Type': 'application/json'};

Future<http.Response> sendWH(Map content, String token, String id) {
  final url = Uri.parse("$apiURL/webhooks/$id/$token");
  return http.post(url, body: json.encode(content), headers: headers);
}

Future<http.Response> editWH(Map content, String token, String id, String mid) {
  final url = Uri.parse("$apiURL/webhooks/$id/$token/messages/$mid");
  return http.patch(url, body: json.encode(content), headers: headers);
}

Future<http.Response> getWH(String token, String id, String mid) {
  final url = Uri.parse("$apiURL/webhooks/$id/$token/messages/$mid");
  return http.get(url);
}

Future<http.Response> deleteWH(String token, String id, String mid) {
  final url = Uri.parse("$apiURL/webhooks/$id/$token/messages/$mid");
  return http.delete(url);
}
