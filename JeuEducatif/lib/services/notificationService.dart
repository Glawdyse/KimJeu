import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/notifications.dart';

class NotificationService {
  final String baseUrl = "http://localhost:8080/api/notifications"; // change selon ton backend

  Future<List<NotificationModel>> fetchNotifications() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => NotificationModel.fromJson(e)).toList();
    } else {
      throw Exception("Erreur lors du chargement des notifications");
    }
  }

}
