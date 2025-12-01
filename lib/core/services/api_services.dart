import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ApiService {
  final _baseUrl = 'http://192.168.64.89:8000/api';

  final Dio dio = Dio();

  Future<dynamic> get({
    required String endPoint,
    @required dynamic body,
    @required String? token,
  }) async {
    Map<String, String> headers = {};

    headers.addAll({'Accept': 'application/json'});
    if (token != null) {
      headers.addAll({'Authorization': 'Bearer $token'});
    }

    var response = await dio.get(
      '$_baseUrl/$endPoint',
      options: Options(headers: headers),
    );
    log('''
========================================
    ${response.data}
========================================
    ''');
    return response.data;
  }

  Future<dynamic> post({
    required String endPoint,
    @required dynamic body,
    @required String? token,
  }) async {
    Map<String, String> headers = {};

    // headers.addAll({'Content-Type': 'application/json'});
    // headers.addAll({'Content-Type': 'application/x-www-form-urlencoded'});
    // headers.addAll({'Accept': 'application/json'});
    if (token != null) {
      headers.addAll({'Authorization': 'Bearer $token'});
    }

    var response = await dio.post(
      '$_baseUrl/$endPoint',
      data: body,
      options: Options(headers: headers),
    );
    log('''
========================================
    ${response.data}
========================================
    ''');
    return response.data;
  }

  Future<dynamic> put({
    required String endPoint,
    @required dynamic body,
    @required String? token,
  }) async {
    Map<String, String> headers = {};

    // headers.addAll({'Content-Type': 'application/json'});
    // headers.addAll({'Accept': 'application/json'});
    if (token != null) {
      headers.addAll({'Authorization': 'Bearer $token'});
    }

    var response = await dio.put(
      '$_baseUrl/$endPoint',
      data: body,
      options: Options(headers: headers),
    );
    return response.data;
  }

  Future<dynamic> delete({
    required String endPoint,
    @required String? token,
  }) async {
    Map<String, String> headers = {};

    headers.addAll({'Content-Type': 'application/json'});
    if (token != null) {
      headers.addAll({'Authorization': 'Bearer $token'});
    }

    var response = await dio.delete(
      '$_baseUrl/$endPoint',
      options: Options(headers: headers),
    );

    return response.data;
  }
}
