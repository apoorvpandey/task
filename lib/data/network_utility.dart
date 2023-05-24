import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'exceptions/remote_source_exception.dart';

final _indent = ' ' * 11;

void _logRequest(
  Uri url,
  String method, {
  Map<String, String>? headers,
  Map<String, dynamic>? body,
  Map<String, String>? multipartFields,
  List<http.MultipartFile>? multipartFiles,
}) {
  debugPrint('[http] --> $method $url');
  debugPrint('${_indent}headers: $headers');

  if (method == 'POST' || method == 'PUT') {
    debugPrint('${_indent}body: $body');

    if (method == 'POST') {
      if (multipartFields != null) {
        debugPrint('${_indent}multipartFields: $multipartFields');
      }
      if (multipartFields != null) {
        debugPrint('${_indent}multipartFiles: $multipartFiles');
      }
    }
  }
}

void _logResponse(http.Response response) {
  debugPrint('[http] <-- ${response.statusCode} ${response.request}');
  debugPrint('${_indent}bodyBytes: ${response.bodyBytes.length}');
  try {
    log('${_indent}body: ${response.body}');
  } catch (_) {}
}

class NetworkUtils {
  static Future get(
    Uri url, {
    Map<String, String>? headers,
  }) async {
    _logRequest(url, 'GET', headers: headers);

    final response = await http.get(url, headers: headers);
    _logResponse(response);
    return _parse(response);
  }

  static Future put(
    Uri url, {
    Map<String, String>? headers,
    Map<String, String>? body,
  }) =>
      _helper(
        'PUT',
        url,
        headers: headers,
        body: body,
      );

  static Future post(
    Uri url, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) =>
      _helper(
        'POST',
        url,
        headers: headers,
        body: body,
      );

  static Future _helper(
    String method,
    Uri url, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    _logRequest(url, method, headers: headers, body: body);

    debugPrint(body.toString());
    final request = http.Request(method, url);
    if (body != null) {
      request.body = jsonEncode(body);
    }
    if (headers != null) {
      request.headers.addAll(headers);
    }
    final streamedResponse = await request.send();

    final response = await http.Response.fromStream(streamedResponse);
    _logResponse(response);
    return _parse(response);
  }

  static dynamic _parse(http.Response response) {
    final body = response.body;
    final statusCode = response.statusCode;

    final decoded = json.decode(body);
    if (isValidStatus(statusCode, "")) {
      return decoded;
    } else {
      throw RemoteDataSourceException(statusCode, decoded['errorMsg']);
    }
  }

  static bool isValidStatus(int code, String message) {
    switch (code) {
      case 200:
        return true;
      case 201:
        return true;
      case 422:
        return true;
      case 400:
        return true;
      case 404:
        return true;
      default:
        return false;
    }
  }
}
