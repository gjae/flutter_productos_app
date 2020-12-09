import 'package:flutter/material.dart';
import 'package:formulario_bloc/src/blocs/provider.dart';
import 'package:formulario_bloc/src/pages/home_page.dart';
import 'package:formulario_bloc/src/pages/login_page.dart';
import 'package:formulario_bloc/src/pages/product_page.dart';
import 'package:formulario_bloc/src/pages/registro_page.dart';
import 'package:formulario_bloc/src/preferencias/PreferenciasUsuarios.dart';
 
void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  final prefs = new PreferenciasUsuario();
  await prefs.initPrefs();
  return runApp(MyApp());
}
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Forlumario BLOC',
        initialRoute: 'login',
        routes: {
          'login': (BuildContext context) => LoginPage(),
          'registro': (BuildContext context) => RegistroPage(),
          'home': (BuildContext context) => HomePage(),
          'product': (BuildContext context) => ProductPage()
        },
        theme: ThemeData(
          primaryColor: Colors.deepPurple,
          accentColor: Colors.deepPurple
        ),
      )
    );
  }
}