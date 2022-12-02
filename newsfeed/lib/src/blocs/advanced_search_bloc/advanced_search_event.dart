part of 'advanced_search_bloc.dart';

abstract class AdvancedSearchEvent extends Equatable {
  const AdvancedSearchEvent();

  @override
  List<Object> get props => [];
}

class AdvancedSearchLoadStarted extends AdvancedSearchEvent {}

class AdvancedSearchSelected extends AdvancedSearchEvent {
  final String source;
  final String country;
  final String dateFrom;
  final String dateTo;

  AdvancedSearchSelected(
      {this.country, this.source, this.dateFrom, this.dateTo});

  @override
  List<Object> get props => [source, country, dateFrom, dateTo];
}

class AdvancedSearchPagingSelected extends AdvancedSearchEvent {
  final String paging;

  AdvancedSearchPagingSelected(this.paging);

  @override
  List<Object> get props => [paging];
}
