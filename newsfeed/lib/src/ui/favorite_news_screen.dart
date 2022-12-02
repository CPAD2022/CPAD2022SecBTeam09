import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:news/src/blocs/news_bloc/news_bloc.dart';
import 'package:news/src/constants/ColorConstants.dart';
import 'package:news/src/extensions/Color.dart';
import 'package:news/src/models/article/article_model.dart';
import 'package:news/src/utils/app_localizations.dart';
import 'package:share/share.dart';
import 'article_tile.dart';
import 'dialogs/filter_news_dialog.dart';

class FavoriteNewsScreen extends StatefulWidget {
  FavoriteNewsScreenState createState() => FavoriteNewsScreenState();
}

class FavoriteNewsScreenState extends State<FavoriteNewsScreen> {
  List<Article> selectedArticles = [];

  @override
  void initState() {
    newsBloc.fetchFavoriteNewsFromDatabase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          title: Text("Flutter News9"),
          backgroundColor: HexColor.fromHex(ColorConstants.primaryColor),
          actions: <Widget>[
            selectedArticles.isEmpty
                ? Container()
                : IconButton(
                    icon: Icon(Icons.delete_rounded),
                    onPressed: () {
                      newsBloc.deleteNewsList(selectedArticles);
                      newsBloc.fetchFavoriteNewsFromDatabase();
                    }),
            if (selectedArticles.isNotEmpty &&
                Theme.of(context).platform != TargetPlatform.macOS &&
                !kIsWeb)
              IconButton(
                  icon: Icon(Icons.share_rounded),
                  onPressed: () {
                    if (selectedArticles.length == 1)
                      _shareArticle();
                    else
                      _shareArticles();
                  }),
            IconButton(
              icon: Icon(Icons.filter_alt),
              onPressed: () async {
                var sortNews = await FilterNewsDialog.showFilterNewsDialog(
                    context, 'favorites');
                if (sortNews) newsBloc.sortFavoritesNews();
              },
            ),
          ],
        ),
      ),
      body: Container(
        child: StreamBuilder(
          stream: newsBloc.favoriteNews,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.articles.length == 0) {
                return Center(
                  child: Text(
                    AppLocalizations.of(context).translate('no_favorites'),
                  ),
                );
              } else {
                return buildList(snapshot);
              }
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Widget buildList(AsyncSnapshot<ArticleModel> snapshot) {
    return Container(
      margin: EdgeInsets.only(top: 16),
      child: Scrollbar(
        child: ListView.builder(
            itemCount: snapshot.data.articles.length,
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemBuilder: (context, index) {
              return Container(
                  child: GestureDetector(
                      onLongPress: () {
                        setState(() {
                          if (selectedArticles
                              .contains(snapshot.data.articles[index])) {
                            selectedArticles
                                .remove(snapshot.data.articles[index]);
                          } else
                            selectedArticles.add(snapshot.data.articles[index]);
                        });
                      },
                      child:
                          _getArticleTileType(snapshot.data.articles[index])));
            }),
      ),
    );
  }

  ArticleTile _getArticleTileType(Article article) {
    if (!selectedArticles.contains(article)) {
      return ArticleTile(
        isParentFavoriteScreen: true,
        article: article,
        enabled: false,
      );
    } else
      return ArticleTile(
        isParentFavoriteScreen: true,
        article: article,
        backgroundColor: ColorConstants.primaryColor,
        enabled: false,
      );
  }

  _shareArticles() {
    String links = "";
    selectedArticles.forEach((element) {
      links += element.url + "\n\n";
    });
    Share.share(
        "${AppLocalizations.of(context).translate('checkout_articles')} \n $links");
  }

  _shareArticle() {
    Share.share(
        "${AppLocalizations.of(context).translate('checkout_article')} \n ${selectedArticles.first.url}");
  }
}
