import 'package:flutter/material.dart';
import 'package:todo/shared.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Column(
        children: [
          ElevatedButton(onPressed: (){
            UserPreferences.removeToken();
          }, child: Text("clear"))
        ],
      ),
    );
  }
}
