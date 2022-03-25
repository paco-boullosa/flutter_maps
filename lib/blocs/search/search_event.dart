part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class OnActivateManualMarkerEvent extends SearchEvent {}

class OnDectivateManualMarkerEvent extends SearchEvent {}

class OnNewLugaresFoundEvent extends SearchEvent {
  final List<Feature> lugares;
  const OnNewLugaresFoundEvent(this.lugares);
}

class AddToHistoryEvent extends SearchEvent {
  final Feature lugar;
  const AddToHistoryEvent(this.lugar);
}
