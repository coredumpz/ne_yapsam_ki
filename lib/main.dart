import 'package:flutter/material.dart';
import 'package:ne_yapsam_ki/dbHelper/mongodb.dart';
import 'package:ne_yapsam_ki/utils/data_provider.dart';
import 'package:ne_yapsam_ki/utils/wheel_provider.dart';
import 'package:provider/provider.dart';
import 'constants/route_generator.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await MongoDatabase.connect();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => WheelProvider()),
        ChangeNotifierProvider(create: (context) => DataProvider()),
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
