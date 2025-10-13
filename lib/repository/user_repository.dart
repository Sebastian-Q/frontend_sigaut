import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:frontend/model/user_model.dart';
import 'package:frontend/utils/urls.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class UserRepository {
  Future<UserModel> getLocalUser() async {
    UserModel user = UserModel();
    final prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString('user'); // Leer el JSON
    if (userJson != null) {
      user = UserModel.fromJson(json.decode(userJson));
    }
    return user;
  }

  void saveLocalUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', json.encode(user.toMap()));
  }

  void deleteLocalUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
  }

  Future<String> login({required String username, required String password}) async {
    final url = Uri.parse('$urlBack/auth/login',);
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        UserModel userModel = UserModel.fromJson(responseData);
        saveLocalUser(userModel);
        return "Exito";
      } else {
        return "Usuario o contraseña incorrectos";
      }
    } catch (error) {
      return "$error";
    }
  }

  Future<bool> saveUser({required UserModel user}) async {
    final url = Uri.parse('$urlBack/users');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(user.toSave()),
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

  Future<bool> editUser({required UserModel user}) async {
    final url = Uri.parse('$urlBack/user/${user.id}');
    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(user.toMap()),
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