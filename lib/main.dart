import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:student_record/screens/screensplash.dart';
import 'database/model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(StudentModelAdapter().typeId)) {
    Hive.registerAdapter(StudentModelAdapter());
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student-Record',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Splashscreen(),
    );
  }
}

