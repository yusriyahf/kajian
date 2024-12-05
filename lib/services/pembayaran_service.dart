import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:kajian/models/api_response.dart';
import 'package:kajian/models/kajian.dart';
import 'package:kajian/models/pembayaran.dart';
import 'package:kajian/services/user_service.dart';
import 'package:http/http.dart' as http;

import '../constant.dart';

// get all posts
Future<ApiResponse> getPembayaran() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(Uri.parse(pembayaranTiket), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['pembayaran']
            .map((PembayaranJson) => Pembayaran.fromJson(PembayaranJson))
            .toList();
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

// Create Pembayaran
Future<ApiResponse> createPembayaran(
  String kajian_id,
  String? bukti_pembayaran,
) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.post(Uri.parse(pembayaranTiket),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: bukti_pembayaran != null
            ? {'kajian_id': kajian_id, 'bukti_pembayaran': bukti_pembayaran}
            : {'kajian_id': kajian_id, 'bukti_pembayaran': bukti_pembayaran});

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

// Edit post
Future<ApiResponse> accPembayaran(
    int pembayaranId, int kajianId, String image) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response =
        await http.post(Uri.parse('$accPembayaranURL/$pembayaranId'), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    }, body: {
      'kajian_id': kajianId.toString(),
      'bukti_pembayaran': image,
    });

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
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

Future<ApiResponse> tolakPembayaran(int pembayaranId) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http
        .post(Uri.parse('$tolakPembayaranURL/$pembayaranId'), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    }, body: {});

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
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
