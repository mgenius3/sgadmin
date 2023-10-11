import 'package:flutter/material.dart';
import 'package:sgadmin/presentation/pages/splash.dart';
import 'package:sgadmin/presentation/pages/auth/sign_in.dart';
import 'package:sgadmin/presentation/pages/chat.dart';
import 'package:sgadmin/presentation/screens/home.dart';

class AppRoutes {
  static const String splash = '/';
  static const String main = '/main';
  static const String onboarding = '/onboarding';
  // static const String signup = '/signup';
  static const String signin = '/signin';

  static const String data = 'data';
  static const String cable = 'cable';
  static const String chart = 'chart';
  static const String home = 'chat';

  static Route<dynamic> generateRoute(RouteSettings routes) {
    switch (routes.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => Splash());
      case signin:
        return MaterialPageRoute(builder: (_) => SignIn());
      case home:
        return MaterialPageRoute(builder: (_) => HomePage());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Error: Route not found!'),
            ),
          ),
        );
    }
  }
}
