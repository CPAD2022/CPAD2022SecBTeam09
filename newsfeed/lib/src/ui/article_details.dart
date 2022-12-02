import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:newsfeed/src/blocs/news_bloc/news_bloc.dart';
import 'package:newsfeed/src/constants/ColorConstants.dart';
import 'package:newsfeed/src/extensions/Color.dart';
import 'package:newsfeed/src/models/article/article_model.dart';
import 'package:newsfeed/src/utils/app_localizations.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
import 'package:jiffy/jiffy.dart';
import 'package:flutter_social_content_share/flutter_social_content_share.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_share/social_share.dart';

class ArticleDetails extends StatefulWidget {
  final Article article;
  final bool isFavorite;
  final bool isParentFavoriteScreen;
  final Function callback;

  ArticleDetails(
      {this.article,
      this.isFavorite,
      @required this.isParentFavoriteScreen,
      this.callback});

  @override
  _ArticleDetailsState createState() => _ArticleDetailsState();
}

class _ArticleDetailsState extends State<ArticleDetails> {
  final String _placeholderImageUrl =
      'https://iitpkd.ac.in/sites/default/files/default_images/default-news-image_0.png';
  Article article;
  bool _isFavorite;

  @override
  void initState() {
    this.article = widget.article;
    this._isFavorite = widget.isFavorite ?? false;
    super.initState();
  }

  formatDate(String date) {
    return Jiffy(date).fromNow();
  }

  _shareFacebook(context, String url) async {
    FlutterSocialContentShare.share(
      type: ShareType.facebookWithoutImage,
      url: url,
      quote: AppLocalizations.of(context).translate('checkout_article'),
    );
  }

  _shareTwitter(context, String url) async {
    SocialShare.shareTwitter(
      AppLocalizations.of(context).translate('checkout_article'),
      url: article.url,
      hashtags: ["levi9", "flutter", "internship", "news9"],
    );
  }

  _shareWhatsapp(context, String url) async {
    SocialShare.shareWhatsapp(
      AppLocalizations.of(context).translate('checkout_article') + ": \n $url",
    );
  }

  _shareEmail(context, String url) async {
    FlutterSocialContentShare.shareOnEmail(
      recipients: [],
      subject: AppLocalizations.of(context).translate('checkout_article'),
      body: url,
      isHTML: true,
    );
  }

  _shareSms(context, String url) async {
    SocialShare.shareSms(
      AppLocalizations.of(context).translate('checkout_article') + ": \n",
      url: url,
      trailingText: '',
    );
  }

  _copyToClipboard(context, String url) async {
    // SocialShare.copyToClipboard(
    //     AppLocalizations.of(context).translate('checkout_article') +
    //         ": \n $url");
  }

  Future<void> _launchInWebViewWithJavaScript(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: true,
        forceWebView: true,
        enableJavaScript: true,
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  _saveArticle() {
    newsBloc.insertNewsByUid("favorite_news", article);
    setState(() {
      _isFavorite = !_isFavorite;
      widget.callback(_isFavorite);
    });
    if (!_isFavorite && widget.isParentFavoriteScreen) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NewsFeed - ' + article.source.name),
        backgroundColor: HexColor.fromHex(ColorConstants.primaryColor),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _saveArticle(),
        child: _isFavorite
            ? Icon(Icons.favorite_rounded)
            : Icon(Icons.favorite_border_rounded),
        backgroundColor: HexColor.fromHex(ColorConstants.primaryColor),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                SizedBox(height: 10),
                Text.rich(
                  TextSpan(children: [
                    TextSpan(
                      text: article.source.name ??
                          AppLocalizations.of(context)
                              .translate('source_not_stated'),
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                    TextSpan(text: ' | '),
                    TextSpan(
                      text:
                          AppLocalizations.of(context).translate('published') +
                              ' ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: formatDate(article.publishedAt))
                  ]),
                ),
                SizedBox(height: 10),
                Text(
                  article.title ??
                      AppLocalizations.of(context).translate('no_title'),
                  style: Theme.of(context).textTheme.headline4,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  article.description ??
                      AppLocalizations.of(context).translate('no_description'),
                  style: Theme.of(context).textTheme.subtitle1,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text.rich(
                  TextSpan(children: [
                    TextSpan(
                      text: AppLocalizations.of(context).translate('by') + ' ',
                    ),
                    TextSpan(
                      text: article.author ??
                          AppLocalizations.of(context)
                              .translate('author_not_stated'),
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                  ]),
                ),
                SizedBox(height: 10),
                if (Theme.of(context).platform != TargetPlatform.macOS &&
                    !kIsWeb)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(FontAwesomeIcons.facebook),
                        onPressed: () => _shareFacebook(context, article.url),
                      ),
                      IconButton(
                        icon: Icon(FontAwesomeIcons.twitter),
                        onPressed: () => _shareTwitter(context, article.url),
                      ),
                      IconButton(
                        icon: Icon(FontAwesomeIcons.whatsapp),
                        onPressed: () => _shareWhatsapp(context, article.url),
                      ),
                      IconButton(
                        icon: Icon(FontAwesomeIcons.sms),
                        onPressed: () => _shareSms(context, article.url),
                      ),
                      IconButton(
                        icon: Icon(FontAwesomeIcons.envelope),
                        onPressed: () => _shareEmail(context, article.url),
                      ),
                      IconButton(
                        icon: Icon(FontAwesomeIcons.clipboard),
                        onPressed: () => _copyToClipboard(context, article.url),
                      ),
                    ],
                  ),
                SizedBox(height: 10),
                CachedNetworkImage(
                  imageUrl: article.urlToImage ?? _placeholderImageUrl,
                  height: MediaQuery.of(context).size.width > 400
                      ? MediaQuery.of(context).size.height / 2
                      : 200,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.contain,
                  errorWidget: (context, url, error) =>
                      Image.asset('assets/placeholder.png'),
                  placeholder: (context, url) =>
                      Image.asset('assets/placeholder.png'),
                ),
                SizedBox(height: 10),
                OutlinedButton(
                  onPressed: () => _launchInWebViewWithJavaScript(article.url),
                  child: Text(
                    AppLocalizations.of(context).translate('whole_article'),
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
