import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/src/blocs/advanced_search_bloc/advanced_search_bloc.dart';
import 'package:news/src/blocs/connectivity_bloc/connectivity_bloc.dart';
import 'package:news/src/blocs/news_bloc/news_bloc.dart';
import 'package:news/src/constants/countries.dart';
import 'package:news/src/models/article/article_model.dart';
import 'package:news/src/models/source_model.dart';
import 'package:news/src/utils/app_localizations.dart';
import 'package:provider/provider.dart';

Source source;
String country;

class AdvancedSearchInput extends StatefulWidget {
  @override
  _AdvancedSearchInputState createState() => _AdvancedSearchInputState();
}

class _AdvancedSearchInputState extends State<AdvancedSearchInput> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdvancedSearchBloc, AdvancedSearchState>(
      builder: (context, state) {
        if (source == null && country == null) {
          source = Source(name: state.source);
          country = state.country;
        }

        return Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            leading: Icon(Icons.settings),
            title: Text(
              AppLocalizations.of(context).translate('advanced_search'),
            ),
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)
                          .translate('advanced_search_title'),
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    Divider(height: 16),
                    Text(
                      AppLocalizations.of(context).translate('global_news'),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    _DateInput(state.dateFrom, state.dateTo),
                    if (Provider.of<ConnectivityStatus>(context) !=
                        ConnectivityStatus.Offline)
                      _SourceInput(),
                    Divider(height: 16),
                    Text(
                      AppLocalizations.of(context)
                          .translate('global_recommended'),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    _CountryInput(),
                    _PagingInput(state.paging),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CountryInput extends StatefulWidget {
  @override
  __CountryInputState createState() => __CountryInputState();
}

class __CountryInputState extends State<_CountryInput> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(AppLocalizations.of(context).translate('country') + ':'),
        ),
        Expanded(
          flex: 3,
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: DropdownButton<String>(
              value: country,
              isExpanded: true,
              icon: const Icon(Icons.arrow_downward),
              iconSize: 24,
              elevation: 16,
              onChanged: (String newValue) {
                setState(() {
                  country = newValue;
                  source = Source(name: 'All', id: 'all');

                  BlocProvider.of<AdvancedSearchBloc>(context).add(
                    AdvancedSearchSelected(
                        source: source.id,
                        dateFrom: '',
                        dateTo: '',
                        country: country),
                  );
                });
              },
              items: countries.values
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: value == 'All'
                      ? Text(
                          AppLocalizations.of(context).translate('all'),
                        )
                      : Text(value),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class _SourceInput extends StatefulWidget {
  @override
  __SourceInputState createState() => __SourceInputState();
}

class __SourceInputState extends State<_SourceInput> {
  @override
  void initState() {
    newsBloc.fetchAllSources();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: newsBloc.allSources,
        builder: (context, AsyncSnapshot<SourceModel> snapshot) {
          if (snapshot.hasData && snapshot.data.sources.isNotEmpty) {
            return Row(
              children: [
                Expanded(
                  child: Text(
                      AppLocalizations.of(context).translate('source') + ':'),
                ),
                Expanded(
                  flex: 3,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: DropdownButton<Source>(
                      isExpanded: true,
                      value: source,
                      icon: const Icon(Icons.arrow_downward),
                      iconSize: 24,
                      elevation: 16,
                      onChanged: (Source newValue) {
                        setState(() {
                          source = newValue;
                          country = 'All';

                          BlocProvider.of<AdvancedSearchBloc>(context).add(
                            AdvancedSearchSelected(
                                source: source.id,
                                dateFrom: '',
                                dateTo: '',
                                country: country),
                          );
                        });
                      },
                      items: snapshot.data.sources
                          .map<DropdownMenuItem<Source>>((Source value) {
                        return DropdownMenuItem<Source>(
                          value: value,
                          child: value.name == 'All'
                              ? Text(
                                  AppLocalizations.of(context).translate('all'),
                                )
                              : Text(value.name),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }

          return Container(width: 0.0, height: 0.0);
        });
  }
}

class _PagingInput extends StatefulWidget {
  _PagingInput(this.paging);

  final String paging;

  @override
  __PagingInputState createState() => __PagingInputState(paging);
}

class __PagingInputState extends State<_PagingInput> {
  __PagingInputState(this.paging);

  String paging;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(AppLocalizations.of(context).translate('paging') + ':'),
        ),
        SizedBox(width: 8),
        Expanded(
          flex: 3,
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: DropdownButton<String>(
              isExpanded: true,
              value: paging,
              icon: const Icon(Icons.arrow_downward),
              iconSize: 24,
              elevation: 16,
              onChanged: (String newValue) {
                setState(() {
                  paging = newValue;
                  BlocProvider.of<AdvancedSearchBloc>(context).add(
                    AdvancedSearchPagingSelected(newValue),
                  );
                });
              },
              items: <String>['10', '20', '50', '100']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class _DateInput extends StatefulWidget {
  _DateInput(this.dateFrom, this.dateTo);

  final String dateFrom;
  final String dateTo;

  @override
  __DateInputState createState() => __DateInputState();
}

class __DateInputState extends State<_DateInput> {
  DateTime selectedDateFrom;
  DateTime selectedDateTo;
  String labelTextFrom;
  String labelTextTo;

  @override
  void initState() {
    selectedDateFrom = widget.dateFrom.isNotEmpty
        ? DateTime.parse(widget.dateFrom)
        : DateTime.now();

    labelTextFrom = "${selectedDateFrom.toLocal()}".split(' ')[0];

    selectedDateTo = widget.dateTo.isNotEmpty
        ? DateTime.parse(widget.dateTo)
        : DateTime.now();

    labelTextTo = "${selectedDateTo.toLocal()}".split(' ')[0];
    super.initState();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTimeRange picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000, 1),
      lastDate: DateTime.now(),
      initialDateRange:
          DateTimeRange(start: selectedDateFrom, end: selectedDateTo),
    );
    if (picked != null)
      setState(() {
        selectedDateFrom = picked.start;
        selectedDateTo = picked.end;
        labelTextFrom = "${selectedDateFrom.toLocal()}".split(' ')[0];
        labelTextTo = "${selectedDateTo.toLocal()}".split(' ')[0];

        source = Source(name: 'All', id: 'all');
        country = 'All';

        BlocProvider.of<AdvancedSearchBloc>(context).add(
          AdvancedSearchSelected(
              source: source.id,
              dateFrom: selectedDateFrom.toString(),
              dateTo: selectedDateTo.toString(),
              country: country),
        );
      });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              child: Icon(
                Icons.calendar_today,
              ),
              onTap: () => _selectDate(context),
            ),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          flex: 5,
          child: Text(AppLocalizations.of(context).translate('from') +
              ': $labelTextFrom'),
        ),
        SizedBox(width: 16),
        Expanded(
          flex: 5,
          child: Text(
              AppLocalizations.of(context).translate('to') + ': $labelTextTo'),
        ),
      ],
    );
  }
}
