import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/src/blocs/connectivity_bloc/connectivity_bloc.dart';
import 'package:news/src/blocs/language_bloc/language_bloc.dart';
import 'package:news/src/blocs/news_bloc/news_bloc.dart';
import 'package:news/src/ui/search/search_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:news/src/blocs/advanced_search_bloc/advanced_search_bloc.dart';
import 'package:news/src/ui/global_news/global_news_list.dart';
import 'package:news/src/ui/global_news/silver_app_bar_globals.dart';
import 'package:news/src/utils/app_localizations.dart';
import '../../models/article/article_model.dart';

class GlobalNews extends StatefulWidget {
  @override
  _GlobalNewsState createState() => _GlobalNewsState();
}

class _GlobalNewsState extends State<GlobalNews> {
  var activeStream;
  Widget _appBarTitle;
  var connectionState;
  final TextEditingController _filter = new TextEditingController();
  AdvancedSearchState state;

  @override
  void initState() {
    state = BlocProvider.of<AdvancedSearchBloc>(context).state;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    connectionState = Provider.of<ConnectivityStatus>(context);

    if (connectionState == ConnectivityStatus.Offline) {
      newsBloc.fetchNewsFromDatabase();
      activeStream = newsBloc.offlineNews;
    } else if (connectionState == null ||
        connectionState == ConnectivityStatus.Cellular ||
        connectionState == ConnectivityStatus.WiFi) {
      newsBloc.fetchAllNews(
          languageCode:
              BlocProvider.of<LanguageBloc>(context).state.locale.languageCode,
          country: state.country,
          paging: state.paging,
          dateFrom: state.dateFrom,
          dateTo: state.dateTo,
          source: state.source);

      activeStream = newsBloc.allNews;
    }

    super.didChangeDependencies();
  }

  searchNews() {
    var connectionState =
        Provider.of<ConnectivityStatus>(context, listen: false);
    if (connectionState == ConnectivityStatus.Offline) {
      newsBloc.fetchNewsFromDatabase(keyword: _filter.text);
    } else if (connectionState == ConnectivityStatus.Cellular ||
        connectionState == ConnectivityStatus.WiFi ||
        connectionState == null) {
      newsBloc.fetchAllNews(
          languageCode:
              BlocProvider.of<LanguageBloc>(context).state.locale.languageCode,
          country: state.country,
          paging: state.paging,
          dateFrom: state.dateFrom,
          dateTo: state.dateTo,
          source: state.source,
          query: _filter.text);
      _closeInputField();
    }
  }

  void _closeInputField() {
    setState(() {
      _filter.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (connectionState == ConnectivityStatus.Offline) {
      this._appBarTitle = Text("Flutter News9 - Offline");
    } else {
      this._appBarTitle = Text("Flutter News9");
    }

    return Scaffold(
      appBar: SearchAppBar(_filter, searchNews, false, null, _appBarTitle),
      body: BlocBuilder<AdvancedSearchBloc, AdvancedSearchState>(
        builder: (context, state) {
          return StreamBuilder(
            stream: this.activeStream,
            builder: (context, AsyncSnapshot<ArticleModel> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.articles.length == 0) {
                  return Center(
                    child: Text(
                      AppLocalizations.of(context).translate('no_news'),
                    ),
                  );
                } else {
                  return CustomScrollView(
                    slivers: [
                      if (connectionState != ConnectivityStatus.Offline)
                        SilverAppBarGlobal(),
                      GlobalNewsList(snapshot),
                    ],
                  );
                }
              } else if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }

              return Center(child: CircularProgressIndicator());
            },
          );
        },
      ),
    );
  }
}
