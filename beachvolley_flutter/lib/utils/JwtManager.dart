import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class JwtManager {

  String? jwt;
  String? name;
  var storage = const FlutterSecureStorage();

  init() {
    Future.delayed(const Duration(milliseconds: 500)).then((_) async {
      storage.read(key: "jwt").then((value) => {jwt = value});
      storage.read(key: "name").then((value) => {name = value});
    });
  }

  String getCurrentUserJwt() {
    return jwt.toString();
  }

  String getCurrentUser() {
    return name.toString();
  }
}