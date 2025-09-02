import 'dart:convert';
import 'package:http/http.dart' as http;

class User {
  final String id;
  final String username;
  final String email;
  final String role;

  User({required this.id, required this.username, required this.email, required this.role});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      role: json['role'],
    );
  }
}

class UserService {
  final String baseUrl = "http://localhost:8080/api/users"; // adapte selon ton backend

  Future<List<User>> fetchUsers() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception("Erreur lors du chargement des utilisateurs");
    }
  }
}
