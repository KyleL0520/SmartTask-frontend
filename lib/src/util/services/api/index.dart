import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/src/util/services/storage/auth_storage.dart';

abstract class API {
  late final Dio _dio;
  final String baseUrl = dotenv.env['PUBLIC_API_HOST'] ?? '';
  final int timeOut = int.parse(dotenv.env['PUBLIC_API_TIMEOUT_MS'] ?? '10000');

  API() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: Duration(seconds: timeOut),
        headers: {"Content-Type": "application/json"},
      ),
    );
    _dio.interceptors.add(DioInterceptor(_dio));
  }

  Dio get dio => _dio;
}

class DioInterceptor extends Interceptor {
  final Dio _dio;

  DioInterceptor(this._dio);

  Future<String?> refreshToken() async {
    try {
      final refreshToken = await AuthStorage().getRefreshToken;
      final response = await _dio.post(
        '/api/auth/refresh',
        data: {"token": refreshToken},
      );

      if (response.statusCode == 201) {
        final newToken = response.data["accessToken"];
        AuthStorage().setAccessToken(newToken);

        return newToken;
      } else {
        throw response;
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await AuthStorage().getToken;

    if (token != null && token.isNotEmpty) {
      options.headers["Authorization"] = 'Bearer $token';
    }

    super.onRequest(options, handler);
  }

  // @override
  // void onError(DioException err, ErrorInterceptorHandler handler) async {
  //   final isRetry = err.requestOptions.extra['isRetry'] == true;

  //   if (err.response?.statusCode == 401 && !isRetry) {
  //     try {
  //       final newToken = await refreshToken();

  //       if (newToken != null && newToken.isNotEmpty) {
  //         final options = err.requestOptions;
  //         options.headers["Authorization"] = "Bearer $newToken";
  //         options.extra['isRetry'] = true;

  //         final response = await _dio.fetch(options);
  //         handler.resolve(response);
  //       } else {
  //         AuthStorage().clear();
  //         super.onError(err, handler);
  //       }
  //     } on DioException catch (error) {
  //       AuthStorage().clear();
  //       super.onError(error, handler);
  //     }
  //   } else {
  //     super.onError(err, handler);
  //   }
  // }
}
