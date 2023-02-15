import 'dart:convert';
import 'package:beachvolley_flutter/controllers/api_endpoints.dart';
import 'package:beachvolley_flutter/home_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatelessWidget {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  LoginScreen({super.key});
  Duration get loginTime => const Duration(milliseconds: 1000);
  final storage = const FlutterSecureStorage();

  Future<String?> _login(LoginData data){
    return Future.delayed(loginTime).then((_) async {
      final url = ApiEndpoints.baseUrl + ApiEndpoints.loginEndpoint;
      var result = await http.post(
          Uri.parse(url),
          body: jsonEncode({
            "name": data.name.trim(),
            "password": data.password
          })
      );
      var loginArr = json.decode(result.body);
      if (result.statusCode == 200){
        var jwt = loginArr['token'];
        debugPrint(jwt);
        await storage.write(key: "jwt", value: jwt);
        await storage.write(key: "name", value: data.name);
        return null;
      }
      return "Username or Password are wrong. Please retry.";
    });
  }

  Future<String?> _signup(SignupData data) {
    return Future.delayed(loginTime).then((_) async {
      final url = ApiEndpoints.baseUrl + ApiEndpoints.registerPlayerEndpoint;
      var result = await http.post(
          Uri.parse(url),
          body: jsonEncode({
            "name": data.name,
            "password": data.password
          })
      );
      var loginArr = json.decode(result.body);
      debugPrint(loginArr.toString());
      if (result.statusCode == 201){
        return _login(LoginData(
            name: (data.name).toString(),
            password: (data.password).toString()
        ));
      }
      return "Sign Up failed\n Another user with same name already exists.";
    });
  }

  @override
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

    return FlutterLogin(
      title: 'Friends & Foes',
      theme: LoginTheme(
        titleStyle: const TextStyle(
          fontFamily: "CoreSans",
          fontSize: 30,
          color: Colors.white
        ),
        pageColorDark: const Color(0xff006ba6),
        pageColorLight: const Color(0xffd81159),
        //primaryColor: const Color(0xffd81159),
        accentColor: const Color(0xffd81159),
        //primaryColorAsInputLabel: true,
        errorColor: const Color(0xffd81159),
        cardTheme: CardTheme(
          color: Colors.white,
          elevation: 5,
          margin: const EdgeInsets.only(top: 15),
          shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(100.0)
          ),
        ),
      ),
      // logo: 'images/logo.jpg',
      onLogin: _login,
      onSignup: _signup,
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const Home(),
        ));
      },
      userValidator: (_) => null,
      onRecoverPassword: (_) => null,
      passwordValidator: (_) => null,
      messages: LoginMessages(
        userHint: 'Username',
        passwordHint: 'Password',
        confirmPasswordHint: 'Confirm Password',
        loginButton: 'LOGIN',
        signupButton: 'SIGN UP',
        forgotPasswordButton: 'Forgot password',
        recoverPasswordButton: 'Recover Password',
        goBackButton: 'BACK',
        confirmPasswordError: 'Confirm Password does not match Password',
        recoverPasswordDescription: 'Password Recovery service is not available yet',
        recoverPasswordSuccess: 'Your request have been ignored, please contact Dippi',
      ),
    );
  }
}
