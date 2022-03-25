import 'package:dio/dio.dart';

class PlacesInterceptor extends Interceptor {
  final accessToken =
      'pk.eyJ1IjoiYm91bGxvc2EiLCJhIjoiY2wwMWc0N2JhMHR0dDNrcDZxcTgzOW4weiJ9.qicEs0531SzO52tTIqbBMg';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.queryParameters.addAll({
      'language': 'es',
      'access_token': accessToken,
    });
    super.onRequest(options, handler);
  }
}
