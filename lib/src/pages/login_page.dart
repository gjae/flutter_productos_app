import 'package:flutter/material.dart';
import 'package:formulario_bloc/src/blocs/provider.dart';
import 'package:formulario_bloc/src/providers/usuario_provider.dart';


class LoginPage extends StatelessWidget {

  final UsuarioProvider usuarioProvider = new UsuarioProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _crearFondo(context),
          _loginForm(context),
        ],
      )
    );
  }

  Widget _loginForm(BuildContext context) {

    final size = MediaQuery.of(context).size;
    final bloc = Provider.of(context);
    
    return SingleChildScrollView(
      child: Column(
        children: [

          SafeArea(
            child: Container(
              height: 190.0
            )
          ),

          Container(
            width: size.width * 0.85,
            margin: EdgeInsets.symmetric(vertical: 30.0),
            padding: EdgeInsets.symmetric(vertical: 50.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              color: Colors.white,
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 3.0,
                  offset: Offset(0.0, 1.4),
                  spreadRadius: 3.0
                )
              ]
            ),
            child: Column(
              children: [
                Text('Ingresar', style: TextStyle(fontSize: 20.0)),
                SizedBox(height: 50.0),
                _crearEmail(context, bloc: bloc),
                SizedBox(height: 20.0),
                _crearPassword(context, bloc),
                SizedBox(height: 20.0),
                _crearBotonIngresar(context, bloc),
              ]
            )
          ),
          SizedBox(height: 32),
          FlatButton(
            child: Text("Registrarme", style: TextStyle(fontSize: 15.0, color: Colors.deepPurple)),
            onPressed: () => Navigator.pushReplacementNamed(context, 'registro'),
          ),
          SizedBox(height: 100),
        ]
      )
    );
  }

  Widget _crearBotonIngresar(BuildContext context, LoginBloc bloc) {

    return StreamBuilder(
      stream: bloc.formIsValid,
      builder: (context, snapshot) {
          return RaisedButton(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 80.0),
              child: Text('Ingresar')
            ),
            onPressed: snapshot.hasError || !snapshot.hasData ? null : (){
              _login(bloc, context);
            },
            color: Colors.deepPurple,
            textColor: Colors.white,
            elevation: 0.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0)
            ),
          );
      }
    );
  }

  void _login(LoginBloc bloc, BuildContext context) async {

    //
    final resp = await usuarioProvider.login(bloc.email, bloc.password);
    if (resp['ok']) {
       Navigator.pushNamed(context, 'home');
    } else {
      mostrarAlerta(context);
    }
  }

  Widget _crearEmail(BuildContext context, {LoginBloc bloc}) {

    return StreamBuilder(
      stream: bloc.onEmailChange,
      builder: (context,  snapshot) {
        return  Container(
          padding: EdgeInsets.symmetric(horizontal: 30.0),
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            onChanged: bloc.emailStream,
            decoration: InputDecoration(
              icon: Icon(Icons.alternate_email, color: Colors.deepPurple),
              labelText: 'Correo eléctronico',
              hintText: 'Ingrese su correo eléctronico',
              counterText: snapshot.data,
              errorText: snapshot.error
            )
          )
        );
      },
    );


  }



  Widget _crearPassword(BuildContext context, LoginBloc bloc) {

    return StreamBuilder(
      stream: bloc.onPasswordChange,
      builder: (context, snapshot) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            child: TextField(
              obscureText: true,
              onChanged: bloc.passwordStream,
              decoration: InputDecoration(
                icon: Icon(Icons.lock_outline, color: Colors.deepPurple),
                labelText: 'Contraseña',
                counterText: snapshot.hasData ? snapshot.data.length.toString() : 0.toString(),
                errorText: snapshot.error
              )
            )
          );
      },
    );  

  }

  Widget _crearFondo(BuildContext context) {

    final size = MediaQuery.of(context).size;

    final fondo = Container(
      height: size.height * 0.4,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[
            Color.fromRGBO(58, 52, 144, 1.0),
            Color.fromRGBO(79, 57, 166, 1.0)
          ]
        )
      ),
    );

    final circulo = Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.0),
        color: Color.fromRGBO(255, 255, 255, 0.05)
      ),
    );

    return Stack(
      children: [
        fondo,
        Positioned(child: circulo, top: 90.0, left: 30.0),
        Positioned(child: circulo, top: -40.0, left: -30.0),
        Positioned(child: circulo, bottom: -50.0, right: -10.0),
        Positioned(child: circulo, bottom: -120.0, right: 20.0),
        Positioned(child: circulo, bottom: -50.0, left: -20.0),

        Container(
          padding: EdgeInsets.only(top: 80.0),
          child: Column(
            children:[
              Icon(Icons.person_pin_circle, size: 100, color: Colors.white),
              SizedBox(height: 10.0, width: double.infinity),
              Text("Giovanny Avila", style: TextStyle(color: Colors.white, fontSize: 20.0))
            ]
          )
        )
      ]
    );
  }

  mostrarAlerta(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Información importante'),
        content: Text('Error al momento de iniciar sesión'),
        actions: [
          FlatButton(
            child: Text("Aceptar"),
            onPressed: () => Navigator.of(context).pop()
          )
        ],
      )
    );
  }
}