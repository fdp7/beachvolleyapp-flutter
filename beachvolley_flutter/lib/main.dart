// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:convert';

import 'package:beachvolley_flutter/controllers/api_endpoints.dart';
import 'package:beachvolley_flutter/home_widget.dart';
import 'package:beachvolley_flutter/sideBar_widget.dart';
import 'package:beachvolley_flutter/utils/JwtManager.dart';
import 'package:flutter/material.dart';
import 'package:beachvolley_flutter/login_widget.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:beachvolley_flutter/utils/globals.dart' as globals;

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
        final url = ApiEndpoints.baseUrl + globals.selectedSport + ApiEndpoints.getRankingEndpoint;
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
            systemNavigationBarDividerColor: Colors.white,
            systemNavigationBarColor: Colors.white,
            systemNavigationBarIconBrightness: Brightness.light
        )
    );

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Gaoel',
        primarySwatch: const MaterialColor(
            0xffd81159,
            {
              50:Color.fromRGBO(216,17,89, 1),
              100:Color.fromRGBO(216,17,89, 1),
              200:Color.fromRGBO(216,17,89, 1),
              300:Color.fromRGBO(216,17,89, 1),
              400:Color.fromRGBO(216,17,89, 1),
              500:Color.fromRGBO(216,17,89, 1),
              600:Color.fromRGBO(216,17,89, 1),
              700:Color.fromRGBO(216,17,89, 1),
              800:Color.fromRGBO(216,17,89, 1),
              900:Color.fromRGBO(216,17,89, 1),
            }
        ),
        textTheme: const TextTheme(
          headline3: TextStyle(
            fontFamily: 'Gaoel',
            fontSize: 45.0,
            color: Colors.white,
          ),
          button: TextStyle(
            fontFamily: 'Gaoel',
          ),
        ),
      ),
      home: _body,

    );

    /*return MaterialApp(
      home: Scaffold (
        body: _body,
      ),
    );*/
  }
}