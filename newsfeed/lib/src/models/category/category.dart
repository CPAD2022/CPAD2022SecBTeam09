import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';

part 'category.g.dart';

@HiveType(typeId: 0)
class Category {
  int id;

  @HiveField(0)
  String title;

  String uid;

  Category({this.title});

  map() {
    var map = Map<String, dynamic>();
    map['id'] = this.id;
    map['title'] = this.title;
    map['uid'] = FirebaseAuth.instance.currentUser?.uid ??
        "wOJ3BsX5EnNgFAZYvPeGdK3TCVf2"; //adamrumunce@gmail.com uid added for testing purposes
    return map;
  }
}
