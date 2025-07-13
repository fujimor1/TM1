import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart'; 

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
  // final String _baseUrl = "http://10.0.2.2:8000/api";
  final String _baseUrl = "https://2bde2b1af22f.ngrok-free.app/api";  

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
      headers['Authorization'] = 'Token ${DioClient.token}';
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

  //GET TECNICO
  Future<Response> getWithToken(String url) async {
    try {
      final fullUrl = _baseUrl + url;
      final headers = <String, String>{};

      if (DioClient.token.isNotEmpty) {
        headers['Authorization'] = 'Token ${DioClient.token}';
      }

      log('GET WithToken Request --> $fullUrl');
      final response = await _dio.get(
        fullUrl,
        options: Options(headers: headers),
      );
      log('GET WithToken Response ${response.statusCode} --> ${response.data}');
      return response;
    } on DioException catch (e) {
      _handleError(
        'Error en la solicitud GET WithToken (DioException): ${e.message}',
      );
      if (e.response != null) {
        log(
          'GET WithToken Error Response (DioException): ${e.response?.statusCode} --> ${e.response?.data}',
        );
      }
      rethrow;
    } catch (e) {
      _handleError('Error inesperado en la solicitud GET WithToken: $e');
      rethrow;
    }
  }

  //METODO PATCH
  Future<Response> patch(
    String url,
    Map<String, dynamic>? data, {
    bool istoken = true,
    Map<String, dynamic>? parameters,
  }) async {
    final fullUrl = _baseUrl + url;
    final headers = <String, String>{};

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

  Future<Response> patchWithFile(
    String url,
    Map<String, dynamic> data, {
    bool istoken = true,
    Map<String, dynamic>? parameters,
  }) async {
    final fullUrl = _baseUrl + url;
    final headers = <String, String>{};

    if (istoken && DioClient.token.isNotEmpty) {
      headers['Authorization'] = 'Token ${DioClient.token}';
      log('Auth Header (patchWithFile) --> ${headers['Authorization']}');
    }

    log('PATCH (with file) Request --> $fullUrl');
    log('PATCH (with file) Data (initial map) --> $data');

    FormData formData = FormData();
    for (var entry in data.entries) {
      if (entry.value is File) {
        formData.files.add(
          MapEntry(
            entry.key,
            await MultipartFile.fromFile(
              entry.value.path,
              filename: entry.value.path.split('/').last,
            ),
          ),
        );
      } else {
        formData.fields.add(MapEntry(entry.key, entry.value.toString()));
      }
    }

    log(
      'PATCH (with file) FormData --> ${formData.fields} and ${formData.files.map((e) => e.key)}',
    );
    if (parameters != null)
      log('PATCH (with file) Query Params --> $parameters');

    try {
      final response = await _dio.patch(
        fullUrl,
        data: formData,
        queryParameters: parameters,
        options: Options(
          headers: headers.isNotEmpty ? headers : null,
          contentType: 'multipart/form-data',
        ),
      );
      log(
        'PATCH (with file) Response ${response.statusCode} --> ${response.data}',
      );
      return response;
    } on DioException catch (e) {
      _handleError(
        'Error en la solicitud PATCH (con archivo - DioException): ${e.message}',
      );
      if (e.response != null) {
        log(
          'PATCH (con archivo) Error Response (DioException): ${e.response?.statusCode} --> ${e.response?.data}',
        );
      }
      rethrow;
    } catch (e) {
      _handleError('Error inesperado en la solicitud PATCH (con archivo): $e');
      rethrow;
    }
  }

  Future<Response> getWithParams(
    String url, {
    required Map<String, dynamic> queryParams,
    bool istoken = false,
  }) async {
    try {
      final fullUrl = _baseUrl + url;
      final headers = <String, String>{};

      if (istoken && DioClient.token.isNotEmpty) {
        headers['Authorization'] = 'Bearer ${DioClient.token}';
      }

      log(
        'GET with Params Request --> $fullUrl con queryParameters: $queryParams',
      );
      final response = await _dio.get(
        fullUrl,
        queryParameters: queryParams,
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

  Future<Response> postWithFile(
    String url, {
    required int solicitudId,
    required List<String> fotosPaths,
    bool istoken = true,
    Map<String, dynamic>? parameters,
  }) async {
    final fullUrl = _baseUrl + url;
    final headers = <String, String>{};

    if (istoken && DioClient.token.isNotEmpty) {
      headers['Authorization'] = 'Bearer ${DioClient.token}';
      log('Auth Header (postWithFile) --> ${headers['Authorization']}');
    }

    log('POST (with file) Request --> $fullUrl');
    log('POST (with file) Solicitud ID --> $solicitudId');
    log('POST (with file) Photos Paths --> $fotosPaths');

    FormData formData = FormData();

    formData.fields.add(MapEntry('solicitud', solicitudId.toString()));

    // Añade los archivos
    for (int i = 0; i < fotosPaths.length; i++) {
      String path = fotosPaths[i];
      if (await File(path).exists()) {
        formData.files.add(
          MapEntry(
            'url_foto',
            await MultipartFile.fromFile(path, filename: path.split('/').last),
          ),
        );
      } else {
        log('Advertencia: Archivo no encontrado en la ruta: $path');
      }
    }

    // Log del FormData para depuración
    log('POST (with file) FormData fields --> ${formData.fields}');
    log(
      'POST (with file) FormData files --> ${formData.files.map((e) => e.key)}',
    );
    if (parameters != null)
      log('POST (with file) Query Params --> $parameters');

    try {
      final response = await _dio.post(
        fullUrl,
        data: formData, // ¡Aquí pasamos el FormData!
        queryParameters: parameters,
        options: Options(
          headers: headers.isNotEmpty ? headers : null,
          contentType:
              'multipart/form-data', // Indispensable para subir archivos
        ),
      );
      log(
        'POST (with file) Response ${response.statusCode} --> ${response.data}',
      );
      return response;
    } on DioException catch (e) {
      _handleError(
        'Error en la solicitud POST (con archivo - DioException): ${e.message}',
      );
      if (e.response != null) {
        log(
          'POST (con archivo) Error Response (DioException): ${e.response?.statusCode} --> ${e.response?.data}',
        );
      }
      rethrow;
    } catch (e) {
      _handleError('Error inesperado en la solicitud POST (con archivo): $e');
      rethrow;
    }
  }

  Future<Response> postMultipart(
    String url, {
    required Map<String, String> fields, // Para IDs y otros datos de texto
    required List<MapEntry<String, String>>
    files, // Para los archivos (key, path)
    bool istoken = true,
  }) async {
    final fullUrl = _baseUrl + url;
    final headers = <String, String>{};

    if (istoken && DioClient.token.isNotEmpty) {
      headers['Authorization'] = 'Bearer ${DioClient.token}';
      log('Auth Header (postMultipart) --> ${headers['Authorization']}');
    }

    log('POST Multipart Request --> $fullUrl');

    // Crear el objeto FormData
    FormData formData = FormData();

    // Añadir los campos de texto
    formData.fields.addAll(fields.entries);
    log('POST Multipart Fields --> ${formData.fields}');

    // Añadir los archivos
    for (var fileEntry in files) {
      String path = fileEntry.value;
      if (await File(path).exists()) {
        formData.files.add(
          MapEntry(
            fileEntry.key, // La llave del campo del archivo (ej: 'foto')
            await MultipartFile.fromFile(path, filename: path.split('/').last),
          ),
        );
      } else {
        log('Advertencia: Archivo no encontrado en la ruta: $path');
      }
    }
    log('POST Multipart Files --> ${formData.files.map((e) => e.key)}');

    try {
      final response = await _dio.post(
        fullUrl,
        data: formData,
        options: Options(
          headers: headers.isNotEmpty ? headers : null,
          contentType: 'multipart/form-data',
        ),
      );
      log(
        'POST Multipart Response ${response.statusCode} --> ${response.data}',
      );
      return response;
    } on DioException catch (e) {
      _handleError(
        'Error en la solicitud POST Multipart (DioException): ${e.message}',
      );
      if (e.response != null) {
        log(
          'POST Multipart Error Response (DioException): ${e.response?.statusCode} --> ${e.response?.data}',
        );
      }
      rethrow;
    } catch (e) {
      _handleError('Error inesperado en la solicitud POST Multipart: $e');
      rethrow;
    }
  }


  Future<Response> delete(
    String url, {
    bool istoken = true,
    Map<String, dynamic>? parameters,
  }) async {
    final fullUrl = _baseUrl + url;
    log('Request DELETE --> $fullUrl');

    final Map<String, dynamic> headers = {};
    if (istoken && DioClient.token.isNotEmpty) {
      headers['Authorization'] = 'Bearer ${DioClient.token}';
    }

    try {
      final response = await _dio.delete(
        fullUrl,
        queryParameters: parameters,
        options: Options(headers: headers),
      );
      log('Response DELETE ${response.statusCode} --> ${response.data}');
      return response;
    } on DioException catch (e) {
      _handleError('Error en la solicitud DELETE (DioException): ${e.message}');
      if (e.response != null) {
        log(
          'DELETE Error Response (DioException): ${e.response?.statusCode} --> ${e.response?.data}',
        );
      }
      rethrow;
    } catch (e) {
      _handleError('Error inesperado en la solicitud DELETE: $e');
      rethrow;
    }
  }
}
