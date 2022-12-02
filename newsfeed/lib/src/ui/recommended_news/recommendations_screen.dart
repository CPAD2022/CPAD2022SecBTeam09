import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/src/blocs/advanced_search_bloc/advanced_search_bloc.dart';
import 'package:news/src/blocs/category_bloc/category_bloc.dart';
import 'package:news/src/blocs/connectivity_bloc/connectivity_bloc.dart';
import 'package:news/src/blocs/language_bloc/language_bloc.dart';
import 'package:news/src/blocs/news_bloc/news_bloc.dart';
import 'package:news/src/constants/ColorConstants.dart';
import 'package:news/src/constants/categories.dart';
import 'package:news/src/extensions/Color.dart';
import 'package:news/src/models/article/article_model.dart';
import 'package:news/src/ui/recommended_news/recommended_news_list.dart';
import 'package:news/src/ui/search/search_app_bar.dart';
import 'package:news/src/utils/app_localizations.dart';
import 'package:provider/provider.dart';

String _selectedCategory;
AdvancedSearchState state;

class RecommendationsScreen extends StatefulWidget {
  @override
  _RecommendationsScreenState createState() => _RecommendationsScreenState();
}

class _RecommendationsScreenState extends State<RecommendationsScreen> {
  var _selectedCategories = [];
  final TextEditingController _filter = new TextEditingController();
  var connectionState;

  @override
  void didChangeDependencies() {
    connectionState = Provider.of<ConnectivityStatus>(context);

    if (connectionState == ConnectivityStatus.Cellular ||
        connectionState == ConnectivityStatus.WiFi ||
        connectionState == null) {
      getFromFuture();
    }
    super.didChangeDependencies();
  }

  Future<void> getFromFuture() async {
    _selectedCategories = await categoryBloc.getAllCategories();
    _selectedCategory = _selectedCategories[0];

    state = BlocProvider.of<AdvancedSearchBloc>(context).state;

    newsBloc.fetchAllNewsByCategory(
      languageCode:
          BlocProvider.of<LanguageBloc>(context).state.locale.languageCode,
      country: state.country,
      paging: state.paging,
      category: _selectedCategory,
    );
  }

  searchNews() {
    newsBloc.fetchAllNewsByCategory(
        languageCode:
            BlocProvider.of<LanguageBloc>(context).state.locale.languageCode,
        country: state.country,
        paging: state.paging,
        category: _selectedCategory,
        query: _filter.text);
  }

  void sortNews() {
    newsBloc.sortRecommendedNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: connectionState == ConnectivityStatus.Offline
          ? AppBar(
              title: Text('Flutter News9'),
              backgroundColor: HexColor.fromHex(ColorConstants.primaryColor),
            )
          : SearchAppBar(_filter, searchNews, true, sortNews),
      body: BlocBuilder<AdvancedSearchBloc, AdvancedSearchState>(
        builder: (context, state) {
          if (connectionState == ConnectivityStatus.Offline) {
            return Center(
              child: Text(
                AppLocalizations.of(context).translate('no_internet'),
              ),
            );
          } else {
            return StreamBuilder(
              stream: newsBloc.allNewsByCategory,
              builder: (context, AsyncSnapshot<ArticleModel> snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      Flexible(
                        child: CategoriesList(_selectedCategories),
                      ),
                      if (snapshot.data.articles.length == 0)
                        Flexible(
                          flex: 4,
                          child: Center(
                            child: Text(
                              AppLocalizations.of(context).translate('no_news'),
                            ),
                          ),
                        )
                      else
                        Flexible(
                          flex: 4,
                          child: RecommendedNewsList(snapshot),
                        ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }

                return Center(child: CircularProgressIndicator());
              },
            );
          }
        },
      ),
    );
  }
}

class CategoriesList extends StatelessWidget {
  CategoriesList(this.selectedCategories);

  final selectedCategories;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(4),
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: selectedCategories.length,
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemBuilder: (context, index) {
            return CategoryTile(selectedCategories[index]);
          }),
    );
  }
}

class CategoryTile extends StatefulWidget {
  CategoryTile(this.category);

  final String category;

  @override
  _CategoryTileState createState() => _CategoryTileState();
}

class _CategoryTileState extends State<CategoryTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = widget.category;
        });

        newsBloc.fetchAllNewsByCategory(
          languageCode:
              BlocProvider.of<LanguageBloc>(context).state.locale.languageCode,
          country: state.country,
          paging: state.paging,
          category: _selectedCategory,
        );
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: ConstrainedBox(
          constraints: new BoxConstraints(
            minWidth: 150,
          ),
          child: Card(
            color: widget.category == _selectedCategory
                ? HexColor.fromHex(ColorConstants.callToAction)
                : HexColor.fromHex(ColorConstants.secondaryColor),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  getIconOfCategory(widget.category),
                  color: widget.category == _selectedCategory
                      ? HexColor.fromHex(ColorConstants.selectedTextColor)
                      : HexColor.fromHex(ColorConstants.primaryTextColor),
                ),
                SizedBox(width: 4),
                Text(
                  AppLocalizations.of(context).translate(widget.category),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: widget.category == _selectedCategory
                        ? HexColor.fromHex(ColorConstants.selectedTextColor)
                        : HexColor.fromHex(ColorConstants.primaryTextColor),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
