class UserModel {
  final String id;
  final String name;
  final String email;
  final String studentId;
  final String career;
  final String faculty;
  final String?
  profileImageUrl; // Cambiado de profileImagePath a profileImageUrl
  final int reputationPoints;
  final String level;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.studentId,
    required this.career,
    required this.faculty,
    this.profileImageUrl,
    required this.reputationPoints,
    required this.level,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      studentId: json['studentId'] ?? '',
      career: json['career'] ?? '',
      faculty: json['faculty'] ?? '',
      profileImageUrl: json['profileImageUrl'], // Cambiado
      reputationPoints: json['reputationPoints'] ?? 0,
      level: json['level'] ?? 'Principiante',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'studentId': studentId,
      'career': career,
      'faculty': faculty,
      'profileImageUrl': profileImageUrl, // Cambiado
      'reputationPoints': reputationPoints,
      'level': level,
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? studentId,
    String? career,
    String? faculty,
    String? profileImageUrl, // Cambiado
    int? reputationPoints,
    String? level,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      studentId: studentId ?? this.studentId,
      career: career ?? this.career,
      faculty: faculty ?? this.faculty,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl, // Cambiado
      reputationPoints: reputationPoints ?? this.reputationPoints,
      level: level ?? this.level,
    );
  }
}
