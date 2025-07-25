// import 'dart:developer';
// import 'package:dio/dio.dart' as dio;

// class Network {
//   static dio.Response? response;
//   static final dio.Dio _dio = dio.Dio();

//   static Future<dynamic> postApi(var token, var endUrl, var data,
//       var header) async {
//     try {
//       response = await _dio.post(
//         '$endUrl',
//         options: dio.Options(headers: header),
//         data: data,
//       );
//       log(response.toString());
//       return response!.data;
//     } on dio.DioException catch (e) {
//       if (e.response == null) {
//         log("===========> Error: ${e.error}");
//       } else {
//         return e.response!.data;
//       }
//     }
//   }

//   static Future<dynamic> getApi(var endUrl) async {
//     try {
//       response = await _dio.get(
//         '$endUrl',
//       );
//       log(response.toString());
//       return response!.data;
//     } on dio.DioException catch (e) {
//       if (e.response == null) {
//         log("===========> Error: ${e.error}");
//       } else {
//         return e.response!.data;
//       }
//     }
//   }
// }

import 'dart:developer' as developer;
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:orioattendanceapp/Utils/AppWidget/App_widget.dart';

class Network {
  static dio.Response? response;
  static final dio.Dio _dio = dio.Dio();

  static Future<dynamic> postApi(
    String? token,
    String endUrl,
    dynamic data,
    Map<String, dynamic>? header,
  ) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
        ...?header,
      };
      response = await _dio.post(
        endUrl,
        options: dio.Options(
          headers: headers,
          validateStatus: (status) {
            return status != null && status < 500;
          },
        ),
        data: data,
      );
      developer.log('POST Response: ${response.toString()}');
      return response!.data;
    } on dio.DioException catch (e) {
      if (e.response == null) {
        developer.log('POST Error: ${e.error}');
        throw Exception('Network error: ${e.message}');
      } else {
        developer.log('POST Error Response: ${e.response!.data}');
        return e.response!.data;
      }
    } catch (e) {
      developer.log('Unexpected POST Error: $e');
      throw Exception('Unexpected error: $e');
    }
  }

  static Future<dynamic> getApi(
    String endUrl, {
    Map<String, dynamic>? headers,
  }) async {
    try {
      final authHeaders = {'Content-Type': 'application/json', ...?headers};
      response = await _dio.get(
        endUrl,
        options: dio.Options(
          headers: authHeaders,
          validateStatus: (status) {
            return status != null && status < 500;
          },
        ),
      );
      developer.log('GET Response: ${response.toString()}');
      return response!.data;
    } on dio.DioException catch (e) {
      if (e.response == null) {
        developer.log('GET Error: ${e.error}');
        throw Exception('Network error: ${e.message}');
      } else {
        developer.log('GET Error Response: ${e.response!.data}');
        return e.response!.data;
      }
    } catch (e) {
      developer.log('Unexpected GET Error: $e');
      throw Exception('Unexpected error: $e');
    }
  }

  static Future<dynamic> putApi(
    String? token,
    String endUrl,
    dynamic data,
    Map<String, dynamic>? header,
  ) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
        ...?header,
      };
      response = await _dio.put(
        endUrl,
        options: dio.Options(
          headers: headers,
          validateStatus: (status) {
            return status != null && status < 500;
          },
        ),
        data: data,
      );
      developer.log('PUT Response: ${response.toString()}');
      return response!.data;
    } on dio.DioException catch (e) {
      if (e.response == null) {
        developer.log('PUT Error: ${e.error}');
        throw Exception('Network error: ${e.message}');
      } else {
        developer.log('PUT Error Response: ${e.response!.data}');
        return e.response!.data;
      }
    } catch (e) {
      developer.log('Unexpected PUT Error: $e');
      throw Exception('Unexpected error: $e');
    }
  }
}

class NetworkAwareWidget extends StatelessWidget {
  final bool isLoading;
  final bool hasError;
  final String errorMessage;
  final VoidCallback onRetry;
  final Widget child;

  const NetworkAwareWidget({
    super.key,
    required this.isLoading,
    required this.hasError,
    required this.errorMessage,
    required this.onRetry,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Apploader();
    }

    if (hasError) {
      return RetryWidget(errorMessage: errorMessage, onRetry: onRetry);
    }

    return child;
  }
}
