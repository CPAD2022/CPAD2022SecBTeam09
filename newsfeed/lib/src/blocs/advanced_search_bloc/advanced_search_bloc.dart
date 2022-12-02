import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:news/src/utils/shared_preferences_advanced_search_service.dart';
part 'advanced_search_event.dart';
part 'advanced_search_state.dart';

class AdvancedSearchBloc
    extends Bloc<AdvancedSearchEvent, AdvancedSearchState> {
  AdvancedSearchBloc()
      : super(
          AdvancedSearchState(
              dateFrom: '',
              dateTo: '',
              source: 'All',
              country: 'All',
              paging: '10'),
        );

  @override
  Stream<AdvancedSearchState> mapEventToState(
    AdvancedSearchEvent event,
  ) async* {
    if (event is AdvancedSearchLoadStarted) {
      yield* _mapSearchLoadStartedToState();
    } else if (event is AdvancedSearchSelected) {
      yield* _mapSearchToState(
          event.country, event.dateFrom, event.dateTo, event.source);
    } else if (event is AdvancedSearchPagingSelected) {
      yield* _mapPagingToState(event.paging);
    }
  }

  Stream<AdvancedSearchState> _mapSearchLoadStartedToState() async* {
    final sharedPrefService =
        await SharedPreferencesAdvancedSearchService.instance;

    final defaultCountry = sharedPrefService.country;
    final defaultDateFrom = sharedPrefService.dateFrom;
    final defaultDateTo = sharedPrefService.dateTo;
    final defaultPaging = sharedPrefService.paging;
    final defaultSource = sharedPrefService.source;

    String country;
    String dateFrom;
    String dateTo;
    String paging;
    String source;

    if (defaultCountry == null) {
      country = 'All';
      await sharedPrefService.setCountry(country);
    } else {
      country = defaultCountry;
    }

    if (defaultDateFrom == null && defaultDateTo == null) {
      dateFrom = '';
      dateTo = '';
      await sharedPrefService.setDate(dateFrom, dateTo);
    } else {
      dateFrom = defaultDateFrom;
      dateTo = defaultDateTo;
    }

    if (defaultPaging == null) {
      paging = '10';
      await sharedPrefService.setPaging(paging);
    } else {
      paging = defaultPaging;
    }

    if (defaultSource == null) {
      source = 'All';
      await sharedPrefService.setSource(source);
    } else {
      source = defaultSource;
    }

    yield AdvancedSearchState(
        country: country,
        dateFrom: dateFrom,
        dateTo: dateTo,
        paging: paging,
        source: source);
  }

  Stream<AdvancedSearchState> _mapSearchToState(
      String country, String dateFrom, String dateTo, String source) async* {
    final sharedPrefService =
        await SharedPreferencesAdvancedSearchService.instance;
    await sharedPrefService.setCountry(country);
    await sharedPrefService.setDate(dateFrom, dateTo);
    await sharedPrefService.setSource(source);

    yield state.copyWith(
        country: country,
        dateFrom: dateFrom,
        dateTo: dateTo,
        paging: state.paging,
        source: source);
  }

  Stream<AdvancedSearchState> _mapPagingToState(String paging) async* {
    final sharedPrefService =
        await SharedPreferencesAdvancedSearchService.instance;
    await sharedPrefService.setPaging(paging);

    yield state.copyWith(
        country: state.country,
        dateFrom: state.dateFrom,
        dateTo: state.dateTo,
        paging: paging,
        source: state.source);
  }
}
