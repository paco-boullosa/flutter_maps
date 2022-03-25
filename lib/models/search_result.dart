import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;

class SearchResult {
  final bool cancelar;
  final bool manual;
  final LatLng? posicion;
  final String? nombre;
  final String? descripcion;

  SearchResult({
    required this.cancelar,
    this.manual = false,
    this.posicion,
    this.nombre,
    this.descripcion,
  });
}
