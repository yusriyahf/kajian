import 'package:flutter/material.dart';

TimeOfDay parseTimeOfDay(String time) {
  final parts = time.split(':');
  return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
}

class Kajian {
  int? id;
  int? price;
  String? image;
  String? title;
  String? speaker_name;
  String? theme;
  DateTime? date;
  String? location;
  TimeOfDay? start_time;
  TimeOfDay? end_time;

  Kajian({
    this.id,
    this.price,
    this.image,
    this.title,
    this.speaker_name,
    this.theme,
    this.date,
    this.location,
    this.start_time,
    this.end_time,
  });

  // Factory constructor
  factory Kajian.fromJson(Map<String, dynamic> json) {
    return Kajian(
      id: json['id'],
      price: json['price'],
      image: json['image'],
      title: json['title'],
      speaker_name: json['speaker_name'],
      theme: json['theme'],
      date: DateTime.parse(json['date']),
      location: json['location'],
      start_time: parseTimeOfDay(json['start_time']),
      end_time: parseTimeOfDay(json['end_time']),
    );
  }
}
