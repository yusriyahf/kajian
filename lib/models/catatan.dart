import 'package:kajian/models/user.dart';

class Catatan {
  int? id;
  int? userId;
  String? title;
  String? description;
  String? createdAt;

  Catatan({this.id, this.userId, this.title, this.description, this.createdAt});

  // function to convert json data to user model
  factory Catatan.fromJson(Map<String, dynamic> json) {
    return Catatan(
      id: json['id'],
      userId: json['user_id'],
      title: json['title'],
      description: json['description'],
      createdAt: json['created_at'],
    );
  }
}
