part of 'search_bloc.dart';

class SearchState extends Equatable {
  final bool displayManualMarker;
  final List<Feature> lugares;
  final List<Feature> historial;

  const SearchState({
    this.displayManualMarker = false,
    this.lugares = const [],
    this.historial = const [],
  });

  SearchState copyWith({
    bool? displayManualMarker,
    List<Feature>? lugares,
    List<Feature>? historial,
  }) =>
      SearchState(
        displayManualMarker: displayManualMarker ?? this.displayManualMarker,
        lugares: lugares ?? this.lugares,
        historial: historial ?? this.historial,
      );

  @override
  List<Object> get props => [displayManualMarker, lugares, historial];
}
