import 'dart:developer'; // Para log
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart'; // Para kDebugMode

final options = BaseOptions(
  validateStatus: (status) {
    return status! < 500;
  },
  receiveTimeout: const Duration(seconds: 14),
  sendTimeout: const Duration(seconds: 14),
  connectTimeout: const Duration(seconds: 14),
);
final _dio = Dio(options);

class DioClient {
  static String token = "";
  static Map<String, dynamic>? decodedTokenPayload;
  final String _baseUrl = "http://10.0.2.2:8000/api";

  //LOGIN
  Future<bool> login(String username, String password) async {
    try {
      log('Attempting login for: $username');
      final response = await _dio.post(
        _baseUrl + '/login/',
        data: {'username': username, 'password': password},
      );

      log('Login Response ${response.statusCode} --> ${response.data}');

      if (response.statusCode == 200) {
        final receivedToken = response.data['token'] as String;
        DioClient.token = receivedToken;
        log('Login successful. Token stored.');
        return true;
      } else {
        log('Login failed: ${response.statusCode} - ${response.data}');
        return false;
      }
    } on DioException catch (e) {
      _handleError('Error en la solicitud de login: ${e.message}');
      if (e.response != null) {
        log(
          'Login Error Response: ${e.response?.statusCode} --> ${e.response?.data}',
        );
      }
      return false;
    } catch (e) {
      _handleError('Error inesperado durante el login: $e');
      return false;
    }
  }

  void logout() {
    DioClient.token = "";
    log('User logged out. Token cleared.');
  }

  void _handleError(String errorMessage) {
    if (kDebugMode) {
      print('DIO_CLIENT ERROR: $errorMessage');
    } else {}
  }

  //METODO POST
  Future<Response> post(
    String url,
    Map<String, dynamic>? data, {
    bool istoken = false,
    Map<String, dynamic>? parameters,
  }) async {
    final fullUrl = _baseUrl + url;
    log('Request POST --> $fullUrl');
    log('Request POST send --> $data');

    final Map<String, dynamic> headers = {};
    if (istoken && DioClient.token.isNotEmpty) {
      headers['Authorization'] = 'Bearer ${DioClient.token}';
    }

    try {
      final response = await _dio.post(
        fullUrl,
        data: data,
        queryParameters: parameters,
        options: Options(headers: headers),
      );
      log('Response POST ${response.statusCode} --> ${response.data}');
      return response;
    } on DioException catch (e) {
      _handleError('Error en la solicitud POST (DioException): ${e.message}');
      if (e.response != null) {
        log(
          'POST Error Response (DioException): ${e.response?.statusCode} --> ${e.response?.data}',
        );
      }
      rethrow;
    } catch (e) {
      _handleError('Error inesperado en la solicitud POST: $e');
      rethrow;
    }
  }

  //METODO GET
  Future<Response> get(
    String url,
    Map<String, dynamic>? data, {
    Map<String, dynamic>? params,
    bool istoken = false,
  }) async {
    try {
      final fullUrl = _baseUrl + url;
      final headers = <String, String>{};

      if (istoken && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }

      log('GET Request --> $fullUrl');
      final response = await _dio.get(
        fullUrl,
        queryParameters: params ?? {},
        data: data,
        options: Options(headers: headers.isNotEmpty ? headers : null),
      );
      log('GET Response ${response.statusCode} --> ${response.data}');
      return response;
    } catch (e) {
      _handleError('Error en la solicitud GET: $e');
      rethrow;
    }
  }

  //GetUserParams
  Future<Response> getNoParams(String url, {bool istoken = false}) async {
    try {
      final fullUrl = _baseUrl + url;
      final headers = <String, String>{};

      if (istoken && DioClient.token.isNotEmpty) {
        headers['Authorization'] = 'Token ${DioClient.token}';
      }

      log('GET NoParams Request --> $fullUrl');
      final response = await _dio.get(
        fullUrl,
        options: Options(headers: headers.isNotEmpty ? headers : null),
      );
      log('GET NoParams Response ${response.statusCode} --> ${response.data}');
      return response;
    } on DioException catch (e) {
      _handleError(
        'Error en la solicitud GET NoParams (DioException): ${e.message}',
      );
      if (e.response != null) {
        log(
          'GET NoParams Error Response (DioException): ${e.response?.statusCode} --> ${e.response?.data}',
        );
      }
      rethrow;
    } catch (e) {
      _handleError('Error inesperado en la solicitud GET NoParams: $e');
      rethrow;
    }
  }

  Future<Response> patch(
    String url,
    Map<String, dynamic>? data, {
    bool istoken = true,
    Map<String, dynamic>? parameters,
  }) async {
    final fullUrl = _baseUrl + url;
    final headers = <String, String>{};

    // Verificamos si se debe incluir el token y si este no está vacío
    if (istoken &&
        DioClient.token != null &&
        DioClient.token.trim().isNotEmpty) {
      headers['Authorization'] = 'Token ${DioClient.token}';
      log('Auth Header --> ${headers['Authorization']}');
    }

    log('PATCH Request --> $fullUrl');
    log('PATCH Data --> $data');
    if (parameters != null) log('PATCH Query Params --> $parameters');

    try {
      final response = await _dio.patch(
        fullUrl,
        data: data,
        queryParameters: parameters,
        options: Options(headers: headers.isNotEmpty ? headers : null),
      );
      log('PATCH Response ${response.statusCode} --> ${response.data}');
      return response;
    } catch (e) {
      _handleError('Error en la solicitud PATCH: $e');
      return Response(
        requestOptions: RequestOptions(path: url),
        statusCode: 500,
        statusMessage: 'Error en PATCH',
      );
    }
  }

  Future<Response> getWithParams(
    String url, {
    required Map<String, dynamic>
    queryParams,
    bool istoken = false,
  }) async {
    try {
      final fullUrl = _baseUrl + url;
      final headers = <String, String>{};

      if (istoken && DioClient.token.isNotEmpty) {
        headers['Authorization'] =
            'Bearer ${DioClient.token}'; // Usar DioClient.token
      }

      log(
        'GET with Params Request --> $fullUrl con queryParameters: $queryParams',
      );
      final response = await _dio.get(
        fullUrl,
        queryParameters: queryParams, // Aquí pasamos los parámetros de consulta
        options: Options(headers: headers.isNotEmpty ? headers : null),
      );
      log(
        'GET with Params Response ${response.statusCode} --> ${response.data}',
      );
      return response;
    } on DioException catch (e) {
      _handleError(
        'Error en la solicitud GET con parámetros (DioException): ${e.message}',
      );
      if (e.response != null) {
        log(
          'GET with Params Error Response (DioException): ${e.response?.statusCode} --> ${e.response?.data}',
        );
      }
      rethrow;
    } catch (e) {
      _handleError('Error inesperado en la solicitud GET con parámetros: $e');
      rethrow;
    }
  }
}
