import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kajian/models/api_response.dart';
import 'package:kajian/models/kajian.dart';
import 'package:kajian/services/user_service.dart';
import 'package:http/http.dart' as http;

import '../constant.dart';

// get all posts
Future<ApiResponse> getKajian() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(Uri.parse(kajianURL), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['kajian']
            .map((kajianJson) => Kajian.fromJson(kajianJson))
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

// get all posts
Future<ApiResponse> getKajianToday() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(Uri.parse(kajianTodayURL), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['kajian']
            .map((kajianTodayJson) => Kajian.fromJson(kajianTodayJson))
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

Future<ApiResponse> getKajianLast() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(Uri.parse(kajianLastURL), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['kajian']
            .map((kajianLastJson) => Kajian.fromJson(kajianLastJson))
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

// Create post
Future<ApiResponse> createKajian(
    String title,
    String speaker_name,
    String theme,
    String date,
    String location,
    String start_time,
    String end_time,
    String? image) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.post(Uri.parse(kajianURL),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: image != null
            ? {
                'image': image,
                'title': title,
                'speaker_name': speaker_name,
                'theme': theme,
                'date': date,
                'location': location,
                'start_time': start_time,
                'end_time': end_time,
              }
            : {
                'title': title,
                'speaker_name': speaker_name,
                'theme': theme,
                'date': date,
                'location': location,
                'start_time': start_time,
                'end_time': end_time,
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

// Edit post
Future<ApiResponse> editPost(
    int postId,
    String title,
    String speaker_name,
    String theme,
    DateTime date,
    String location,
    TimeOfDay start_time,
    TimeOfDay end_time) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.put(Uri.parse('$kajianURL/$postId'), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    }, body: {
      'title': title,
      'speaker_name': speaker_name,
      'date': date,
      'location': location,
      'start_time': start_time,
      'end_time': end_time,
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

// Delete post
Future<ApiResponse> deletePost(int postId) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.delete(Uri.parse('$kajianURL/$postId'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
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
