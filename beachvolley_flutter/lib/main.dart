// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:convert';

import 'package:beachvolley_flutter/controllers/api_endpoints.dart';
import 'package:beachvolley_flutter/home_widget.dart';
import 'package:beachvolley_flutter/utils/JwtManager.dart';
import 'package:flutter/material.dart';
import 'package:beachvolley_flutter/login_widget.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(App());
}

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AppState();
  }
}

class _AppState extends State<App>{
  var storage = const FlutterSecureStorage();
  static var jwtManager = JwtManager();

  Widget _body = LoginScreen();
  var result;

  //try get ranking, if token is still valid go Home, else do Login
  void tryConnection() async {
    await storage.read(key: "jwt").then((value) async {
      Future.delayed(const Duration(milliseconds: 2000), () {
        final url = ApiEndpoints.baseUrl + ApiEndpoints.getRankingEndpoint;
        result = http.get(
            Uri.parse(url),
            headers: {
              'Authorization': 'Bearer ${jwtManager.jwt.toString()}'
            }
        );
      });
      var response = json.decode(result.body);
      if(response.statusCode == 200) {
        debugPrint("token still valid, skip authentication");
        Future.delayed(const Duration(milliseconds: 2000), () {
          setState(() {
            _body = const Home();
          });
        });
      }
      else {
        Future.delayed(const Duration(milliseconds: 2000), () {
          setState(() {
            _body = LoginScreen();
          });
        });
      }
    });
  }

  @override
  initState() {
    super.initState();
    jwtManager.init();
    //tryConnection();
  }

  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.dark,
            statusBarColor: Colors.transparent,
            systemNavigationBarDividerColor: Color(0xffd81159),
            systemNavigationBarColor: Color(0xffd81159),
            systemNavigationBarIconBrightness: Brightness.light
        )
    );

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      home: Scaffold (
        body: _body,
        )
    );
  }
}