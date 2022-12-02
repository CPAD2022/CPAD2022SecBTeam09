part of 'advanced_search_bloc.dart';

class AdvancedSearchState extends Equatable {
  final String dateFrom;
  final String dateTo;
  final String country;
  final String source;
  final String paging;

  const AdvancedSearchState(
      {this.dateFrom, this.dateTo, this.country, this.source, this.paging});

  @override
  List<Object> get props => [dateFrom, dateTo, country, source, paging];

  AdvancedSearchState copyWith({
    String dateFrom,
    String dateTo,
    String country,
    String source,
    String paging,
  }) {
    return AdvancedSearchState(
      dateFrom: dateFrom ?? this.dateFrom,
      dateTo: dateTo ?? this.dateTo,
      country: country ?? this.country,
      source: source ?? this.source,
      paging: paging ?? this.paging,
    );
  }
}
