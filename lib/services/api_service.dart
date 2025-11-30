
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models.dart';

class ApiService {
  final String _baseUrl = 'http://localhost:3001/api'; // <-- Port changé à 3001

  // --- Lignes API ---

  Future<List<Ligne>> getLignes() async {
    final response = await http.get(Uri.parse('$_baseUrl/lignes'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => Ligne.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load lignes');
    }
  }

  Future<Ligne> createLigne(Ligne ligne) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/lignes'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(ligne.toJson()),
    );
    if (response.statusCode == 201) {
      return Ligne.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create ligne');
    }
  }

  Future<void> updateLigne(String id, Ligne ligne) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/lignes/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(ligne.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update ligne');
    }
  }

  Future<void> deleteLigne(String id) async {
    final response = await http.delete(Uri.parse('$_baseUrl/lignes/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete ligne');
    }
  }

  // TODO: Add methods for Bus, Incidents, and Utilisateurs
}
