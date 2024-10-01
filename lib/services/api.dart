import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Api {
  Future<Response> get(String url) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    var response = await http
        .get(Uri.parse(url), headers: {"Authorization": "Bearer $token"});

    if (kDebugMode) {
      print("GET ON URL:$url");
      print("RESPONSE STATUS CODE : ${response.statusCode}");
      print("RESPONSEBODY : ${response.body}");
    }
    return response;
  }
}
