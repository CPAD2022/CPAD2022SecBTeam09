import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:news/src/constants/ColorConstants.dart';
import 'package:news/src/extensions/Color.dart';
import 'package:news/src/models/article/article_model.dart';
import 'article_details.dart';

class MostPopularNews extends StatelessWidget {
  MostPopularNews(this.articles);

  final List<Article> articles;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(4),
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: articles.length,
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemBuilder: (context, index) {
            return NewsTile(article: articles[index]);
          }),
    );
  }
}

class NewsTile extends StatefulWidget {
  NewsTile({this.article});

  final Article article;

  @override
  _NewsTileState createState() => _NewsTileState();
}

class _NewsTileState extends State<NewsTile> {
  bool isArticleFavorite;
  String _placeholderImageUrl =
      'https://iitpkd.ac.in/sites/default/files/default_images/default-news-image_0.png';

  @override
  void initState() {
    this.isArticleFavorite = widget.article.isFavorite ?? false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ArticleDetails(
                article: widget.article,
                isFavorite: isArticleFavorite,
                isParentFavoriteScreen: false,
                callback: (value) {
                  setState(() {
                    isArticleFavorite = value;
                  });
                }),
          ));
        },
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: ConstrainedBox(
            constraints: new BoxConstraints(
              minWidth: MediaQuery.of(context).size.width / 2,
            ),
            child: Card(
              child: Row(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.network(
                        widget.article.urlToImage ?? _placeholderImageUrl,
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width / 2,
                        fit: BoxFit.cover,
                        errorBuilder: (BuildContext context, Object exception,
                            StackTrace stackTrace) {
                          return Image.asset('assets/placeholder.png');
                        },
                      ),
                      ClipRRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                          child: Container(
                            color: Colors.grey.withOpacity(0.2),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Container(
                                      width:
                                          MediaQuery.of(context).size.width / 2,
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        widget.article.title,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      width:
                                          MediaQuery.of(context).size.width / 2,
                                      padding: EdgeInsets.all(8.0),
                                      child: widget.article.description != null
                                          ? Text(
                                              widget.article.description
                                                      .substring(
                                                          0,
                                                          (widget
                                                                  .article
                                                                  .description
                                                                  .length ~/
                                                              3)) +
                                                  "...",
                                              style: TextStyle(
                                                color: HexColor.fromHex(
                                                    ColorConstants
                                                        .secondaryColor),
                                                fontWeight: FontWeight.w900,
                                              ),
                                              overflow: TextOverflow.fade,
                                            )
                                          : Container(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
