import 'package:flutter/material.dart';
import 'package:formulario_bloc/src/blocs/login_bloc.dart';

export 'package:formulario_bloc/src/blocs/login_bloc.dart';


class Provider extends InheritedWidget {

  final LoginBloc loginBloc = LoginBloc();

  Provider({
      Key key, 
      Widget child
  }) : super(key: key, child: child);
    

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;

  static LoginBloc of(BuildContext context) {

    return context
      .dependOnInheritedWidgetOfExactType<Provider>()
      .loginBloc;
  }

}