part of 'location_bloc.dart';

abstract class LocationEvent extends Equatable {
  const LocationEvent();

  @override
  List<Object> get props => [];
}

class OnNuevaUbicacionEvent extends LocationEvent {
  final LatLng nuevaUbicacion;
  const OnNuevaUbicacionEvent(this.nuevaUbicacion);
}

class OnStartSeguirUsuario extends LocationEvent {}

class OnStopSeguirUsuario extends LocationEvent {}
