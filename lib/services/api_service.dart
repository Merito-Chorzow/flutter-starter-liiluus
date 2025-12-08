// lib/services/api_service.dart
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/journal_entry.dart';

class ApiService {
  /// TU WSTAW SWÓJ URL Z MOCKAPI
  /// np. 'https://6934200f4090fe3bf01f026e.mockapi.io/entries'
  static const String baseUrl =
      'https://6934200f4090fe3bf01f026e.mockapi.io/entries';

  final http.Client _client = http.Client();

  Future<List<JournalEntry>> fetchEntries() async {
    try {
      final response = await _client.get(Uri.parse(baseUrl));

      // Debug w konsoli
      print('GET $baseUrl -> ${response.statusCode}');
      // print('BODY: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data
            .map((e) => JournalEntry.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Błąd API: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('Brak połączenia z internetem');
    } catch (e) {
      throw Exception('Nie udało się pobrać wpisów: $e');
    }
  }

  Future<JournalEntry> createEntry(JournalEntry entry) async {
    try {
      final bodyJson = jsonEncode(entry.toJson());
      print('POST $baseUrl');
      print('REQUEST BODY: $bodyJson');

      final response = await _client.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: bodyJson,
      );

      print('RESPONSE STATUS: ${response.statusCode}');
      print('RESPONSE BODY: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return JournalEntry.fromJson(data);
      } else {
        throw Exception('Błąd API przy zapisie: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('Brak połączenia z internetem');
    } catch (e) {
      throw Exception('Nie udało się zapisać wpisu: $e');
    }
  }
}
