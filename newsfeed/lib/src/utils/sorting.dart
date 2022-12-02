import 'package:news/src/constants/enums.dart';
import 'package:news/src/models/article/article_model.dart';

class Sort {
  static ArticleModel sortByDate(ArticleModel articlesModel, SortOrder order) {
    articlesModel.articles
        .sort((a, b) => a.publishedAt.compareTo(b.publishedAt));

    if (order == SortOrder.desc)
      articlesModel.articles = articlesModel.articles.reversed.toList();

    return articlesModel;
  }

  static ArticleModel sortByTitle(ArticleModel articlesModel, SortOrder order) {
    articlesModel.articles.sort((a, b) => a.title.compareTo(b.title));

    if (order == SortOrder.desc)
      articlesModel.articles = articlesModel.articles.reversed.toList();

    return articlesModel;
  }

  static ArticleModel sortBySource(
      ArticleModel articlesModel, SortOrder order) {
    articlesModel.articles
        .sort((a, b) => a.source.name.compareTo(b.source.name));

    if (order == SortOrder.desc)
      articlesModel.articles = articlesModel.articles.reversed.toList();

    return articlesModel;
  }
}
