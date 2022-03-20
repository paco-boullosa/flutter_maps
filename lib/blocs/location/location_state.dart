part of 'location_bloc.dart';

class LocationState extends Equatable {
  final bool siguiendoUsuario;
  final LatLng? ultimaUbicacionConocida;
  final List<LatLng> historialUbicaciones;

  const LocationState({
    this.siguiendoUsuario = false,
    this.ultimaUbicacionConocida,
    historialUbicaciones,
  }) : historialUbicaciones = historialUbicaciones ?? const [];

  LocationState copyWith({
    bool? siguiendoUsuario,
    LatLng? ultimaUbicacionConocida,
    List<LatLng>? historialUbicaciones,
  }) =>
      LocationState(
        siguiendoUsuario: siguiendoUsuario ?? this.siguiendoUsuario,
        ultimaUbicacionConocida: ultimaUbicacionConocida ?? this.ultimaUbicacionConocida,
        historialUbicaciones: historialUbicaciones ?? this.historialUbicaciones,
      );

  @override
  List<Object?> get props =>
      [siguiendoUsuario, ultimaUbicacionConocida, historialUbicaciones];
}
