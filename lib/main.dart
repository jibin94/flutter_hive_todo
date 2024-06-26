import 'package:flutter/material.dart';
import 'package:flutter_hive_database_demo/model/data_model.dart';
import 'package:flutter_hive_database_demo/pages/splash_screen.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

///flutter clean
///dart run build_runner doctor
///dart run build_runner build --delete-conflicting-outputs

const String dataBoxName = "data";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final document = await getApplicationDocumentsDirectory();
  Hive.init(document.path);
  Hive.registerAdapter(DataModelAdapter());
  await Hive.openBox<DataModel>(dataBoxName);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Splash(),
    );
  }
}
