import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sage_app/repository/home_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository _repository;

  HomeBloc({required HomeRepository repository})
      : _repository = repository,
        super(MoodInitial()) {
    on<LoadMoods>(_onLoadMoods);
    on<SaveMood>(_onSaveMood);
  }

  Future<void> _onLoadMoods(
      LoadMoods event,
      Emitter<HomeState> emit,
      ) async {
    emit(MoodLoading());
    try {
      final moodData = await _repository.loadMoods();
      emit(MoodLoaded(moodData: moodData));
    } catch (e) {
      emit(MoodError(e.toString()));
    }
  }

  Future<void> _onSaveMood(
      SaveMood event,
      Emitter<HomeState> emit,
      ) async {
    final currentState = state;
    if (currentState is MoodLoaded) {
      try {
        await _repository.saveMood(event.dayIndex, event.mood);
        final updatedMoodData = Map<int, double>.from(currentState.moodData);
        updatedMoodData[event.dayIndex] = HomeRepository.moodScores[event.mood]!;

        emit(currentState.copyWith(
          moodData: updatedMoodData,
          selectedMood: event.mood,
        ));
      } catch (e) {
        emit(MoodError(e.toString()));
        emit(currentState); // Revert to previous state
      }
    }
  }
}