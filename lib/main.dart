import 'package:flutter/material.dart';
import 'package:sgadmin/presentation/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:sgadmin/presentation/theme/app_theme.dart';
import 'package:sgadmin/presentation/pages/splash.dart';
import 'package:sgadmin/presentation/screens/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SG',
      initialRoute: AppRoutes.splash, // Define the initial route
      onGenerateRoute: AppRoutes.generateRoute, // Set the route generator
      // // Add theme and other configurations as needed
      theme: appTheme,
      home: Splash(),
    );
  }
}
