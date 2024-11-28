// ----- STRINGS ------
import 'package:flutter/material.dart';

const baseURL = 'http://192.168.20.7:8000/api';
const loginURL = baseURL + '/login';
const registerURL = baseURL + ' /register';
const logoutURL = baseURL + '/logout';
const userURL = baseURL + '/user';
const passwordURL = baseURL + '/password';
const kajianURL = baseURL + '/kajian';
const tiketURL = baseURL + '/tiket';
const commentsURL = baseURL + '/comments';
const catatanURL = baseURL + '/catatan';
const kajianLastURL = baseURL + '/kajianlast';
const tiketCok = baseURL + '/tiketlast';
const kajianTodayURL = baseURL + '/kajiantoday';
const totalUserURL = baseURL + '/totaluser';
const upBayar = baseURL + '/tiket/up_bayar';
const pembayaranTiket = baseURL + '/pembayaran';

// ----- Errors -----
const serverError = 'Server error';
const unauthorized = 'Unauthorized';
const somethingWentWrong = 'Something went wrong, try again!';
