part of 'search_bloc.dart';

abstract class SearchAddressEvent {}

class SearchAddress extends SearchAddressEvent {
  String value;

  SearchAddress(this.value);
}

class ChangeMapPosition extends SearchAddressEvent {
  LatLng coordinates;

  ChangeMapPosition(this.coordinates);
}

class GetAddressPosition extends SearchAddressEvent {}

class SearchAddressClear extends SearchAddressEvent {}

class SearchMeEvent extends SearchAddressEvent {}

class JumpToPointEvent extends SearchAddressEvent {
  final Point point;
  JumpToPointEvent(this.point);
}

class SearchAddressPolilyne extends SearchAddressEvent {
  List<Suggestions?> suggestionsStart;
  List<Suggestions?> suggestionsEnd;

  SearchAddressPolilyne(this.suggestionsStart, this.suggestionsEnd);
}

class DeletePolilyneEvent extends SearchAddressEvent {}
