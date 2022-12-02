import 'package:flutter/foundation.dart';
import 'package:news/src/resources/category_repository.dart';
import 'package:rxdart/rxdart.dart';

class CategoryBloc {
  final _categoryRepository = CategoryRepository();
  final _categoryFetches = PublishSubject<List<String>>();

  Stream<List<String>> get selectedCategories => _categoryFetches.stream;

  void insetCategoryList(data) {
    _categoryRepository.insertCategory(data);
  }

  void insertCategory(Category category) {
    _categoryRepository.insertCategory(category);
  }

  void deleteCategoriesByUid(String uid) {
    _categoryRepository.deleteCategories();
  }

  getAllCategories() async {
    return _categoryRepository.getAllCategories();
  }

  dispose() {
    _categoryFetches.close();
  }
}

final categoryBloc = CategoryBloc();
