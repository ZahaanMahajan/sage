import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sage_app/repository/home_repository.dart';
import 'package:sage_app/features/home/bloc/home_bloc.dart';

class MoodTracker extends StatelessWidget {
  const MoodTracker({super.key});

  static const List<String> weekDays = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun'
  ];

  void _showCupertinoMoodPicker(BuildContext context) {
    final homeCubit = context.read<HomeBloc>();
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 250,
          color: Colors.white,
          child: CupertinoPicker(
            backgroundColor: Colors.white,
            itemExtent: 32,
            useMagnifier: true,
            magnification: 1.2,
            onSelectedItemChanged: (int index) {
              final selected = HomeRepository.moodScores.keys.elementAt(index);
              final todayIndex = DateTime.now().weekday - 1;
              homeCubit.add(
                SaveMood(mood: selected, dayIndex: todayIndex),
              );
            },
            children: HomeRepository.moodScores.keys
                .map((mood) => Text(mood))
                .toList(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is MoodLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is MoodError) {
          return Center(child: Text('Error: ${state.message}'));
        }

        if (state is MoodLoaded) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Mood Trends',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.teal.shade800,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.only(
                  top: 24,
                  left: 12,
                  right: 36,
                  bottom: 12,
                ),
                height: 260,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        offset: const Offset(5, 5),
                        blurRadius: 5,
                        spreadRadius: 1,
                      ),
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        offset: const Offset(-5, -5),
                        blurRadius: 5,
                        spreadRadius: 1,
                      ),
                    ]),
                child: MoodChart(moodData: state.moodData),
              ),
              SizedBox(
                width: double.infinity,
                child: Center(
                  child: TextButton.icon(
                    iconAlignment: IconAlignment.end,
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(
                      Icons.keyboard_arrow_down_outlined,
                      color: Colors.teal,
                    ),
                    label: const Text(
                      'Select Mood',
                      style: TextStyle(color: Colors.teal),
                    ),
                    onPressed: () => _showCupertinoMoodPicker(context),
                  ),
                ),
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

// mood_chart.dart
class MoodChart extends StatelessWidget {
  final Map<int, double> moodData;

  const MoodChart({
    super.key,
    required this.moodData,
  });

  List<FlSpot> _generateMoodSpots() {
    return List.generate(7, (index) {
      return FlSpot(
        index.toDouble(),
        moodData[index] ?? 0,
      );
    });
  }

  String _getMoodLabel(double value) {
    return HomeRepository.moodScores.entries
        .firstWhere(
          (element) => element.value == value,
          orElse: () => const MapEntry('N/A', 0),
        )
        .key;
  }

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            spots: _generateMoodSpots(),
            // isCurved: true,
            color: Colors.teal,
          ),
        ],
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              reservedSize: 30,
              showTitles: true,
              getTitlesWidget: (value, meta) {
                int index = value.toInt();
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    MoodTracker.weekDays[index],
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 70,
              getTitlesWidget: (value, meta) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Text(
                    _getMoodLabel(value),
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                );
              },
            ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        minY: 0,
        maxY: 5,
        minX: 0,
        maxX: 6,
        gridData: const FlGridData(show: true),
      ),
    );
  }
}
