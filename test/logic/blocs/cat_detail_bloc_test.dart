import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:cat/data/models/cat_model.dart';
import 'package:cat/data/services/api_service.dart';
import 'package:cat/logic/blocs/cat_detail_bloc/cat_detail_bloc.dart';

class MockApiService extends Mock implements ApiService {}

class FakeCatDetailEvent extends Fake implements CatDetailEvent {}

void main() {
  late MockApiService mockApiService;
  late CatDetailBloc catDetailBloc;

  setUpAll(() {
    registerFallbackValue(FakeCatDetailEvent());
  });

  setUp(() {
    mockApiService = MockApiService();
    catDetailBloc = CatDetailBloc(mockApiService);
  });

  tearDown(() {
    catDetailBloc.close();
  });

  group('CatDetailBloc', () {
    final catBreed = CatBreed(
      id: 'abys',
      name: 'Abyssinian',
      temperament: 'Active, Energetic, Independent, Intelligent, Gentle',
      origin: 'Egypt',
      description:
          'The Abyssinian is easy to care for, and a joy to have in your home.',
      lifeSpan: '14 - 15',
      adaptability: 5,
      affectionLevel: 5,
      childFriendly: 3,
      dogFriendly: 4,
      energyLevel: 5,
      grooming: 1,
      healthIssues: 2,
      intelligence: 5,
      sheddingLevel: 2,
      socialNeeds: 5,
      strangerFriendly: 5,
      vocalisation: 1,
      indoor: false,
      lap: true,
      imageUrl: 'https://cdn2.thecatapi.com/images/0XYvRd7oD.jpg',
      weight: Weight(imperial: '7 - 10', metric: '3 - 5'),
      cfaUrl: 'http://cfa.org/Breeds/BreedsAB/Abyssinian.aspx',
      vetstreetUrl: 'http://www.vetstreet.com/cats/abyssinian',
      vcahospitalsUrl:
          'https://vcahospitals.com/know-your-pet/cat-breeds/abyssinian',
      wikipediaUrl: 'https://en.wikipedia.org/wiki/Abyssinian_(cat)',
      hypoallergenic: false,
    );

    blocTest<CatDetailBloc, CatDetailState>(
      'emits [CatDetailLoading, CatDetailLoaded] when FetchCatDetail is added and data is fetched successfully',
      build: () {
        when(() => mockApiService.fetchCatDetail('abys'))
            .thenAnswer((_) async => catBreed);
        return catDetailBloc;
      },
      act: (bloc) => bloc.add(FetchCatDetail('abys')),
      expect: () => [
        CatDetailLoading(),
        CatDetailLoaded(catBreed),
      ],
    );

    blocTest<CatDetailBloc, CatDetailState>(
      'emits [CatDetailLoading, CatDetailError] when FetchCatDetail is added and fetching data fails',
      build: () {
        when(() => mockApiService.fetchCatDetail('abys'))
            .thenThrow(Exception('Failed to fetch cat details'));
        return catDetailBloc;
      },
      act: (bloc) => bloc.add(FetchCatDetail('abys')),
      expect: () => [
        CatDetailLoading(),
        CatDetailError('Failed to fetch cat details'),
      ],
    );
  });
}
