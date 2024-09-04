import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;
import 'package:cat/data/services/api_service.dart';

class MockHttpClient extends Mock implements http.Client {}

class FakeUri extends Fake implements Uri {}

void main() {
  late MockHttpClient mockHttpClient;
  late ApiService apiService;

  setUpAll(() {
    registerFallbackValue(FakeUri());
  });

  setUp(() {
    mockHttpClient = MockHttpClient();
    apiService = ApiService(client: mockHttpClient);
  });

  group('ApiService', () {
    test('fetchCatBreeds returns list of breeds on successful response',
        () async {
      const mockJsonResponse = '''
      [
        {
          "id": "abys",
          "name": "Abyssinian",
          "temperament": "Active, Energetic, Independent, Intelligent, Gentle",
          "origin": "Egypt",
          "description": "The Abyssinian is easy to care for, and a joy to have in your home.",
          "life_span": "14 - 15",
          "adaptability": 5,
          "affection_level": 5,
          "child_friendly": 3,
          "dog_friendly": 4,
          "energy_level": 5,
          "grooming": 1,
          "health_issues": 2,
          "intelligence": 5,
          "shedding_level": 2,
          "social_needs": 5,
          "stranger_friendly": 5,
          "vocalisation": 1,
          "indoor": 0,
          "lap": 1,
          "image_url": "https://cdn2.thecatapi.com/images/0XYvRd7oD.jpg",
          "weight": {"imperial": "7 - 10", "metric": "3 - 5"},
          "cfa_url": "http://cfa.org/Breeds/BreedsAB/Abyssinian.aspx",
          "vetstreet_url": "http://www.vetstreet.com/cats/abyssinian",
          "vcahospitals_url": "https://vcahospitals.com/know-your-pet/cat-breeds/abyssinian",
          "wikipedia_url": "https://en.wikipedia.org/wiki/Abyssinian_(cat)",
          "hypoallergenic": 0
        }
      ]
      ''';

      when(() => mockHttpClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response(mockJsonResponse, 200));

      final breeds = await apiService.fetchCatBreeds();

      expect(breeds.isNotEmpty, true);
      expect(breeds.first.name, 'Abyssinian');
    });

    test('fetchCatBreeds throws an exception on a failed response', () async {
      when(() => mockHttpClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(() => apiService.fetchCatBreeds(), throwsA(isA<Exception>()));
    });
  });
}
