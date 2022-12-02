import 'package:flutter/material.dart';
import 'package:news/src/blocs/news_bloc/news_bloc.dart';
import 'package:news/src/models/article/article_model.dart';
import '../most_popular_news_list.dart';

class SilverAppBarGlobal extends StatelessWidget {
  SilverAppBarGlobal();

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      flexibleSpace: StreamBuilder(
          stream: newsBloc.mostPopularNews,
          builder: (context, AsyncSnapshot<ArticleModel> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.articles.length >= 3) {
                return MostPopularNews(
                  snapshot.data.articles.take(3).toList(),
                );
              } else if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }
            }
            return Container(width: 0.0, height: 0.0);
          }),
      expandedHeight: 200,
    );
  }
}
