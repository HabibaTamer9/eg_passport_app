import 'package:dio/dio.dart';
import 'package:eg_passport_app/core/Api/endpoint.dart';

class ApiHelper {
  static String? accessToken;
  static String? refreshToken;
  static String messageLanguage = 'messageAr';

  final Dio dio = Dio(
    BaseOptions(
      baseUrl: Endpoint.baseURL,
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
      headers: const {'Accept': 'application/json', 'Accept-Language': 'ar'},
    ),
  );

  Future<Map<String, dynamic>> postAuthAPI(
      String endpoint,
      Map<String, dynamic> body,
      ) {
    return postAPI('${Endpoint.authURL}$endpoint', body);
  }

  Future<Map<String, dynamic>> postAPI(
      String endpoint,
      Map<String, dynamic> body, {
        String? token,
      }) async {
    try {
      final response = await dio.post(
        endpoint,
        data: body,
        options: _options(token),
      );

      return _toMap(response.data);
    } on DioException catch (e) {
      return _handleDioException(e);
    } catch (e) {
      return _clientError('CLIENT_ERROR', e.toString());
    }
  }

  Future<Map<String, dynamic>> putAPI(
      String endpoint,
      Map<String, dynamic> body, {
        String? token,
      }) async {
    try {
      final response = await dio.put(
        endpoint,
        data: body,
        options: _options(token),
      );

      return _toMap(response.data);
    } on DioException catch (e) {
      return _handleDioException(e);
    } catch (e) {
      return _clientError('CLIENT_ERROR', e.toString());
    }
  }

  Future<Map<String, dynamic>> getAPI(String endpoint, {String? token}) async {
    try {
      final response = await dio.get(endpoint, options: _options(token));
      return _toMap(response.data);
    } on DioException catch (e) {
      return _handleDioException(e);
    } catch (e) {
      return _clientError('CLIENT_ERROR', e.toString());
    }
  }

  Options _options(String? token) {
    final bearerToken = token ?? accessToken;
    if (bearerToken == null || bearerToken.isEmpty) {
      return Options();
    }

    return Options(headers: {'Authorization': 'Bearer $bearerToken'});
  }

  Map<String, dynamic> _handleDioException(DioException e) {
    if (e.response?.data != null) {
      return _toMap(e.response!.data);
    }

    return _clientError(
      'NETWORK_ERROR',
      'تعذر الاتصال بالخادم. تأكد أن الـ API يعمل على ${Endpoint.baseURL}',
      messageEn:
      'Cannot connect to the API. Make sure the backend is running on ${Endpoint.baseURL}',
    );
  }

  Map<String, dynamic> _toMap(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data;
    }

    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }

    return _clientError('INVALID_RESPONSE', 'استجابة غير متوقعة من الخادم');
  }

  Map<String, dynamic> _clientError(
      String code,
      String message, {
        String? messageEn,
      }) {
    return {
      'success': false,
      'code': code,
      'message': message,
      'messageAr': message,
      'messageEn': messageEn ?? message,
      'data': null,
      'errors': [],
    };
  }
}
