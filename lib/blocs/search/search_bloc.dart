import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';

import 'package:maps_app/models/models.dart';
import 'package:maps_app/services/services.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  // usamos traffic service aqui
  TrafficService trafficService;

  SearchBloc({
    required this.trafficService,
  }) : super(const SearchState()) {
    on<OnActivateManualMarkerEvent>(
        (event, emit) => emit(state.copyWIth(displayManualMarker: true)));

    on<OnDectivateManualMarkerEvent>(
        (event, emit) => emit(state.copyWIth(displayManualMarker: false)));
  }

  Future<RouteDestination> getCoordenadasInicioAFin(LatLng inicio, LatLng fin) async {
    final trafficResponse = await trafficService.getCoorsInicioAFin(inicio, fin);
    // esto de arriba se hace en el servicio

    final geometry = trafficResponse.routes[0].geometry;
    final distance = trafficResponse.routes[0].distance;
    final duration = trafficResponse.routes[0].duration;

    // points
    final points = decodePolyline(geometry, accuracyExponent: 6);
    final latlngList = points
        .map(
            (coordenadas) => LatLng(coordenadas[0].toDouble(), coordenadas[1].toDouble()))
        .toList();

    return RouteDestination(
      points: latlngList,
      duration: duration,
      distance: distance,
    );
  }
}
