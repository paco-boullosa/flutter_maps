import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maps_app/blocs/blocs.dart';
import 'package:animate_do/animate_do.dart';

import 'package:maps_app/delegates/delegates.dart';
import 'package:maps_app/models/models.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        return (state.displayManualMarker) ? const SizedBox() : const _SearchBarBody();
      },
    );
  }
}

class _SearchBarBody extends StatelessWidget {
  const _SearchBarBody({Key? key}) : super(key: key);

  void onSearchResults(BuildContext context, SearchResult result) async {
    final searchBloc = BlocProvider.of<SearchBloc>(context);
    if (result.manual) {
      searchBloc.add(OnActivateManualMarkerEvent());
      return;
    }
    if (result.posicion != null) {
      final inicio = BlocProvider.of<LocationBloc>(context).state.ultimaUbicacionConocida;
      final mapBloc = BlocProvider.of<MapBloc>(context);
      final destino =
          await searchBloc.getCoordenadasInicioAFin(inicio!, result.posicion!);
      await mapBloc.dibujarRoutePopyline(destino);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeInDown(
      duration: const Duration(milliseconds: 300),
      child: SafeArea(
        child: Container(
          margin: const EdgeInsets.only(top: 10),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          width: double.infinity,
          child: GestureDetector(
            onTap: () async {
              final result = await showSearch(
                  context: context, delegate: SearchDestinationDelegate());
              if (result == null) return;

              onSearchResults(context, result);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
              child: const Text(
                '¿A dónde quieres ir?',
                style: TextStyle(color: Colors.black87),
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 5)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
