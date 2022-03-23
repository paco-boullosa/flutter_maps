part of 'map_bloc.dart';

abstract class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object> get props => [];
}

class OnMapInicioEvent extends MapEvent {
  final GoogleMapController controller;
  const OnMapInicioEvent(this.controller);
}

class OnStartSeguirUsuarioMap extends MapEvent {}

class OnStopSeguirUsuarioMap extends MapEvent {}

class UpdateUserPolylineEvent extends MapEvent {
  final List<LatLng> userLocations;
  const UpdateUserPolylineEvent(this.userLocations);
}

class OnToggleRuta extends MapEvent {}

class DibujarPolylineEvent extends MapEvent {
  final Map<String, Polyline> polylines;
  const DibujarPolylineEvent(this.polylines);
}
