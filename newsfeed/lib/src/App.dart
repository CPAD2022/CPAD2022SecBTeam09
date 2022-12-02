import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:newsfeed/src/resources/user_repository.dart';
import 'package:newsfeed/src/ui/login/login_page.dart';
import 'package:newsfeed/src/ui/navigation_screen.dart';
import 'package:newsfeed/src/ui/splash_page.dart';
import 'package:newsfeed/src/ui/topic_select_screen.dart';
import 'package:newsfeed/src/utils/app_localizations.dart';
import 'package:provider/provider.dart';
import 'blocs/authentication_bloc/authentication_bloc.dart';
import 'blocs/change_theme_bloc/change_theme_bloc.dart';
import 'blocs/connectivity_bloc/connectivity_bloc.dart';
import 'blocs/language_bloc/language_bloc.dart';
import 'ui/login/login_page.dart';
import 'utils/shared_preferences_topic_select_service.dart';



class App extends StatelessWidget {
  final AuthenticationRepository authenticationRepository =
  AuthenticationRepository();

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: authenticationRepository,
      child: BlocProvider(
        create: (_) => AuthenticationBloc(
          authenticationRepository: authenticationRepository,
        ),
        child: AppView(),
      ),
    );
  }
}

class AppView extends StatefulWidget {
  @override
  _AppViewState createState() => _AppViewState();
}

class AppView extends StatefulWidget {
  @override
  _AppViewState createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState;

  @override
  Widget build(BuildContext context) {
    return StreamProvider<ConnectivityStatus>(
      initialData: null,
      create: (context) => ConnectivityBloc().connectionStatusController.stream,
      child: BlocProvider(
        create: (context) => ChangeThemeBloc()..onDecideThemeChange(),
        child: BlocBuilder<ChangeThemeBloc, ChangeThemeState>(
          builder: (context, themeState) {
            return BlocBuilder<LanguageBloc, LanguageState>(
              builder: (context, languageState) {
                return FlavorBanner(
                  child: MaterialApp(
                    debugShowCheckedModeBanner: false,
                    locale: languageState.locale,
                    localizationsDelegates: [
                      GlobalMaterialLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                      AppLocalizations.delegate,
                      GlobalCupertinoLocalizations.delegate,
                    ],
                    supportedLocales: [
                      Locale('en', 'US'),
                      Locale('de', 'DE'),
                      Locale('es', 'ES'),
                      Locale('fr', 'FR'),
                      Locale('it', 'IT'),
                      Locale('nl', 'NL'),
                      Locale('no', 'NO'),
                      Locale('pt', 'PT'),
                      Locale('ru', 'RU'),
                      Locale('zh', 'CN'),
                      Locale('sr', 'SR'),
                    ],
                    theme: themeState.themeData,
                    navigatorKey: _navigatorKey,
                    builder: (context, child) {
                      return BlocListener<AuthenticationBloc,
                          AuthenticationState>(
                        listener: (context, state) async {
                          switch (state.status) {
                            case AuthenticationStatus.authenticated:
                              final sharedPrefService =
                              await SharedPreferencesTopicSelectService
                                  .instance;

                              sharedPrefService.isFirstTime()
                                  ? _navigator.pushAndRemoveUntil<void>(
                                TopicSelectScreen.route(),
                                    (route) => false,
                              )
                                  : _navigator.pushAndRemoveUntil<void>(
                                NavigationScreen.route(),
                                    (route) => false,
                              );
                              break;
                            case AuthenticationStatus.unauthenticated:
                              _navigator.pushAndRemoveUntil<void>(
                                LoginPage.route(),
                                    (route) => false,
                              );
                              break;
                            default:
                              break;
                          }
                        },
                        child: child,
                      );
                    },
                    onGenerateRoute: (_) => SplashPage.route(),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
