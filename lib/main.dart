import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ne_yapsam_ki/dbHelper/mongodb_user.dart';
import 'package:ne_yapsam_ki/utils/data_provider.dart';
import 'package:ne_yapsam_ki/utils/wheel_provider.dart';
import 'package:provider/provider.dart';

import 'components/snackbar.dart';
import 'constants/route_generator.dart';
import 'dbHelper/mongodb.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await MongoDatabase.connect();
  await MongoDBInsert.connect();
  runApp(MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

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
        scaffoldMessengerKey: Utils.messengerKey,
        navigatorKey: navigatorKey,
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
