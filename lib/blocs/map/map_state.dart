part of 'map_bloc.dart';

class MapState extends Equatable {
  final bool isMapInicializado;
  final bool estaSiguiendoUsuario;
  final bool mostrarRuta;

  // Polylines
  final Map<String, Polyline> polylines;

  const MapState(
      {this.isMapInicializado = false,
      this.estaSiguiendoUsuario = true,
      this.mostrarRuta = true,
      Map<String, Polyline>? polylines})
      : polylines = polylines ?? const {};

  MapState copyWith(
          {bool? isMapInicializado,
          bool? estaSiguiendoUsuario,
          bool? mostrarRuta,
          Map<String, Polyline>? polylines}) =>
      MapState(
        isMapInicializado: isMapInicializado ?? this.isMapInicializado,
        estaSiguiendoUsuario: estaSiguiendoUsuario ?? this.estaSiguiendoUsuario,
        mostrarRuta: mostrarRuta ?? this.mostrarRuta,
        polylines: polylines ?? this.polylines,
      );

  @override
  List<Object> get props =>
      [isMapInicializado, estaSiguiendoUsuario, mostrarRuta, polylines];
}
