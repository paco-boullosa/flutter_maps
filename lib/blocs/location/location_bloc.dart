import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  StreamSubscription<Position>? positionStream;

  LocationBloc() : super(const LocationState()) {
    on<OnStartSeguirUsuario>(
        (event, emit) => emit(state.copyWith(siguiendoUsuario: true)));

    on<OnStopSeguirUsuario>(
        (event, emit) => emit(state.copyWith(siguiendoUsuario: false)));

    on<OnNuevaUbicacionEvent>((event, emit) {
      emit(state.copyWith(
        ultimaUbicacionConocida: event.nuevaUbicacion,
        historialUbicaciones: [...state.historialUbicaciones, event.nuevaUbicacion],
      ));
    });
  }

  Future getPosicionActual() async {
    final posicion = await Geolocator.getCurrentPosition();
    add(OnNuevaUbicacionEvent(LatLng(posicion.latitude, posicion.longitude)));
  }

  void empezarSeguirUsuario() {
    // escucha los cambios de ubicacion del usuario
    add(OnStartSeguirUsuario());

    positionStream = Geolocator.getPositionStream().listen((event) {
      final posicion = event;
      add(OnNuevaUbicacionEvent(LatLng(posicion.latitude, posicion.longitude)));
    });
  }

  void stopSeguirUsuario() {
    positionStream?.cancel();
    add(OnStopSeguirUsuario());
  }

  @override
  Future<void> close() {
    stopSeguirUsuario();
    return super.close();
  }
}
