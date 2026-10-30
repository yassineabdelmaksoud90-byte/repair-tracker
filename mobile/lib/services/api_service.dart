import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/intervention.dart';

class ApiService {
  // Émulateur Android -> machine hôte. Pour changer l'adresse :
  // flutter run --dart-define=API_BASE_URL=http://<hote>:8000/api/v1
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8000/api/v1',
  );

  static const Duration _timeout = Duration(seconds: 10);

  static const Map<String, String> _jsonHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static Future<Map<String, dynamic>> login(String gsm, String numero) async {
    final response = await _send(() => http.post(
          Uri.parse('$baseUrl/login'),
          headers: _jsonHeaders,
          body: jsonEncode({'gsm': gsm, 'numero': numero}),
        ));

    final data = (jsonDecode(response.body) as Map<String, dynamic>)['data']
        as Map<String, dynamic>;
    final client = data['client'] as Map<String, dynamic>;
    final intervention = data['intervention'] as Map<String, dynamic>;

    return {
      'client': {...intervention, 'nom': client['nom']},
      'token': data['token'],
    };
  }

  static Future<List<Intervention>> getHistorique(String token) async {
    final response = await _send(() => http.get(
          Uri.parse('$baseUrl/interventions'),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ));

    final list =
        (jsonDecode(response.body) as Map<String, dynamic>)['data'] as List;
    return list
        .map((json) => Intervention.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  static Future<http.Response> _send(
      Future<http.Response> Function() request) async {
    try {
      final response = await request().timeout(_timeout);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return response;
      }
      throw Exception(_errorMessage(response));
    } on TimeoutException {
      throw Exception('Le serveur ne répond pas, réessayez.');
    } on SocketException {
      throw Exception('Connexion impossible. Vérifiez votre réseau.');
    }
  }

  static String _errorMessage(http.Response response) {
    try {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final errors = json['errors'] as Map<String, dynamic>?;
      if (errors != null && errors.isNotEmpty) {
        return (errors.values.first as List).first.toString();
      }
      return json['message']?.toString() ?? 'Erreur ${response.statusCode}';
    } catch (_) {
      return 'Erreur ${response.statusCode}';
    }
  }
}