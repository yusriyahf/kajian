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
      kajian_id: json['kajian']['kajian_id'],
      image: json['kajian']['image'],
      title: json['kajian']['title'],
      speaker_name: json['kajian']['speaker_name'],
      theme: json['kajian']['theme'],
      date: json['kajian']['date'],
      location: json['kajian']['location'],
      start_time: json['kajian']['start_time'],
      end_time: json['kajian']['end_time'],
    );
  }
}
