import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cat/core/constants/app_constants.dart';

class ApiService {
  final http.Client client;
  ApiService({http.Client? client}) : client = client ?? http.Client();

  static Future<T> getObjectRequest<T>(
    String endpoint,
    String id,
    Map<String, String> headers,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    final url = Uri.parse('${AppConstants.baseApiUrl}$endpoint/$id');
    try {
      final response = await http.get(
        url,
        headers: headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        return fromJson(responseBody);
      } else {
        _handleError(response);
      }
    } catch (e) {
      throw Exception(e.toString());
    }

    throw Exception('Unexpected error: Failed to fetch data from $url');
  }

  static Future<List<TResult>> getListRequest<TResult>(
    String endpoint,
    Map<String, String> headers,
    TResult Function(Map<String, dynamic>) fromJson,
  ) async {
    final url = Uri.parse('${AppConstants.baseApiUrl}$endpoint');
    try {
      final response = await http.get(
        url,
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseBody = jsonDecode(response.body);
        return responseBody
            .map((item) => fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        _handleError(response);
      }
    } catch (e) {
      throw Exception(e.toString());
    }

    throw Exception('Unexpected error: Failed to fetch data from $url');
  }

  static void _handleError(http.Response response) {
    final Map<String, dynamic> responseBody = jsonDecode(response.body);
    final statusCode = response.statusCode;
    if (statusCode == 400) {
      if (responseBody.containsKey('modelState')) {
        final errors = responseBody['modelState'] as Map<String, dynamic>;
        final errorMessages = errors.entries
            .map((entry) => '${entry.key}: ${entry.value.join(', ')}')
            .join('; ');
        throw Exception(errorMessages);
      } else if (responseBody.containsKey('message')) {
        throw Exception(responseBody['message']);
      } else {
        throw Exception('Bad Request: Unknown error occurred');
      }
    } else if (statusCode == 401) {
      throw Exception('Unauthorized: Please check your credentials.');
    } else if (statusCode == 403) {
      throw Exception(
          'Forbidden: You do not have permission to access this resource.');
    } else if (statusCode == 404) {
      throw Exception('Not Found: The requested resource could not be found.');
    } else if (statusCode == 500) {
      throw Exception('Internal Server Error: Please try again later.');
    } else {
      final errorMessage = responseBody['message'] ?? 'Unknown error occurred';
      throw Exception('Error $statusCode: $errorMessage');
    }
  }
}
