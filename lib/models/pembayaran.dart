import 'package:flutter/material.dart';
import 'package:kajian/models/kajian.dart';
import 'package:kajian/models/user2.dart';

TimeOfDay parseTimeOfDay(String time) {
  final parts = time.split(':');
  return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
}

class Pembayaran {
  int? id;
  User2? user;
  Kajian? kajian;
  DateTime? date;
  String? status;
  String? bukti_pembayaran;
  DateTime? created_at;

  Pembayaran({
    this.id,
    this.user,
    this.kajian,
    this.date,
    this.status,
    this.bukti_pembayaran,
    this.created_at,
  });

  // Factory constructor
  factory Pembayaran.fromJson(Map<String, dynamic> json) {
    return Pembayaran(
      id: json['id'],
      user: User2.fromJson(json['user']),
      kajian: Kajian.fromJson(json['kajian']),
      date: DateTime.parse(json['date']),
      status: json['status'],
      bukti_pembayaran: json['bukti_pembayaran'],
      created_at: DateTime.parse(json['created_at']),
    );
  }
}
