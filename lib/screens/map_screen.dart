import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:maps_app/blocs/blocs.dart';
import 'package:maps_app/views/views.dart';
import 'package:maps_app/widgets/widgets.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late LocationBloc locationBloc;

  @override
  void initState() {
    super.initState();
    locationBloc = BlocProvider.of<LocationBloc>(context);
    locationBloc.empezarSeguirUsuario();
  }

  @override
  void dispose() {
    locationBloc.stopSeguirUsuario();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<LocationBloc, LocationState>(
        builder: (context, state) {
          if (state.ultimaUbicacionConocida == null) {
            return const Center(child: Text('Espere por favor...'));
          }
          return SingleChildScrollView(
            // para q aparezca bien el mapa
            child: Stack(
              children: [
                MapView(initialLocation: state.ultimaUbicacionConocida!),
              ],
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: const [BtnCurrentLocation()],
      ),
    );
  }
}
