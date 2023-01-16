// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:convert';

import 'package:beachvolley_flutter/controllers/api_endpoints.dart';
import 'package:beachvolley_flutter/home_widget.dart';
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

  /*Widget _body = SplashScreen(
    seconds: 100,
    title: new Text('', style: TextStyle(
        //fontFamily: "sweetPurple",
        fontSize: 80
    )
    ),
    //image: new Image.asset('images/logo2.png'),
    backgroundColor: Colors.tealAccent.shade400,
    //loaderColor: Colors.white,
    //photoSize: 200,
  )*/

  //String? jwt;
  final Widget _body = LoginScreen();

  //try get matches, if token is still valid go Home, else do Login
  /*var result;
  void tryConnection() async {
    await storage.read(key: "jwt").then((value) async {
      jwt = value;
      Future.delayed(Duration(milliseconds: 2000), () {
        final url = ApiEndpoints.baseUrl + ApiEndpoints.loginEndpoint;
        result = http.get(
            Uri.parse(url),
            headers: {
              "Authorization": jwt.toString()
            }
        );
      });
      var response = json.decode(result.body);
      if(response.statusCode == 200) {
        debugPrint("token still valid, skip authentication");
        Future.delayed(Duration(milliseconds: 2000), () {
          setState(() {
            _body = Home();
          });
        });
      }
      else {
        debugPrint(result.exception.toString());
        Future.delayed(Duration(milliseconds: 2000), () {
          setState(() {
            _body = LoginScreen();
          });
        });
      }
    });
  }*/

  @override
  initState() {
    super.initState();
    //tryConnection();
  }

  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.dark,
            statusBarColor: Colors.transparent,
            systemNavigationBarDividerColor: Colors.tealAccent.shade400,
            systemNavigationBarColor: Colors.tealAccent.shade400,
            systemNavigationBarIconBrightness: Brightness.light
        )
    );

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      title: 'Beach Volley App',
      home: Scaffold (
        appBar: AppBar(
          title: const Text('Beach Volley App'),
        ),
        body: _body,
        )
    );
  }
}