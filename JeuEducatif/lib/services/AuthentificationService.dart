import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:jeuEducatif/models/user.dart';

class AuthService {
  final String baseUrl = 'http://localhost:8080/api/auth';


  Future<User?> login(String email, String motdepasse) async {
    final url = Uri.parse('$baseUrl/login');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'motdepasse': motdepasse,
        }),
      ).timeout(Duration(seconds: 10)); // ← timeout ici

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final token = data['token'];
        final role = data['role'];
        final nomPrenom = data['nomPrenom'];
        final email = data['email'];
        final id = data['id'];


        if (token == null || nomPrenom == null || email == null || role == null) {
          throw Exception('Réponse invalide du serveur');
        }

        return User(
          token: token,
          role: role,
          nomPrenom: nomPrenom,
          email: email,

        );
      } else {
        String errorMessage = 'Erreur inconnue';

        if (response.body.isNotEmpty) {
          try {
            final error = jsonDecode(response.body);
            errorMessage = error['message'] ?? errorMessage;
          } catch (e) {
            errorMessage = 'Réponse invalide du serveur';
          }
        }

        throw Exception(errorMessage);
      }
    } catch (e) {
      // Affiche l’erreur exacte dans la console
      print('Erreur de connexion : $e');
      throw Exception('Erreur de connexion : $e');
    }
  }

  Future<Map<String, dynamic>> register(String  nomPrenom, String email, String motdepasse,String role,  ) async {
    final url = Uri.parse('$baseUrl/register');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nomPrenom':  nomPrenom ,
          'email': email,
          'motdepasse': motdepasse,
          'role': role,

        }),
      );

      if (response.statusCode == 201) {
        return {'success': true};
      } else {
        String errorMessage = 'Erreur inconnue';

        if (response.body.isNotEmpty) {
          try {
            final error = jsonDecode(response.body);
            errorMessage = error['message'] ?? errorMessage;
          } catch (e) {
            errorMessage = 'Réponse invalide du serveur';
          }
        }

        return {
          'success': false,
          'message': errorMessage,
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Erreur de connexion : $e',
      };
    }
  }

}
