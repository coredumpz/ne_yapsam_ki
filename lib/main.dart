import 'package:flutter/material.dart';
import 'constants/route_generator.dart';

void main(List<String> args) {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "HomePage",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: "/landing",
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
