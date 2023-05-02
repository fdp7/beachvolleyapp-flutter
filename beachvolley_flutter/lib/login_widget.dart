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
            "name": data.name,
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
      final url = ApiEndpoints.baseUrl + ApiEndpoints.registerUserEndpoint;
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
            systemNavigationBarDividerColor: Color(0xffd81159),
            systemNavigationBarColor: Color(0xffd81159),
            systemNavigationBarIconBrightness: Brightness.light
        )
    );

    return FlutterLogin(
      title: 'Friends & Foes',
      theme: LoginTheme(
        titleStyle: const TextStyle(
          fontFamily: "Gaoel",
          fontSize: 30,
          color: Colors.white
        ),
        errorColor: const Color(0xffd81159),
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
        loginButton: 'Login',
        signupButton: 'Sign Up',
        forgotPasswordButton: 'Forgot password',
        recoverPasswordButton: 'Recover Password',
        goBackButton: 'Back',
        confirmPasswordError: 'Confirm Password does not match Password',
        recoverPasswordDescription: 'Password Recovery service is not available yet',
        recoverPasswordSuccess: 'Your request have been ignored, please contact Dippi',
      ),
    );
  }
}
