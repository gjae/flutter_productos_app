import 'package:flutter/material.dart';
import 'package:formulario_bloc/src/blocs/provider.dart';
import 'package:formulario_bloc/src/models/product_model.dart';
import 'package:formulario_bloc/src/providers/product_provider.dart';


class HomePage extends StatelessWidget {

  final ProductProvider _productProvider = new ProductProvider();

  @override
  Widget build(BuildContext context) {

    LoginBloc bloc = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Home page")
      ),
      body: Center(
        child: _displayInfo(bloc)
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: ()=> Navigator.pushNamed(context, 'product')
      ),
    );
  }

  Widget _displayInfo(LoginBloc bloc) {

    return FutureBuilder(
      future: _productProvider.cargarProductos(),
      builder: (context, snapshot) {
        print(snapshot.error);
        if (snapshot.hasData) {
          final pModel = snapshot.data;
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, ind) => _productTile(context, pModel[ind])
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _productTile(BuildContext context, ProductModel pModel) {
    return  Dismissible(
      key: UniqueKey(),
      onDismissed: (direction) {
        _productProvider.borrarProducto(pModel.id);
      },
      background: Container(
        color: Colors.blueGrey[200],
      ),
      child: ListTile(
        title: Text('${pModel.titulo} - ${pModel.valor}'),
        subtitle: Text(pModel.id),
        onTap: () => Navigator.pushNamed(context, 'product', arguments: pModel),
      ),
    );
  }
}