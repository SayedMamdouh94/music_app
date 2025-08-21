part of 'searching_bloc.dart';

@immutable
sealed class SearchingEvent {}

class SearchQueryEvent extends SearchingEvent {
  final String query;
  final String type;

  SearchQueryEvent({required this.query, required this.type});
}
