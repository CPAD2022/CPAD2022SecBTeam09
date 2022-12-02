import 'package:hive/hive.dart';

class CategoryRepository {
  final String key = "category";

  Future<void> insertCategory(data) async {
    var box = await Hive.openBox('category');
    box.put(key, data);
  }

  Future<void> deleteCategories() async {
    var box = await Hive.openBox('category');
    box.delete(key);
  }

  getAllCategories() async {
    var box = await Hive.openBox('category');
    List<dynamic> categories = box.get(key);
    box.close();
    return categories;
  }
}
