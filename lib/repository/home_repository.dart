import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  HomeRepository({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  static const Map<String, double> moodScores = {
    'Happy': 5,
    'Excited': 4,
    'Neutral': 3,
    'Anxious': 2,
    'Sad': 1,
    'N/A': 0,
  };

  Future<Map<int, double>> loadMoods() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    // final now = DateTime.now();
    //final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    //final endOfWeek = startOfWeek.add(const Duration(days: 6));

    final querySnapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('moods')
        .get();

    final Map<int, double> moodData = {};
    for (var doc in querySnapshot.docs) {
      final data = doc.data();
      final date = (data['date'] as Timestamp).toDate();
      final dayIndex = date.weekday - 1;
      moodData[dayIndex] = data['score'].toDouble();
    }

    return moodData;
  }

  Future<void> saveMood(int dayIndex, String mood) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final selectedDate = startOfWeek.add(Duration(days: dayIndex));
    final docId = selectedDate.toIso8601String().split('T')[0];

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('moods')
        .doc(docId)
        .set({
      'date': Timestamp.fromDate(selectedDate),
      'mood': mood,
      'score': moodScores[mood],
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}