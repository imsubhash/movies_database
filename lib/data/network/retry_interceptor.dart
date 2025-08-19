import 'dart:io';

import 'package:dio/dio.dart';

class RetryOnConnectionChangeInterceptor extends Interceptor {
  final Dio dio;
  RetryOnConnectionChangeInterceptor(this.dio);

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.type == DioExceptionType.connectionError ||
        err.error is SocketException) {
      print('Retrying request after connection error...');
      // simple retry after short delay
      await Future.delayed(const Duration(seconds: 2));
      return handler.resolve(await dio.fetch(err.requestOptions));
    }
    return handler.next(err);
  }
}
