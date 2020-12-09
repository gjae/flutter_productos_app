
import 'dart:async';

import 'package:formulario_bloc/src/blocs/validators.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc with Validators{

  final _emailStreamController = BehaviorSubject<String>();
  final _passwordStreamController = BehaviorSubject<String>();

  Function(String) get emailStream => _emailStreamController.sink.add;
  Function(String) get passwordStream => _passwordStreamController.sink.add;

  Stream<String> get onEmailChange => _emailStreamController.stream.transform(validateEmail);
  Stream<String> get onPasswordChange => _passwordStreamController.stream.transform(validatePassword);


  Stream<bool> get formIsValid => Rx.combineLatest2<String, String, bool>(onEmailChange, onPasswordChange, (e, p){
    return true;
  });

  // Retornar los ultimos valores ingresados al stream para emial y password

  String get email => _emailStreamController.value;
  String get password => _passwordStreamController.value;
  

  dispose() {
    _emailStreamController?.close();
    _passwordStreamController?.close();
  }


}