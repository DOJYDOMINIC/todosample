import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/screen.dart';
import 'package:todo/service.dart';
import 'package:todo/shared.dart';

import 'controller.dart';
import 'home.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await UserPreferences.init();
  runApp(
    ChangeNotifierProvider(
      create: (context) => TodoController(TodoApiService()),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: UserPreferences.token.isNotEmpty ? Home() :  Login(),
    );
  }
}

