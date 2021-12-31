import 'package:flutter/material.dart';
import 'package:ne_yapsam_ki/utils/provider.dart';
import 'package:provider/provider.dart';
import 'constants/route_generator.dart';

void main(List<String> args) {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => WheelProvider()),
      ],
      child: MaterialApp(
        title: "HomePage",
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: "/landing",
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }
}
