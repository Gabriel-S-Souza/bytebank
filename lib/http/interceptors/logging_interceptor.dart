//O interceptador deve implementar a interface InterceptorContract

import 'package:http_interceptor/http_interceptor.dart';

class LoggingInterceptor implements InterceptorContract {
  //Todo tipo de requyisição vai chamar este método
  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    print('Request');
    // print('url ${data.baseUrl}');
    // print('headers ${data.headers}');
    // print('body ${data.body}');
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    print('Response');
    // print('status ${data.statusCode}');
    // print('headers ${data.headers}');
    // print('body ${data.body}');
    return data;
  }
}