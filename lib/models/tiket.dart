import 'package:kajian/models/kajian.dart';
import 'package:kajian/models/user.dart';

class Tiket {
  int? tiket_id;
  User? user;
  Kajian? kajian;

  Tiket({this.tiket_id, this.user, this.kajian});

  // function to convert json data to user model
  factory Tiket.fromJson(Map<String, dynamic> json) {
    return Tiket(
        tiket_id: json['tiket_id'],
        user: User(
            user_id: json['user']['user_id'],
            first_name: json['user']['first_name'],
            last_name: json['user']['last_name']),
        kajian: Kajian(
          kajian_id: json['kajian']['kajian_id'],
          image: json['kajian']['image'],
          title: json['kajian']['title'],
          speaker_name: json['kajian']['speaker_name'],
          theme: json['kajian']['theme'],
          date: json['kajian']['date'],
          location: json['kajian']['location'],
          start_time: json['kajian']['start_time'],
          end_time: json['kajian']['end_time'],
        ));
  }
}
