import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/src/blocs/advanced_search_bloc/advanced_search_bloc.dart';
import 'package:news/src/constants/ColorConstants.dart';
import 'package:news/src/extensions/Color.dart';
import 'package:news/src/ui/favorite_news_screen.dart';
import 'package:news/src/ui/profile/profile.dart';
import 'package:news/src/ui/recommended_news/recommendations_screen.dart';
import 'package:news/src/utils/app_localizations.dart';
import 'global_news/global_news_screen.dart';

class NavigationScreen extends StatefulWidget {
  _NavigationScreenState createState() => _NavigationScreenState();

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => NavigationScreen());
  }
}

class _NavigationScreenState extends State<NavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _pageOptions = [
    GlobalNews(),
    RecommendationsScreen(),
    FavoriteNewsScreen(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AdvancedSearchBloc(),
      child: Scaffold(
        body: _pageOptions[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          iconSize: 30,
          items: [
            BottomNavigationBarItem(
                icon: _currentIndex == 0
                    ? Icon(
                        Icons.home_rounded,
                        color:
                            HexColor.fromHex(ColorConstants.selectedTextColor),
                      )
                    : Icon(
                        Icons.home_outlined,
                        color:
                            HexColor.fromHex(ColorConstants.selectedTextColor),
                      ),
                label: AppLocalizations.of(context).translate('global'),
                backgroundColor: HexColor.fromHex(ColorConstants.primaryColor)),
            BottomNavigationBarItem(
              icon: _currentIndex == 1
                  ? Icon(
                      Icons.star_rounded,
                      color: HexColor.fromHex(ColorConstants.selectedTextColor),
                    )
                  : Icon(
                      Icons.star_border_rounded,
                      color: HexColor.fromHex(ColorConstants.selectedTextColor),
                    ),
              label: AppLocalizations.of(context).translate('recommended'),
              backgroundColor: HexColor.fromHex(ColorConstants.primaryColor),
            ),
            BottomNavigationBarItem(
              icon: _currentIndex == 2
                  ? Icon(
                      Icons.bookmark_rounded,
                      color: HexColor.fromHex(ColorConstants.selectedTextColor),
                    )
                  : Icon(
                      Icons.bookmark_border_rounded,
                      color: HexColor.fromHex(ColorConstants.selectedTextColor),
                    ),
              label: AppLocalizations.of(context).translate('favorites'),
              backgroundColor: HexColor.fromHex(ColorConstants.primaryColor),
            ),
            BottomNavigationBarItem(
              icon: _currentIndex == 3
                  ? Icon(
                      Icons.person_rounded,
                      color: HexColor.fromHex(ColorConstants.selectedTextColor),
                    )
                  : Icon(
                      Icons.person_outline_rounded,
                      color: HexColor.fromHex(ColorConstants.selectedTextColor),
                    ),
              label: AppLocalizations.of(context).translate('profile'),
              backgroundColor: HexColor.fromHex(ColorConstants.primaryColor),
            ),
          ],
          onTap: setCurrentIndex,
        ),
      ),
    );
  }

  void setCurrentIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
