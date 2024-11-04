import 'dart:convert';

import 'package:kajian/models/api_response.dart';
import 'package:kajian/models/tiket.dart';
import 'package:kajian/services/user_service.dart';
import 'package:http/http.dart' as http;

import '../constant.dart';

// get all TIKET
Future<ApiResponse> getTiket() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(Uri.parse(tiketURL), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['tiket']
            .map((p) => Tiket.fromJson(p))
            .toList();
        // we get list of posts, so we need to map each item to post model
        apiResponse.data as List<dynamic>;
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}
