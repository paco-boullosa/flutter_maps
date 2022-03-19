import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

part 'gps_event.dart';
part 'gps_state.dart';

class GpsBloc extends Bloc<GpsEvent, GpsState> {
  StreamSubscription? gpsServiceSuscription;

  GpsBloc() : super(const GpsState(isGpsEnabled: false, isGpsPermissionGranted: false)) {
    on<GpsAndPermissionEvent>((event, emit) {
      emit(state.copyWith(
        isGpsEnabled: event.isGpsEnable,
        isGpsPermissionGranted: event.isGpsPermissionGranter,
      ));
    });

    _inicio();
  }

  // inicializar el servicio de geolocator
  Future<void> _inicio() async {
    // final isEnabled = await _checkEstadoGps();
    // final isGranted = await _isPermissionGranted();
    // para obtener los dos valores en el mismo momento
    final gpsInitStatus = await Future.wait([
      _checkEstadoGps(),
      _isPermissionGranted(),
    ]);
    // despachamos un evento que indique el estado
    add(GpsAndPermissionEvent(
      isGpsEnable: gpsInitStatus[0],
      isGpsPermissionGranter: gpsInitStatus[1], // este lo desconozco
    ));
  }

  Future<bool> _isPermissionGranted() async {
    final isGranted = await Permission.location.isGranted;
    return isGranted;
  }

  Future<bool> _checkEstadoGps() async {
    final isEnable = await Geolocator.isLocationServiceEnabled();

    gpsServiceSuscription = Geolocator.getServiceStatusStream().listen((event) {
      // escucha los cambios de estado del servicio gps
      final isEnabled = (event.index == 1) ? true : false;
      // print('service estado $isEnabled');
      add(GpsAndPermissionEvent(
        isGpsEnable: isEnabled,
        isGpsPermissionGranter: state.isGpsPermissionGranted,
      ));
    });
    return isEnable;
  }

  Future<void> pedirAccesoGps() async {
    final status = await Permission.location.request();
    switch (status) {
      case PermissionStatus.granted:
        add(GpsAndPermissionEvent(
            isGpsEnable: state.isGpsEnabled, isGpsPermissionGranter: true));
        break;
      case PermissionStatus.denied:
      case PermissionStatus.restricted:
      case PermissionStatus.limited:
      case PermissionStatus.permanentlyDenied:
        add(GpsAndPermissionEvent(
            isGpsEnable: state.isGpsEnabled, isGpsPermissionGranter: false));
        openAppSettings();
        break;
    }
  }

  @override
  Future<void> close() {
    gpsServiceSuscription?.cancel();
    return super.close();
  }
}
