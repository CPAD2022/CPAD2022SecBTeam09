import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:news/src/blocs/category_bloc/category_bloc.dart';
import 'package:news/src/constants/categories.dart';
import 'package:news/src/models/category/category_tile.dart';
import 'package:news/src/utils/app_localizations.dart';
import 'package:news/src/utils/shared_preferences_topic_select_service.dart';
import '../constants/ColorConstants.dart';
import '../extensions/Color.dart';
import 'navigation_screen.dart';

class TopicSelectScreen extends StatefulWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => TopicSelectScreen());
  }

  _TopicSelectScreenState createState() => _TopicSelectScreenState();
}

class _TopicSelectScreenState extends State<TopicSelectScreen> {
  var _selectedCategories = [];
  List<CategoryTile> _categories = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getFromFuture();
    });

    super.initState();
  }

  Future<void> getFromFuture() async {
    _selectedCategories = await categoryBloc.getAllCategories();

    setState(() {
      _selectedCategories = _selectedCategories ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    _categories = categories;

    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter News9'),
        backgroundColor: HexColor.fromHex(ColorConstants.primaryColor),
      ),
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 600),
          padding: EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(top: 8, left: 8),
                    child: Text(
                      AppLocalizations.of(context).translate('topic_title'),
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color:
                            HexColor.fromHex(ColorConstants.primaryTextColor),
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(
                      top: 8,
                      left: 8,
                      bottom: 8,
                    ),
                    child: Text(
                      AppLocalizations.of(context).translate('topic_subtitle'),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: HexColor.fromHex(ColorConstants.silverGray),
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: Container(
                    alignment: Alignment.center,
                    child: _gridView(),
                  ),
                ),
                Flexible(
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    child: ConstrainedBox(
                      constraints: BoxConstraints.tightFor(
                          width: double.infinity, height: 60),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            _selectedCategories.length >= 2
                                ? HexColor.fromHex(ColorConstants.callToAction)
                                : HexColor.fromHex(
                                    ColorConstants.callToActionDisables),
                          ),
                        ),
                        onPressed: _selectedCategories.length >= 2
                            ? () async {
                                categoryBloc.deleteCategoriesByUid(
                                    FirebaseAuth.instance.currentUser?.uid ??
                                        "wOJ3BsX5EnNgFAZYvPeGdK3TCVf2");
                                categoryBloc
                                    .insetCategoryList(_selectedCategories);

                                final sharedPrefService =
                                    await SharedPreferencesTopicSelectService
                                        .instance;

                                if (sharedPrefService.isFirstTime()) {
                                  sharedPrefService.setValue();

                                  Navigator.of(context)
                                      .pushAndRemoveUntil<void>(
                                    NavigationScreen.route(),
                                    (route) => false,
                                  );
                                } else {
                                  Navigator.of(context).pop();
                                }
                              }
                            : null,
                        child: Text(
                          AppLocalizations.of(context).translate('finish'),
                          style: TextStyle(
                            color: HexColor.fromHex(
                                ColorConstants.selectedTextColor),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _gridView() {
    return Container(
      margin: EdgeInsets.all(8),
      child: GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 220,
              childAspectRatio: 5 / 2.5,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12),
          itemCount: _categories.length,
          itemBuilder: (context, index) {
            return MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  setTileState(index);
                },
                child: Card(
                  color: _selectedCategories.contains(_categories[index].title)
                      ? HexColor.fromHex(ColorConstants.callToAction)
                      : HexColor.fromHex(ColorConstants.secondaryColor),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Row(
                      children: [
                        Flexible(
                          child: Icon(
                            _categories[index].icon,
                            color: _selectedCategories
                                    .contains(_categories[index].title)
                                ? HexColor.fromHex(
                                    ColorConstants.secondaryColor)
                                : HexColor.fromHex(
                                    ColorConstants.primaryTextColor),
                          ),
                        ),
                        SizedBox(width: 4),
                        Flexible(
                          flex: 3,
                          child: Text(
                            AppLocalizations.of(context)
                                .translate(_categories[index].title),
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: _selectedCategories
                                      .contains(_categories[index].title)
                                  ? HexColor.fromHex(
                                      ColorConstants.secondaryColor)
                                  : HexColor.fromHex(
                                      ColorConstants.primaryTextColor),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }

  void setTileState(int index) {
    setState(() {
      _selectedCategories.contains(_categories[index].title)
          ? _selectedCategories.remove(_categories[index].title)
          : _selectedCategories.add(_categories[index].title);
    });
  }
}
