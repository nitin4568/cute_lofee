import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {

  static const String baseUrl = "https://saavn.sumit.co/api";

  Future<dynamic> getRequest(String endpoint) async {

    final response = await http.get(
      Uri.parse("$baseUrl$endpoint"),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("API Error");
    }
  }

}