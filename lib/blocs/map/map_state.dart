part of 'map_bloc.dart';

class MapState extends Equatable {
  final bool isMapInicializado;
  final bool seguirUsuario;

  const MapState({
    this.isMapInicializado = false,
    this.seguirUsuario = false,
  });

  MapState copyWith({
    bool? isMapInicializado,
    bool? seguirUsuario,
  }) =>
      MapState(
        isMapInicializado: isMapInicializado ?? this.isMapInicializado,
        seguirUsuario: seguirUsuario ?? this.seguirUsuario,
      );

  @override
  List<Object> get props => [isMapInicializado, seguirUsuario];
}
