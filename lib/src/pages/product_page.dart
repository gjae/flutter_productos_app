import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:formulario_bloc/src/models/product_model.dart';
import 'package:formulario_bloc/src/providers/product_provider.dart';

class ProductPage extends StatefulWidget {

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _guardando = false;

  ProductModel _productModel = new ProductModel();
  ProductProvider _productProvider = new ProductProvider();
  final ImagePicker _picker = ImagePicker();
  PickedFile _foto = null;

  @override
  Widget build(BuildContext context) {

    final ProductModel prodData = ModalRoute.of(context).settings.arguments;

    if (prodData != null) {
      _productModel = prodData;
    }

    return Scaffold(
      key: _scaffoldKey, 
      appBar: AppBar(
        title: Text("Detalle de producto"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.photo_size_select_actual ),
            onPressed: ()=> _pickImage(ImageSource.gallery),
          ),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: ()=> _pickImage(ImageSource.camera),
          )
        ],
      ),
    
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                _previewFoto(context),
                _crearNombreProduct(context),
                _crearPrecioProduct(context),
                _crearDisponible(context),
                _buttonSubmit(context)
              ]
            )
          )
        ),
      )
    );
  }

  Widget _crearNombreProduct(BuildContext context) {
    return TextFormField(
      initialValue: this._productModel.titulo,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Nombre del producto',
      ),
      onSaved: (value) => this._productModel.titulo = value,
      validator: (value) {
        if (value.isEmpty) {
          return "El nombre del producto debe ser completado";
        } else if (value.length < 3) {
          return "El nombre del producto debe contener al menos 3 caracteres";
        } 

        return null;
      },
    );
  }

  Widget _crearPrecioProduct(BuildContext context) {
    return TextFormField(
      initialValue: this._productModel.valor.toString(),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: 'Precio del producto'
      ),
      onSaved: (value) => this._productModel.valor = double.parse(value),
      validator: (value) {
        if (value.isEmpty) {
          return "El producto debe tener un precio";
        }

        dynamic canCastToNumber = num.tryParse(value);

        if (canCastToNumber == null) {
          return "El valor del producto debe ser un número (puede contener decimales)";
        }

        return null;
      },
    );
  }

  Widget _crearDisponible(BuildContext context) {
    return SwitchListTile(
      value: _productModel.disponible,
      title: Text("¿Disponible?"),
      onChanged: (value) => setState((){
        _productModel.disponible = value;
      })
    );
  }

  Widget _buttonSubmit(BuildContext context) {
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40.0)
      ),
      icon: Icon(Icons.save),
      label: Text("Guardar"),
      onPressed: _guardando ? null :()=>_submit(context),
      color: _guardando ? Colors.grey : Theme.of(context).accentColor,
      textColor: Colors.white,
    );
  }

  _submit(BuildContext context) async{
    if (!_formKey.currentState.validate()) return;

    _formKey.currentState.save();

    setState((){ 
      _guardando = true;
    });

    if (_foto != null) {
      _productModel.fotoUrl = await _productProvider.subirImagen( 
        new File(_foto.path)
      );
    }

    if (_productModel.id == null) {
      _productProvider.createProduct(_productModel);
      _mostrarSnackbar("Producto creado correctamente");
    } else {
      _productProvider.editarProducto(_productModel);
      _mostrarSnackbar("Producto editado correctamente");
    }

    setState((){
      _guardando = false;
      _foto = null;
    });

    Navigator.pushReplacementNamed(context, 'home');
  }

  void _mostrarSnackbar(String mensaje) {
    final snackbar = SnackBar(
      content: Text(mensaje),
      duration: Duration(milliseconds: 1500)
    );

    _scaffoldKey.currentState.showSnackBar(snackbar);
  }

  _pickImage(ImageSource source) async {
    _foto = await _picker.getImage(source: source);
    setState((){});

  }

  Widget _getImage(ImageProvider<Object> provider) {
    return FadeInImage(
      placeholder: AssetImage('assets/images/jar-loading.gif'), 
      image: provider,
      height: 300,
      fit: BoxFit.cover
    );
  }

  Widget _previewFoto(BuildContext context) {
    if (_productModel.fotoUrl != null && _productModel.fotoUrl.isNotEmpty && _foto == null) {
      return _getImage( NetworkImage(_productModel.fotoUrl) );
    } else {
      return _getImage(AssetImage( _foto?.path ?? 'assets/images/no-image.png'));
    }
  }
}