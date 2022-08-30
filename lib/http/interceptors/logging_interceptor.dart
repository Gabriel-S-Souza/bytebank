import 'dart:developer';

import 'package:http_interceptor/http_interceptor.dart';

class LoggingInterceptor implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    log('Request');
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    log('Response');
    return data;
  }
}