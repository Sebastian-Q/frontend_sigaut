import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:frontend/model/product_model.dart';
import 'package:frontend/model/sale_model.dart';
import 'package:frontend/utils/urls.dart';
import 'package:http/http.dart' as http;

class SaleRepository {
  static SaleRepository? _instance;

  factory SaleRepository() => _instance ??= SaleRepository._();

  SaleRepository._();

  Future<List<SaleModel>> getSales({String? startDate, String? endDate}) async {
    List<SaleModel> listSales = [];
    final url = Uri.parse(startDate != null && endDate != null ? '$urlBack/sales?startDate=$startDate&endDate=$endDate' : '$urlBack/sales');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        debugPrint("RESPONSE: ${response.body}");
        final List<dynamic> data = json.decode(response.body);
        listSales = data.map((item) => SaleModel.fromJson(item)).toList();
      }
    } catch (error) {
      debugPrint("ERROR: $error");
    }
    return listSales;
  }

  Future<bool> createSale({required SaleModel saleModel}) async {
    final url = Uri.parse('$urlBack/sale/save');
    try {
      final response = await  http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(saleModel.toMap()),
      );
      if(response.statusCode == 201) {
        return true;
      }
    } catch (e) {
      debugPrint("ERROR: $e");
    }
    return false;
  }

  Future<ProductModel> addProduct({required String codeBar}) async {
    ProductModel productModel = ProductModel();
    final url = Uri.parse('$urlBack/product/$codeBar');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        productModel = ProductModel.fromJson(responseData);
      } else {
        debugPrint('Error: ${response.statusCode}');
      }
    } catch (error) {
      debugPrint("ERROR: $error");
    }
    return productModel;
  }
}