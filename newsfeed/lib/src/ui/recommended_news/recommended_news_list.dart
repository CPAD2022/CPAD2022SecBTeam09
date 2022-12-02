import 'package:flutter/material.dart';
import 'package:news/src/models/article/article_model.dart';
import '../article_tile.dart';

class RecommendedNewsList extends StatelessWidget {
  RecommendedNewsList(this.snapshot);

  final AsyncSnapshot<ArticleModel> snapshot;

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).size.width > 600) {
      return Container(
        margin: EdgeInsets.only(top: 16),
        child: Scrollbar(
          child: GridView.builder(
            itemCount: snapshot.data.articles.length,
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemBuilder: (context, index) {
              return ArticleTile(
                isParentFavoriteScreen: false,
                article: snapshot.data.articles[index],
                enabled: true,
              );
            },
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: MediaQuery.of(context).size.width /
                  MediaQuery.of(context).size.height,
            ),
          ),
        ),
      );
    } else {
      return Container(
        margin: EdgeInsets.only(top: 16),
        child: Scrollbar(
          child: ListView.builder(
              itemCount: snapshot.data.articles.length,
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemBuilder: (context, index) {
                return ArticleTile(
                  isParentFavoriteScreen: false,
                  article: snapshot.data.articles[index],
                  enabled: true,
                );
              }),
        ),
      );
    }
  }
}
