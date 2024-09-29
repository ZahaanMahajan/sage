class UserSession {
  static final UserSession _instance = UserSession._internal();

  String? age;
  DateTime? createdAt;
  String? email;
  String? gender;
  bool? hadCounsellingBefore;
  String? profession;
  String? uid;
  String? username;

  // Private constructor
  UserSession._internal();

  // Singleton instance getter
  static UserSession get instance => _instance;

  // Function to initialize user data
  void initialize({
    required String age,
    required DateTime createdAt,
    required String email,
    required String gender,
    required bool hadCounsellingBefore,
    required String profession,
    required String uid,
    required String username,
  }) {
    this.age = age;
    this.createdAt = createdAt;
    this.email = email;
    this.gender = gender;
    this.hadCounsellingBefore = hadCounsellingBefore;
    this.profession = profession;
    this.uid = uid;
    this.username = username;
  }

  // Clear user data (if needed)
  void clear() {
    age = null;
    createdAt = null;
    email = null;
    gender = null;
    hadCounsellingBefore = null;
    profession = null;
    uid = null;
    username = null;
  }
}
