import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './core/services/notifiers.dart';
import 'screens/login.dart';
import 'screens/PostJobPage.dart';

void main() {
  runApp(MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => JobService())],
      child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hit 400 Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
      routes: {'/postJob': (context) => PostJobPage()},
      debugShowCheckedModeBanner: false,
    );
  }
}
