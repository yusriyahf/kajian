import 'package:kajian/models/kajian.dart';
import 'package:kajian/models/user.dart';

class Tiket {
  int? id;
  User? user;
  Kajian? kajian;

  Tiket({this.id, this.user, this.kajian});

  // function to convert json data to user model
  // factory Tiket.fromJson(Map<String, dynamic> json) {
  //   return Tiket(
  //       id: json['id'],
  //       user: User(
  //           id: json['user']['id'],
  //           first_name: json['user']['first_name'],
  //           last_name: json['user']['last_name']),
  //       kajian: Kajian(
  //         id: json['kajian']['id'],
  //         image: json['kajian']['image'],
  //         title: json['kajian']['title'],
  //         speaker_name: json['kajian']['speaker_name'],
  //         theme: json['kajian']['theme'],
  //         date: json['kajian']['date'],
  //         location: json['kajian']['location'],
  //         start_time: json['kajian']['start_time'],
  //         end_time: json['kajian']['end_time'],
  //       ));
  // }

  factory Tiket.fromJson(Map<String, dynamic> json) {
    return Tiket(
      id: json['id'],
      user: json['user'] != null
          ? User(
              id: json['user']['id'],
              first_name: json['user']['first_name'],
              last_name: json['user']['last_name'])
          : null,
      kajian: json['kajian'] != null
          ? Kajian(
              id: json['kajian']['id'],
              image: json['kajian']['image'],
              title: json['kajian']['title'],
              speaker_name: json['kajian']['speaker_name'],
              theme: json['kajian']['theme'],
              date: json['kajian']['date'],
              location: json['kajian']['location'],
              start_time: json['kajian']['start_time'],
              end_time: json['kajian']['end_time'])
          : null,
    );
  }
}
