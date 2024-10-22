part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class MoodInitial extends HomeState {}

class MoodLoading extends HomeState {}

class MoodLoaded extends HomeState {
  final Map<int, double> moodData;
  final String selectedMood;

  const MoodLoaded({
    required this.moodData,
    this.selectedMood = 'Happy',
  });

  @override
  List<Object> get props => [moodData, selectedMood];

  MoodLoaded copyWith({
    Map<int, double>? moodData,
    String? selectedMood,
  }) {
    return MoodLoaded(
      moodData: moodData ?? this.moodData,
      selectedMood: selectedMood ?? this.selectedMood,
    );
  }
}

class MoodError extends HomeState {
  final String message;

  const MoodError(this.message);

  @override
  List<Object> get props => [message];
}