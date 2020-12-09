import 'dart:convert';
import 'dart:io';
import 'package:formulario_bloc/src/preferencias/PreferenciasUsuarios.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime_type/mime_type.dart';
import 'package:formulario_bloc/src/models/product_model.dart';

class ProductProvider {
  final String _url = 'https://flutter-cursos-varios-default-rtdb.firebaseio.com';
  final PreferenciasUsuario _prefs = new PreferenciasUsuario();


  Future<ProductModel> createProduct(ProductModel product) async {
    final url = '$_url/productos.json?auth=${_prefs.token}';
    final resp = await http.post(url, body: productModelToJson(product));
    return productModelFromJson(resp.body);
  }



  Future<List<ProductModel>> cargarProductos() async {
    final String url = '$_url/productos.json';
    final List<ProductModel> products = [];
    
    final resp = await http.get(url);

    final Map<String, dynamic> responseData = json.decode(resp.body);

    if (responseData == null) return products;

    responseData.forEach((id, prod) {
      prod['id'] = id; 
      products.add( ProductModel.fromJson(prod) );
    });

    return products;
  }

  Future<bool> borrarProducto(id) async {
    final url = '$_url/productos/$id.json';

    final resp = await http.delete(url);
    
    final respData = json.decode(resp.body);

    return respData == null;
  }

  Future<ProductModel> editarProducto(ProductModel product) async {
    final url = '$_url/productos/${product.id}.json';

    final resp = await http.put(url, body: productModelToJson(product));
    final respData = json.decode(resp.body);

    print(respData);
    return product;
  }

  Future<String> subirImagen(File imagen) async {
    final uri = Uri.parse('https://api.cloudinary.com/v1_1/djuhpjvuy/image/upload?upload_preset=kzflvbgb');
    final mimeType = mime(imagen.path).split("/");
    final imageRequest = http.MultipartRequest('POST', uri);
    final file = await http.MultipartFile.fromPath(
      'file',
      imagen.path,
      contentType: MediaType(mimeType[0], mimeType[1])
    );

    imageRequest.files.add(file);
    final streamResponse = await imageRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      print("Algo salio mal al cargar el archivo solicitado");
    }

    final responseData = json.decode(resp.body);

    return responseData['secure_url'];
  }
}