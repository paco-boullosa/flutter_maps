import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:maps_app/blocs/blocs.dart';
import 'package:maps_app/ui/ui.dart';

class BtnCurrentLocation extends StatelessWidget {
  const BtnCurrentLocation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locationBloc = BlocProvider.of<LocationBloc>(context);
    final mapBloc = BlocProvider.of<MapBloc>(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: CircleAvatar(
        maxRadius: 25,
        backgroundColor: Colors.white,
        child: IconButton(
          icon: const Icon(Icons.my_location_outlined, color: Colors.black),
          onPressed: () {
            final userLocation = locationBloc.state.ultimaUbicacionConocida;

            if (userLocation == null) {
              final snack = CustomSnackBar(mensaje: 'No hay ubicación');
              ScaffoldMessenger.of(context).showSnackBar(snack);
              return;
            }

            mapBloc.moverCamara(userLocation);
          },
        ),
      ),
    );
  }
}
