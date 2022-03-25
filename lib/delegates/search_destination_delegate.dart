import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;

import 'package:maps_app/blocs/blocs.dart';
import 'package:maps_app/models/models.dart';

class SearchDestinationDelegate extends SearchDelegate<SearchResult> {
  // cambiar idioma
  SearchDestinationDelegate() : super(searchFieldLabel: 'Buscar...');

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios_new_outlined),
      onPressed: () {
        final result = SearchResult(cancelar: true);
        close(context, result);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final proximity =
        BlocProvider.of<LocationBloc>(context).state.ultimaUbicacionConocida!;
    final searchBloc = BlocProvider.of<SearchBloc>(context);
    searchBloc.getPlacesPorQuery(proximity, query);

    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        final lugares = state.lugares;
        return ListView.separated(
          itemCount: lugares.length,
          separatorBuilder: (context, i) => const Divider(),
          itemBuilder: (context, i) {
            final lugar = lugares[i];
            return ListTile(
              title: Text(lugar.text),
              subtitle: Text(lugar.placeName),
              leading: const Icon(
                Icons.place_outlined,
                color: Colors.black,
              ),
              onTap: () {
                final result = SearchResult(
                  cancelar: false,
                  manual: false,
                  posicion: LatLng(lugar.center[1], lugar.center[0]), // MapBox a GMaps
                  nombre: lugar.text,
                  descripcion: lugar.placeName,
                );

                searchBloc.add(AddToHistoryEvent(lugar)); // añadir al historial

                close(context, result);
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final searchBloc = BlocProvider.of<SearchBloc>(context);
    final historial = searchBloc.state.historial;
    return ListView(
      children: [
        ListTile(
            leading: const Icon(Icons.location_on_outlined, color: Colors.black),
            title: const Text('Colocar la ubicación manualmente',
                style: TextStyle(color: Colors.black, fontSize: 14)),
            onTap: () {
              final result = SearchResult(cancelar: false, manual: true);
              close(context, result);
            }),

        // ahora se imprime el historial
        ...historial.map(
          (lugar) => ListTile(
              leading: const Icon(Icons.history, color: Colors.black),
              title: Text(lugar.text,
                  style: const TextStyle(color: Colors.black, fontSize: 14)),
              onTap: () {
                final result = SearchResult(
                  cancelar: false,
                  manual: false,
                  nombre: lugar.text,
                  posicion: LatLng(lugar.center[1], lugar.center[0]), // MapBox a GMaps
                );
                close(context, result);
              }),
        )
      ],
    );
  }
}
