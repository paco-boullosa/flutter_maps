import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:animate_do/animate_do.dart';

import 'package:maps_app/blocs/blocs.dart';
import 'package:maps_app/helpers/helpers.dart';

// renderizar este widget de forma condicional
class ManualMarker extends StatelessWidget {
  const ManualMarker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        return (state.displayManualMarker)
            ? const _ManualMarkerBody()
            : const SizedBox(); // se devuelve un contenedor vacio (SizedBox es mas rapido que Container())
      },
    );
  }
}

class _ManualMarkerBody extends StatelessWidget {
  const _ManualMarkerBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final searchBloc = BlocProvider.of<SearchBloc>(context);
    final locationBloc = BlocProvider.of<LocationBloc>(context);
    final mapBloc = BlocProvider.of<MapBloc>(context);

    return SizedBox(
      width: size.width,
      height: size.height,
      child: Stack(
        children: [
          const Positioned(
            top: 70,
            left: 20,
            child: _BtnBack(),
          ),
          Center(
            child: Transform.translate(
              offset: const Offset(0, -22),
              child: BounceInDown(
                from: 100,
                child: const Icon(Icons.location_on_rounded, size: 60),
              ),
            ),
          ),
          // boton corfirmacion
          Positioned(
              bottom: 70,
              left: 40,
              child: FadeInUp(
                duration: const Duration(milliseconds: 300),
                child: MaterialButton(
                  minWidth: size.width - 120,
                  color: Colors.black,
                  elevation: 0,
                  height: 50,
                  shape: const StadiumBorder(),
                  child: const Text('Confirmar destino',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300)),
                  onPressed: () async {
                    final inicio = locationBloc.state.ultimaUbicacionConocida;
                    if (inicio == null) return;

                    final fin = mapBloc.mapCenter;
                    if (fin == null) return;

                    ShowLoadingMessage(context);

                    final destino =
                        await searchBloc.getCoordenadasInicioAFin(inicio, fin);
                    await mapBloc.dibujarRoutePopyline(destino);

                    searchBloc.add(OnDectivateManualMarkerEvent()); // quitar barra

                    Navigator.pop(context);
                  },
                ),
              ))
        ],
      ),
    );
  }
}

class _BtnBack extends StatelessWidget {
  const _BtnBack({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final searchBloc = BlocProvider.of<SearchBloc>(context);

    return FadeInLeft(
      duration: const Duration(milliseconds: 300),
      child: CircleAvatar(
        maxRadius: 25,
        backgroundColor: Colors.white,
        child: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
          ),
          onPressed: () {
            searchBloc.add(OnDectivateManualMarkerEvent());
          },
        ),
      ),
    );
  }
}
