import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:maps_app/blocs/blocs.dart';

// Se comprueba si el dispositivo tiene acceso al gps
// Usa 2 widgets:
// a.- Solicitar activacion de gps
// b.- Solicitar acceso a gps

class GpsAccessScreen extends StatelessWidget {
  const GpsAccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: BlocBuilder<GpsBloc, GpsState>(
        builder: (context, state) {
          // print(state);
          return !state.isGpsEnabled
              ? const _ActivarMensajeGps()
              : const _BotonAccesoGps();
        },
      )),
    );
  }
}

class _BotonAccesoGps extends StatelessWidget {
  const _BotonAccesoGps({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Se necesitan permitos para acceder al GPS'),
        MaterialButton(
          color: Colors.black,
          shape: const StadiumBorder(),
          elevation: 0,
          splashColor: Colors.transparent, // elimina el efecto Material
          child: const Text('Solicitar acceso', style: TextStyle(color: Colors.white)),
          onPressed: () {
            final gpsBloc = BlocProvider.of<GpsBloc>(context);
            gpsBloc.pedirAccesoGps();
          },
        )
      ],
    );
  }
}

class _ActivarMensajeGps extends StatelessWidget {
  const _ActivarMensajeGps({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const Text(
      'Debe habilitar el GPS',
      style: TextStyle(fontSize: 25, fontWeight: FontWeight.w300),
    );
  }
}
