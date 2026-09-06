class ProfileModel {
  final String name;
  final String email;
  final String role;
  final String imageUrl;

  ProfileModel({
    required this.name,
    required this.email,
    this.role = 'Student',
    this.imageUrl = '',
  });

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      name: map['name'] ?? 'Student',
      email: map['email'] ?? '',
      role: map['role'] ?? 'Student',
      imageUrl: map['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'role': role,
      'imageUrl': imageUrl,
    };
  }
}