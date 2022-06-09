import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/users.dart';

class UsersApi {
  static Future<List<User>> getUsers(String query) async {
    final url = Uri.parse('https://jsonplaceholder.typicode.com/users');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List users = json.decode(response.body);

      return users.map((json) => User.fromJson(json)).where((user) {
        final idLower = user.id.toString();
        final nameLower = user.name.toLowerCase();
        final searchLower = query.toLowerCase();

        return nameLower.contains(searchLower) || idLower.contains(searchLower);
      }).toList();
    } else {
      throw Exception();
    }
  }
}
