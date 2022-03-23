import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:maps_app/models/models.dart';
import 'package:maps_app/services/services.dart';

class TrafficService {
  // creamos 2 instancias de Dio (normal y trafico)

  final Dio _dioTraffic; // rutas de trafico

  final String _baseTrafficUrl = 'https://api.mapbox.com/directions/v5/mapbox';

  // instancia de la clase
  TrafficService() : _dioTraffic = Dio()..interceptors.add(TrafficInterceptor());

  Future getCoorsInicioAFin(LatLng inicio, LatLng fin) async {
    final coorStr =
        '${inicio.longitude},${inicio.latitude};${fin.longitude},${fin.latitude}';
    final url = '$_baseTrafficUrl/driving/$coorStr';

    final resp = await _dioTraffic.get(url);

    final data = TrafficResponse.fromMap(resp.data);

    return data;
  }
}
