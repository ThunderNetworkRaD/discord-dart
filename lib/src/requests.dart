import 'main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final headerswh = {
  "Content-Type": "application/json"
};

Future<http.Response> sendWH(Map content, String token, String id) {
  final url = Uri.parse("$apiURL/webhooks/$id/$token");
  return http.post(url, body: json.encode(content), headers: headerswh);
}

Future<http.Response> editWH(Map content, String token, String id, String mid) {
  final url = Uri.parse("$apiURL/webhooks/$id/$token/messages/$mid");
  return http.patch(url, body: json.encode(content), headers: headerswh);
}

Future<http.Response> getWH(String token, String id, String mid) {
  final url = Uri.parse("$apiURL/webhooks/$id/$token/messages/$mid");
  return http.get(url);
}

Future<http.Response> deleteWH(String token, String id, String mid) {
  final url = Uri.parse("$apiURL/webhooks/$id/$token/messages/$mid");
  return http.delete(url);
}

Future<String> requestWebSocketURL() async {
  final url = Uri.parse("$apiURL/gateway");
  dynamic res = await http.get(url);
  res = json.decode(res.body);
  return res["url"];
}

class Sender {
  String? token;
  Map<String, String> headers = {};

  Sender(token) {
    headers = {
      "Content-Type": "application/json",
      "Authorization": "Bot $token"
    };
  }
}