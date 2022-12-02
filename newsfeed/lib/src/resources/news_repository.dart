import 'dart:async';
import 'package:hive/hive.dart';
import 'package:news/src/models/source_model.dart';
import 'news_api_provider.dart';
import '../models/article/article_model.dart';

class NewsRepository {
  final newsApiProvider = NewsApiProvider();

  Future<ArticleModel> fetchAllNews(
          {String languageCode,
          String dateFrom,
          String dateTo,
          String country,
          String source,
          String paging,
          String query = ""}) =>
      newsApiProvider.fetchNewsList(
        languageCode: languageCode,
        dateFrom: dateFrom,
        dateTo: dateTo,
        country: country,
        source: source,
        paging: paging,
        query: query,
      );

  Future<ArticleModel> fetchAllNewsByCategory({
    String languageCode,
    String country,
    String source,
    String paging,
    String category,
    String query,
  }) =>
      newsApiProvider.fetchNewsListByCategory(
        languageCode: languageCode,
        country: country,
        paging: paging,
        category: category,
        query: query,
      );

  Future<ArticleModel> fetchMostPopularNews(
          String languageCode, String country) =>
      newsApiProvider.fetchMostPopularNews(languageCode, country);

  Future<SourceModel> fetchAllSources() => newsApiProvider.fetchSourcesList();

  fetchNews(String boxName) async {
    var box = await Hive.openBox(boxName);
    return box.values;
  }

  insertNews(boxName, data) async {
    var box = await Hive.openBox(boxName);
    box.add(data);
  }

  insertNewsByUuid(boxName, Article data, uuid) async {
    var box = await Hive.openBox(boxName);
    box.put(data.title.replaceAll(RegExp(r'[^\x20-\x7E]'), ''), data);
  }

  deleteNewsBox(boxName) async {
    var box = await Hive.openBox(boxName);
    box.deleteAll(box.keys);
  }

  deleteNewsByUuid(boxName, uuid) async {
    var box = await Hive.openBox(boxName);
    box.delete(uuid);
  }
}
