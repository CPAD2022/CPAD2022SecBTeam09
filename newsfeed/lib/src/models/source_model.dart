import 'package:news/src/models/article/article_model.dart';

class SourceModel {
  String _status;
  List<Source> _sources = [];

  SourceModel();

  SourceModel.fromJson(Map<String, dynamic> parsedJson) {
    _status = parsedJson['status'];

    List<Source> temp = [];
    temp.add(Source(name: 'All', id: 'all'));
    int _listLength = parsedJson['sources'].length;

    for (int i = 0; i < _listLength; i++) {
      Source source = Source.fromJson(parsedJson['sources'][i]);
      temp.add(source);
    }

    _sources = temp;
  }

  String get status => _status;

  List<Source> get sources => _sources;
}
