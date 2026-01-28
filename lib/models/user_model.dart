class UserModel {
  final int id;
  final String email;
  final String name;

  UserModel({required this.id, required this.email, required this.name});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['Id'] ?? json['id'],
      email: json['Email'] ?? json['email'],
      name: json['Name'] ?? json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'email': email, 'name': name};
  }
}
