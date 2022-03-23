import 'package:dio/dio.dart';

const accessToken =
    'pk.eyJ1IjoiYm91bGxvc2EiLCJhIjoiY2wwMWc0N2JhMHR0dDNrcDZxcTgzOW4weiJ9.qicEs0531SzO52tTIqbBMg';

class TrafficInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.queryParameters.addAll({
      'alternatives': true,
      'geometries': 'polyline6',
      'overview': 'simplified',
      'steps': false,
      'access_token': accessToken
    });

    super.onRequest(options, handler);
  }
}
