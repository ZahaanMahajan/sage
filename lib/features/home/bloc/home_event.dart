part of 'home_bloc.dart';


abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class LoadMoods extends HomeEvent {}

class SaveMood extends HomeEvent {
  final String mood;
  final int dayIndex;

  const SaveMood({required this.mood, required this.dayIndex});

  @override
  List<Object> get props => [mood, dayIndex];
}