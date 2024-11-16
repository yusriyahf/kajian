class User {
  int? id;
  String? first_name;
  String? last_name;
  String? email;
  String? token;
  String? role;

  User(
      {this.id,
      this.first_name,
      this.last_name,
      this.email,
      this.token,
      this.role});

  // function to convert json data to user model
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['user']['id'],
        first_name: json['user']['first_name'],
        last_name: json['user']['last_name'],
        email: json['user']['email'],
        role: json['user']['role'],
        token: json['token']);
  }
}
