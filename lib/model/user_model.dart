class User {
  final int? id;
  final String? name;
  final String email;
  final String? token;
  final String? phone;

  User({
    this.id,
    this.name,
    required this.email,
    this.token,
    this.phone,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'] ?? '',
      token: json['token'],
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'token': token,
      'phone': phone,
    };
  }
}
