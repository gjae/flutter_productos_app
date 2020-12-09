

import 'dart:async';

class Validators {

  final validateEmail = StreamTransformer<String, String>.fromHandlers(
    handleData: (email, sink) {

      Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regex = new RegExp(pattern);

      if (regex.hasMatch(email)) {
        sink.add(email);
      } else {
        sink.addError("El formato del email es invalido");
      }

    }
  );


  final validatePassword = StreamTransformer<String, String>.fromHandlers(
    handleData: (password, sink) {

      if (password.length >= 6) {
        sink.add(password);
      } else {
        sink.addError("La contraseña debe ser de minimo 6 caracteres");
      }
 
    }
  );
}