import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/cat_model.dart';

class ApiService {
  static const String _apiUrl = 'https://api.thecatapi.com/v1/breeds';
  static const String _apiKey =
      'live_99Qe4Ppj34NdplyLW67xCV7Ds0oSLKGgcWWYnSzMJY9C0QOu0HUR4azYxWkyW2nr';

  final http.Client client;
  ApiService({http.Client? client}) : client = client ?? http.Client();

  Future<List<CatBreed>> fetchCatBreeds() async {
    final response = await client.get(
      Uri.parse(_apiUrl),
      headers: {'x-api-key': _apiKey},
    );

    if (response.statusCode == 200) {
      Iterable jsonResponse = json.decode(response.body);
      return jsonResponse.map((breed) => CatBreed.fromJson(breed)).toList();
    } else {
      throw Exception('Failed to load cat breeds');
    }
  }

  Future<List<CatBreed>> searchCatBreeds(String query) async {
    final response = await client.get(
      Uri.parse('$_apiUrl/search?q=$query'),
      headers: {'x-api-key': _apiKey},
    );

    if (response.statusCode == 200) {
      Iterable jsonResponse = json.decode(response.body);
      return jsonResponse.map((breed) => CatBreed.fromJson(breed)).toList();
    } else {
      throw Exception('Failed to search cat breeds');
    }
  }

  Future<CatBreed> fetchCatDetail(String id) async {
    final response = await client.get(
      Uri.parse('$_apiUrl/$id'),
      headers: {'x-api-key': _apiKey},
    );

    if (response.statusCode == 200) {
      return CatBreed.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load cat details');
    }
  }
}
