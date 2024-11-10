import 'package:kajian/models/kajian.dart';
import 'package:kajian/models/user2.dart';

class TiketModel {
  int? id;
  User2? user;
  Kajian? kajian;
  DateTime? created_at;

  TiketModel({
    this.id,
    this.user,
    this.kajian,
    this.created_at,
  });

  factory TiketModel.fromJson(Map<String, dynamic> json) {
    return TiketModel(
      id: json['id'],
      created_at: DateTime.parse(json['created_at']),
      user: User2.fromJson(json['user']),
      kajian: Kajian.fromJson(json['kajian']),
    );
  }
}
