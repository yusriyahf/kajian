class User2 {
  int? id;
  String? first_name;
  String? last_name;
  String? email;
  String? token;

  User2({this.id, this.first_name, this.last_name, this.email, this.token});

  // function to convert json data to user model
  factory User2.fromJson(Map<String, dynamic> json) {
    return User2(
        id: json['id'],
        first_name: json['first_name'],
        last_name: json['last_name'],
        email: json['email'],
        token: json['token']);
  }
}
