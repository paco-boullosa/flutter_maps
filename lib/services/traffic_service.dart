import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:maps_app/models/models.dart';
import 'package:maps_app/services/services.dart';

// NOTA
// este servicio, ademas de las rutas (polylines) se encarga de las búsquedas de lugares (places)

class TrafficService {
  // creamos 2 instancias de Dio (normal y trafico)

  final Dio _dioTraffic; // interceptor de trafico
  final Dio _dioPlaces; // interceptor de places

  final String _baseTrafficUrl = 'https://api.mapbox.com/directions/v5/mapbox';
  final String _basePlacesUrl = 'https://api.mapbox.com/geocoding/v5/mapbox.places';

  // instancia de la clase
  TrafficService()
      : _dioTraffic = Dio()..interceptors.add(TrafficInterceptor()),
        _dioPlaces = Dio()..interceptors.add(PlacesInterceptor());

  Future getCoorsInicioAFin(LatLng inicio, LatLng fin) async {
    final coorStr =
        '${inicio.longitude},${inicio.latitude};${fin.longitude},${fin.latitude}';
    final url = '$_baseTrafficUrl/driving/$coorStr';

    final resp = await _dioTraffic.get(url);

    final data = TrafficResponse.fromMap(resp.data);

    return data;
  }

  Future<List<Feature>> getResultadosByQuery(LatLng proximidad, String query) async {
    if (query.isEmpty) return [];

    final url = '$_basePlacesUrl/$query.json';

    final resp = await _dioPlaces.get(url, queryParameters: {
      'proximity': '${proximidad.longitude},${proximidad.latitude}',
      'limit': 7,
    });

    final placesResponse = PlacesResponse.fromJson(resp.data);

    return placesResponse.features;
  }

  // obtener datos de la posicion del marcador (reverse geocoding)
  Future<Feature> getInformacionPorCoors(LatLng coors) async {
    final url = '$_basePlacesUrl/${coors.longitude},${coors.latitude}.json';
    final resp = await _dioPlaces.get(url, queryParameters: {
      'limit': 1,
    });
    final placesResponse = PlacesResponse.fromJson(resp.data);
    return placesResponse.features[0]; // solo se devuelve la primera posicion
  }
}
