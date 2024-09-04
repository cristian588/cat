import 'package:cat/data/models/cat_model.dart';
import 'package:cat/data/services/api_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Events
abstract class CatDetailEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchCatDetail extends CatDetailEvent {
  final String catId;
  FetchCatDetail(this.catId);

  @override
  List<Object> get props => [catId];
}

// States
abstract class CatDetailState extends Equatable {
  @override
  List<Object> get props => [];
}

class CatDetailInitial extends CatDetailState {}

class CatDetailLoading extends CatDetailState {}

class CatDetailLoaded extends CatDetailState {
  final CatBreed catBreed;
  CatDetailLoaded(this.catBreed);

  @override
  List<Object> get props => [catBreed];
}

class CatDetailError extends CatDetailState {
  final String message;
  CatDetailError(this.message);

  @override
  List<Object> get props => [message];
}

// Bloc
class CatDetailBloc extends Bloc<CatDetailEvent, CatDetailState> {
  final ApiService apiService;

  CatDetailBloc(this.apiService) : super(CatDetailInitial()) {
    on<FetchCatDetail>(_onFetchCatDetail);
  }

  Future<void> _onFetchCatDetail(
      FetchCatDetail event, Emitter<CatDetailState> emit) async {
    emit(CatDetailLoading());
    try {
      final catBreed = await apiService.fetchCatDetail(event.catId);
      emit(CatDetailLoaded(catBreed));
    } catch (e) {
      emit(CatDetailError('Failed to fetch cat details'));
    }
  }
}
