import 'package:cat/data/models/cat_model.dart';
import 'package:cat/data/services/api_service.dart';
import 'package:cat/core/constants/app_constants.dart';

class CatRepository {
  final ApiService apiService;

  CatRepository({required this.apiService});

  Future<List<CatBreed>> fetchCatBreeds() async {
    return await ApiService.getListRequest<CatBreed>(
      '/breeds',
      {'x-api-key': AppConstants.apiKey},
      (json) => CatBreed.fromJson(json),
    );
  }

  Future<List<CatBreed>> searchCatBreeds(String query) async {
    return await ApiService.getListRequest<CatBreed>(
      '/breeds/search?q=$query',
      {'x-api-key': AppConstants.apiKey},
      (json) => CatBreed.fromJson(json),
    );
  }

  Future<CatBreed> fetchCatDetail(String id) async {
    return await ApiService.getObjectRequest<CatBreed>(
      '/breeds',
      id,
      {'x-api-key': AppConstants.apiKey},
      (json) => CatBreed.fromJson(json),
    );
  }
}
