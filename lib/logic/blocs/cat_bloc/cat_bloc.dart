import 'package:cat/data/models/cat_model.dart';
import 'package:cat/data/services/api_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Events
abstract class CatEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchCatBreeds extends CatEvent {}

class SearchCatBreeds extends CatEvent {
  final String query;

  SearchCatBreeds(this.query);

  @override
  List<Object> get props => [query];
}

// States
abstract class CatState extends Equatable {
  @override
  List<Object> get props => [];
}

class CatInitial extends CatState {}

class CatLoading extends CatState {}

class CatLoaded extends CatState {
  final List<CatBreed> breeds;
  CatLoaded(this.breeds);

  @override
  List<Object> get props => [breeds];
}

class CatError extends CatState {
  final String message;
  CatError(this.message);

  @override
  List<Object> get props => [message];
}

// Bloc
class CatBloc extends Bloc<CatEvent, CatState> {
  final ApiService apiService;

  CatBloc(this.apiService) : super(CatInitial()) {
    on<FetchCatBreeds>(_onFetchCatBreeds);
    on<SearchCatBreeds>(_onSearchCatBreeds);
  }

  Future<void> _onFetchCatBreeds(
      FetchCatBreeds event, Emitter<CatState> emit) async {
    emit(CatLoading());
    try {
      final breeds = await apiService.fetchCatBreeds();
      emit(CatLoaded(breeds));
    } catch (e) {
      emit(CatError('Failed to fetch cat breeds'));
    }
  }

  Future<void> _onSearchCatBreeds(
      SearchCatBreeds event, Emitter<CatState> emit) async {
    emit(CatLoading());
    try {
      final breeds = await apiService.searchCatBreeds(event.query);
      emit(CatLoaded(breeds));
    } catch (e) {
      emit(CatError('Failed to search cat breeds'));
    }
  }
}
