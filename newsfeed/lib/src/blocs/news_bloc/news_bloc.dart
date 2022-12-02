import 'package:news/src/constants/enums.dart';
import 'package:news/src/models/source_model.dart';
import 'package:news/src/ui/dialogs/filter_news_dialog.dart';
import 'package:news/src/utils/sorting.dart';
import 'package:rxdart/rxdart.dart';
import '../../resources/news_repository.dart';
import '../../models/article/article_model.dart';

class NewsBloc {
  final _repository = NewsRepository();
  final _newsFetcher = PublishSubject<ArticleModel>();
  final _newsFetcherByCategory = PublishSubject<ArticleModel>();
  final _sourcesFetcher = PublishSubject<SourceModel>();
  final _favoriteNewsFetcher = PublishSubject<ArticleModel>();
  final _offlineNewsFetcher = PublishSubject<ArticleModel>();
  final _mostPopularNewsFetcher = PublishSubject<ArticleModel>();

  Stream<ArticleModel> get allNews => _newsFetcher.stream;

  Stream<ArticleModel> get allNewsByCategory => _newsFetcherByCategory.stream;

  Stream<ArticleModel> get favoriteNews => _favoriteNewsFetcher.stream;

  Stream<ArticleModel> get offlineNews => _offlineNewsFetcher.stream;

  Stream<SourceModel> get allSources => _sourcesFetcher.stream;

  Stream<ArticleModel> get mostPopularNews => _mostPopularNewsFetcher.stream;

  ArticleModel news;
  ArticleModel articles;

  Future<void> fetchAllNews({
    String languageCode,
    String dateFrom,
    String dateTo,
    String country,
    String source,
    String paging,
    String query = "",
  }) async {
    ArticleModel news = await _repository.fetchAllNews(
        languageCode: languageCode,
        dateFrom: dateFrom,
        dateTo: dateTo,
        country: country,
        source: source,
        paging: paging,
        query: query);

    _newsFetcher.sink.add(news);
    deleteNewsBox("offline_news").then((value) => insertNewsList(news));

    ArticleModel popularNews =
        await _repository.fetchMostPopularNews(languageCode, country);
    _mostPopularNewsFetcher.sink.add(popularNews);
  }

  Future<void> fetchAllNewsByCategory({
    String languageCode,
    String country,
    String paging,
    String category,
    String query = "",
  }) async {
    news = await _repository.fetchAllNewsByCategory(
      languageCode: languageCode,
      country: country,
      paging: paging,
      category: category,
      query: query,
    );

    sortRecommendedNews();
  }

  Future<void> fetchMostPopularNews({
    String languageCode,
    String country,
  }) async {}

  Future<void> fetchAllSources() async {
    SourceModel sources = await _repository.fetchAllSources();
    _sourcesFetcher.sink.add(sources);
  }

  Future<void> fetchFavoriteNewsFromDatabase() async {
    var news = await _repository.fetchNews("favorite_news");

    articles = ArticleModel();
    news.forEach((article) async {
      var art = await mapArticle(article);
      articles.articles.add(art);
    });

    sortFavoritesNews();
  }

  Future<List<String>> fetchFavoriteTitles() async {
    var news = await _repository.fetchNews("favorite_news");
    List<String> favoriteTitles = [];
    news.forEach((i) {
      favoriteTitles.add(i.title);
    });
    return favoriteTitles;
  }

  Future<void> fetchNewsFromDatabase({String keyword}) async {
    var news = await _repository.fetchNews("offline_news");
    ArticleModel articles = ArticleModel();
    news.forEach((article) async {
      if (keyword == null) {
        var art = await mapArticle(article);
        articles.articles.add(art);
      } else if (article.title.toLowerCase().contains(keyword)) {
        var art = await mapArticle(article);
        articles.articles.add(art);
      }
    });
    _offlineNewsFetcher.sink.add(articles);
  }

  void insertNewsList(ArticleModel articlesModel) {
    int counter = 0;

    articlesModel.articles.forEach((element) {
      if (counter > 30) return;
      insertNews("offline_news", element);
      counter++;
    });
  }

  Future<void> insertNewsByUid(boxName, article) async {
    if (!article.isFavorite) {
      _repository.insertNewsByUuid(boxName, article, article.title);
    } else {
      _repository.deleteNewsByUuid(
          boxName, article.title.replaceAll(RegExp(r'[^\x20-\x7E]'), ''));
    }
    fetchFavoriteNewsFromDatabase();
  }

  void insertNews(boxName, Article article) {
    _repository.insertNews(boxName, article);
  }

  Future<void> deleteNewsBox(boxName) async {
    _repository.deleteNewsBox(boxName);
  }

  void deleteNewsByUuid(String uuid) {
    _repository.deleteNewsByUuid('favorite_news', uuid);
  }

  deleteNewsList(List<Article> articles) {
    articles.forEach((element) {
      deleteNewsByUuid(element.title.replaceAll(RegExp(r'[^\x20-\x7E]'), ''));
    });
  }

  Future<Article> mapArticle(Article article) async {
    bool isFavorite = await isArticleInFavorites(article.title);
    return Article.create(
        article.author,
        article.title,
        article.description,
        article.url,
        article.urlToImage,
        article.publishedAt,
        Source(id: article.source?.id, name: article.source?.name),
        isFavorite);
  }

  Future<bool> isArticleInFavorites(String articleTitle) async {
    List<String> favoriteTitles = await fetchFavoriteTitles();
    if (favoriteTitles.contains(articleTitle)) {
      return true;
    } else
      return false;
  }

  void dispose() {
    _newsFetcher.close();
    _sourcesFetcher.close();
    _favoriteNewsFetcher.close();
    _newsFetcherByCategory.close();
    _mostPopularNewsFetcher.close();
    _offlineNewsFetcher.close();
  }

  void sortRecommendedNews() {
    if (optionsRecommended == SortOptions.title) {
      _newsFetcherByCategory.sink.add(Sort.sortByTitle(news, orderRecommended));
    } else if (optionsRecommended == SortOptions.date) {
      _newsFetcherByCategory.sink.add(Sort.sortByDate(news, orderRecommended));
    } else if (optionsRecommended == SortOptions.source) {
      _newsFetcherByCategory.sink
          .add(Sort.sortBySource(news, orderRecommended));
    }
  }

  void sortFavoritesNews() {
    if (optionsFavorites == SortOptions.title) {
      _favoriteNewsFetcher.sink.add(Sort.sortByTitle(articles, orderFavorites));
    } else if (optionsFavorites == SortOptions.date) {
      _favoriteNewsFetcher.sink.add(Sort.sortByDate(articles, orderFavorites));
    } else if (optionsFavorites == SortOptions.source) {
      _favoriteNewsFetcher.sink
          .add(Sort.sortBySource(articles, orderFavorites));
    }
  }
}

final newsBloc = NewsBloc();
