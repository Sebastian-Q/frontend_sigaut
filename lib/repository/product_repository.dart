import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:frontend/model/product_model.dart';
import 'package:frontend/utils/urls.dart';
import 'package:http/http.dart' as http;

class ProductRepository {
  static ProductRepository? _instance;

  factory ProductRepository() => _instance ??= ProductRepository._();

  ProductRepository._();

  ///LISTO
  Future<List<ProductModel>> allProducts() async {
    List<ProductModel> listProducts = [];
    final url = Uri.parse('$urlBack/products');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        listProducts = data.map((item) => ProductModel.fromJson(item)).toList();
      }
    } catch (error) {
      debugPrint("ERROR: $error");
    }
    return listProducts;
  }

  ///LISTO
  Future<bool> createProduct({required ProductModel productModel}) async {
    final url = Uri.parse('$urlBack/product/save');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(productModel.toMap()),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        throw Exception(response.body);
      }
    } catch (error) {
      throw Exception(error.toString().split(": ").last);
    }
  }

  ///LISTO
  Future<bool> updateProduct({required ProductModel productModel}) async {
    final url = Uri.parse('$urlBack/product/${productModel.id}');
    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(productModel.toMap()),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception(response.body);
      }
    } catch (error) {
      throw Exception(error.toString().split(": ").last);
    }
  }

  ///LISTO
  Future<bool> deleteProduct(int id) async {
    final url = Uri.parse('$urlBack/product/$id');
    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        return true;
      }
    } catch (error) {
      debugPrint("ERROR: $error");
    }
    return false;
  }
}