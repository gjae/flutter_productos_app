import 'dart:convert';

ProductModel productModelFromJson(String str) => ProductModel.fromJson(json.decode(str));

String productModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {

    String id;
    String titulo;
    double valor;
    String fotoUrl;
    bool disponible;

    ProductModel({
        this.id,
        this.titulo = '',
        this.valor  = 0.0,
        this.fotoUrl = '',
        this.disponible = true,
    });

    factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id          : json["id"],
        titulo      : json["titulo"],
        valor       : json["valor"],
        fotoUrl     : json["fotoUrl"],
        disponible  : json["disponible"],
    );

    Map<String, dynamic> toJson() => {
        // "id"        : id,
        "titulo"    : titulo,
        "valor"     : valor,
        "fotoUrl"   : fotoUrl,
        "disponible": disponible,
    };
}
