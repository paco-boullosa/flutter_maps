import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:maps_app/blocs/blocs.dart';
import 'package:maps_app/themes/themes.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  // El map_bloc se encarga de crear el mapa y situar al usuario en el mapa
  // y depende del location_bloc que es quien emite la posicion del usuario.
  // Para crear esa dependencia:
  final LocationBloc locationBloc;
  // y hacemos que sea obligatoria una instancia de location_bloc para crear una
  // instancia de map_bloc

  GoogleMapController? _mapController;

  // para poder liberar memoria y proceso
  StreamSubscription<LocationState>? suscripcionLocationState;

  MapBloc({required this.locationBloc}) : super(const MapState()) {
    on<OnMapInicioEvent>(_onInitMap);
    on<OnStartSeguirUsuarioMap>(_onStartSeguirUsuario);
    on<OnStopSeguirUsuarioMap>(
        (event, emit) => emit(state.copyWith(estaSiguiendoUsuario: false)));
    on<UpdateUserPolylineEvent>(_onPolylineNewPoint);
    on<OnToggleRuta>(
        (event, emit) => emit(state.copyWith(mostrarRuta: !state.mostrarRuta)));

    // hay que crear una suscripcion para escuchar los cambios en el location_bloc
    suscripcionLocationState = locationBloc.stream.listen((locationState) {
      if (locationState.ultimaUbicacionConocida != null) {
        add(UpdateUserPolylineEvent(locationState.historialUbicaciones));
      }
      // si no estamos siguiendo al usuario o no tenemos una ubicacion no se hace nada
      if (!state.estaSiguiendoUsuario) return;
      if (locationState.ultimaUbicacionConocida == null) return;
      // en otro caso:
      moverCamara(locationState.ultimaUbicacionConocida!);
    });
  }

  void _onInitMap(OnMapInicioEvent event, Emitter<MapState> emit) {
    _mapController = event.controller;
    _mapController!.setMapStyle(jsonEncode(uberMapTheme));
    emit(state.copyWith(isMapInicializado: true));
  }

  void moverCamara(LatLng newLocation) {
    final cameraUpdate = CameraUpdate.newLatLng(newLocation);
    _mapController?.animateCamera(cameraUpdate);
  }

  void _onStartSeguirUsuario(OnStartSeguirUsuarioMap event, Emitter<MapState> emit) {
    emit(state.copyWith(estaSiguiendoUsuario: true));

    if (locationBloc.state.ultimaUbicacionConocida == null) return;
    moverCamara(locationBloc.state.ultimaUbicacionConocida!);
  }

  void _onPolylineNewPoint(UpdateUserPolylineEvent event, Emitter<MapState> emit) {
    final myRuta = Polyline(
      polylineId: const PolylineId('myRuta'),
      color: Colors.black,
      width: 5,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
      points: event.userLocations,
    );

    final currentPolylines = Map<String, Polyline>.from(state.polylines);
    currentPolylines['myRuta'] = myRuta;

    emit(state.copyWith(polylines: currentPolylines));
  }

  @override
  Future<void> close() {
    suscripcionLocationState?.cancel();
    return super.close();
  }
}
