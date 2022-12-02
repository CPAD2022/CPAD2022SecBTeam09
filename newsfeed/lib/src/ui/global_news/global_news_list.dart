import 'package:flutter/material.dart';
import 'package:news/src/models/article/article_model.dart';
import '../article_tile.dart';

class GlobalNewsList extends StatelessWidget {
  GlobalNewsList(this.snapshot);

  final AsyncSnapshot<ArticleModel> snapshot;

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).size.width > 600) {
      return SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: MediaQuery.of(context).size.width /
              MediaQuery.of(context).size.height,
          crossAxisCount: 2,
        ),
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return ArticleTile(
              isParentFavoriteScreen: false,
              article: snapshot.data.articles[index],
              enabled: true,
            );
          },
          childCount: snapshot.data.articles.length,
        ),
      );
    } else {
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => ArticleTile(
            isParentFavoriteScreen: false,
            article: snapshot.data.articles[index],
            enabled: true,
          ),
          childCount: snapshot.data.articles.length,
        ),
      );
    }
  }
}
