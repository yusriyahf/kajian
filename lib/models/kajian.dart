import 'package:flutter/material.dart';

class Kajian {
  int? kajian_id;
  String? image;
  String? title;
  String? speaker_name;
  String? theme;
  DateTime? date;
  String? location;
  TimeOfDay? start_time;
  TimeOfDay? end_time;

  Kajian({
    this.kajian_id,
    this.image,
    this.title,
    this.speaker_name,
    this.theme,
    this.date,
    this.location,
    this.start_time,
    this.end_time,
  });

// map json to kajian model

  factory Kajian.fromJson(Map<String, dynamic> json) {
    return Kajian(
      kajian_id: json['kajian_id'],
      image: json['image'],
      title: json['title'],
      speaker_name: json['speaker_name'],
      theme: json['theme'],
      date: json['date'],
      location: json['location'],
      start_time: json['start_time'],
      end_time: json['end_time'],
    );
  }
}
