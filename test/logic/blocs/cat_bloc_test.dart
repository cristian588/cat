import 'package:cat/logic/blocs/cat_bloc/cat_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:cat/data/models/cat_model.dart';
import 'package:cat/data/services/api_service.dart';

class MockApiService extends Mock implements ApiService {}

class FakeCatEvent extends Fake implements CatEvent {}

void main() {
  late MockApiService mockApiService;
  late CatBloc catBloc;

  setUpAll(() {
    registerFallbackValue(FakeCatEvent());
  });

  setUp(() {
    mockApiService = MockApiService();
    catBloc = CatBloc(mockApiService);
  });

  tearDown(() {
    catBloc.close();
  });

  group('CatBloc', () {
    final catBreeds = [
      CatBreed(
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
      ),
    ];

    blocTest<CatBloc, CatState>(
      'emits [CatLoading, CatLoaded] when FetchCatBreeds is added and data is fetched successfully',
      build: () {
        when(() => mockApiService.fetchCatBreeds())
            .thenAnswer((_) async => catBreeds);
        return catBloc;
      },
      act: (bloc) => bloc.add(FetchCatBreeds()),
      expect: () => [
        CatLoading(),
        CatLoaded(catBreeds),
      ],
    );

    blocTest<CatBloc, CatState>(
      'emits [CatLoading, CatError] when FetchCatBreeds is added and fetching data fails',
      build: () {
        when(() => mockApiService.fetchCatBreeds())
            .thenThrow(Exception('Failed to fetch cat breeds'));
        return catBloc;
      },
      act: (bloc) => bloc.add(FetchCatBreeds()),
      expect: () => [
        CatLoading(),
        CatError('Failed to fetch cat breeds'),
      ],
    );
  });
}
