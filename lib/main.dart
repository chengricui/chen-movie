import 'package:bloc/bloc.dart';
import 'package:chen_movie/src/resources/user_repository.dart';
import 'package:flutter/material.dart';
import 'src/app.dart';


class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onTransition(Transition transition) {
    print(transition);
  }

  @override
  void onError(Object error, StackTrace stacktrace) {
    print(error);
  }
}


void main() {
  BlocSupervisor().delegate = SimpleBlocDelegate();
  runApp(App(userRepository: UserRepository()));
}

// try to update code.