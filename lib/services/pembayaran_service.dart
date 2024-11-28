import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:kajian/models/api_response.dart';
import 'package:kajian/models/kajian.dart';
import 'package:kajian/services/user_service.dart';
import 'package:http/http.dart' as http;

import '../constant.dart';

// Create Pembayaran
Future<ApiResponse> createPembayaran(
  String kajian_id,
) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.post(Uri.parse(kajianURL), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    }, body: {
      'kajian_id': kajian_id,
    });

    // here if the image is null we just send the body, if not null we send the image too

    switch (response.statusCode) {
      case 200:
      // apiResponse.data = jsonDecode(response.body);
      // break;
      case 201: // Jika status kode 201 (Created)
        apiResponse.data = jsonDecode(response.body);
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        print(response.body);
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}
