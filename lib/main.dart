import 'package:final_project/src/landingpage.dart';
import 'package:final_project/src/loginPage.dart';
import 'package:final_project/src/signup.dart';
import 'package:flutter/material.dart';
import 'package:final_project/src/welcomePage.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: 'Home',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        'Home': (context) => WelcomePage(),
        'Login': (context) => LoginPage(),
        'SignUp': (context) => SignUpPage(),
        'landingPage': (context) => landingPage(),
      },
    );
  }
}
