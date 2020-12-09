import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:formulario_bloc/src/preferencias/PreferenciasUsuarios.dart';

class UsuarioProvider {
  final String _authToken = 'AIzaSyCHHDZQ4aChcLQohK3xNq0rdC12Z3NsxDM';
  final PreferenciasUsuario _prefs = new PreferenciasUsuario();

  Future<Map<String, dynamic>> login(String email, String password) async {
    final data = await _firebasePostRequest(
      'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$_authToken',
      {'email': email, 'password': password}
    );
    
    if (data.containsKey('idToken')) {

      _prefs.token = data['idToken'];
      return {'ok': true, 'token': data['idToken'], 'refreshToken': data['refreshToken']};
    } else {
      return {'ok': false, 'message': data['error']['message'], 'token': null, 'refreshToken': null};
    }
  }

  Future<Map<String, dynamic>> registrarUsuario(String email, String password) async {

    final Map<String, dynamic> data = await _firebasePostRequest(
      'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$_authToken',
      {'email': email, 'password': password, 'returnSecureToken': true}
    );

    if (data.containsKey('idToken')) {

      _prefs.token = data['idToken'];
      return {'ok': true, 'token': data['idToken'], 'refreshToken': data['refreshToken']};
    } else {
      return {'ok': false, 'message': data['error']['message'], 'token': null, 'refreshToken': null};
    }

  }

  Future<Map<String, dynamic>> _firebasePostRequest(String url, Map<String, dynamic> body) async{
    
    final firebaseResp = await http.post(
      url,
      body: json.encode(body)
    );

    return json.decode(firebaseResp.body);
  }
}