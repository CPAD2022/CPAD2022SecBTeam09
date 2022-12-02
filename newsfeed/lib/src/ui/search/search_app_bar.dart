import 'package:flutter/material.dart';
import 'package:news/src/blocs/connectivity_bloc/connectivity_bloc.dart';
import 'package:news/src/constants/ColorConstants.dart';
import 'package:news/src/extensions/Color.dart';
import 'package:news/src/ui/dialogs/filter_news_dialog.dart';
import 'package:news/src/ui/search/search_news.dart';
import 'package:provider/provider.dart';

class SearchAppBar extends StatefulWidget implements PreferredSizeWidget {
  SearchAppBar(
      this.filter, this.searchNews, this.showFilterButton, this.sortNews,
      [this.appBarTitle]);

  final TextEditingController filter;
  final void Function() searchNews;
  final void Function() sortNews;
  final bool showFilterButton;
  final Widget appBarTitle;

  @override
  _SearchAppBarState createState() => _SearchAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(50);
}

class _SearchAppBarState extends State<SearchAppBar> {
  Icon _searchIcon = Icon(Icons.search);
  Widget _appBarTitle;

  @override
  void initState() {
    _appBarTitle = widget.appBarTitle ?? Text('Flutter News9');
    super.initState();
  }

  @override
  void didUpdateWidget(covariant SearchAppBar oldWidget) {
    _appBarTitle = widget.appBarTitle ?? Text('Flutter News9');
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: _appBarTitle,
      backgroundColor: HexColor.fromHex(ColorConstants.primaryColor),
      actions: <Widget>[
        IconButton(
          icon: _searchIcon,
          color: HexColor.fromHex(ColorConstants.selectedTextColor),
          onPressed: () => _searchPressed(),
        ),
        if (widget.showFilterButton)
          IconButton(
            icon: Icon(Icons.filter_alt),
            onPressed: () async {
              var sortNews = await FilterNewsDialog.showFilterNewsDialog(
                  context, 'recommended');
              if (sortNews) widget.sortNews();
            },
          ),
      ],
    );
  }

  @override
  void didChangeDependencies() {
    var connectionState = Provider.of<ConnectivityStatus>(context);
    if (connectionState == ConnectivityStatus.Offline) {
      this._appBarTitle = Text("Flutter News9 - Offline");
    } else if (connectionState == ConnectivityStatus.Cellular ||
        connectionState == ConnectivityStatus.WiFi) {
      this._appBarTitle = Text("Flutter News9");
    }
    super.didChangeDependencies();
  }

  void _searchPressed() {
    if (this._searchIcon.icon == Icons.search) {
      setState(() {
        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle =
            SearchNews(widget.filter, widget.searchNews, _closeInputField);
      });
    } else {
      _closeInputField();
    }
  }

  void _closeInputField() {
    setState(() {
      this._searchIcon = new Icon(Icons.search);
      this._appBarTitle = new Text('Flutter News9');
      widget.filter.clear();
    });
  }
}
