import 'package:chen_movie/src/blocs/authentication/authentication.dart';
import 'package:chen_movie/src/common/common.dart';
import 'package:chen_movie/src/resources/user_repository.dart';
import 'package:chen_movie/src/ui/login/login_page.dart';
import 'package:chen_movie/src/ui/splash/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'ui/movie/movie_list.dart';

// class App extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData.dark(),
//       home:Scaffold(
//         body: MovieList(),
//       )
//     );
//   }
// }

class App extends StatefulWidget {

  final UserRepository userRepository;

  App({Key key, @required this.userRepository}) :super(key:key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  AuthenticationBloc _authenticationBloc;
  UserRepository get _userRepository => widget.userRepository;

  @override
  void initState() {
    _authenticationBloc = AuthenticationBloc(userRepository:_userRepository);
    _authenticationBloc.dispatch(AppStarted());
    super.initState();
  }

  @override
  void dispose() {
    _authenticationBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthenticationBloc> (
      bloc: _authenticationBloc,
      child:MaterialApp(
        theme: ThemeData.dark(),
        home: BlocBuilder<AuthenticationEvent, AuthenticationState> (
          bloc: _authenticationBloc,
          builder: (BuildContext context, AuthenticationState state) {
            if (state is AuthenticationUninitialized) {
              return SplashPage();
            }
            if (state is AuthenticationAuthenticated) {
              return MovieList();
            }
            if (state is AuthenticationUnauthenticated) {
              return LoginPage(userRepository:_userRepository);
            }

            if (state is AuthenticationLoading) {
              return LoadingIndicator();
            }
          }
        )
      )
    );
  }
}