import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_2048/game/cubit.dart';
import 'package:flutter_2048/game/game.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      title: '2048',
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          RichText(text: TextSpan(
            children: [
              TextSpan(text: '2', style: TextStyle(color: Colors.redAccent, fontSize: 108, fontWeight: FontWeight.w700)),
              TextSpan(text: '0', style: TextStyle(color: Colors.blue, fontSize: 108, fontWeight: FontWeight.w700)),
              TextSpan(text: '4', style: TextStyle(color: Colors.yellow, fontSize: 108, fontWeight: FontWeight.w700)),
              TextSpan(text: '8', style: TextStyle(color: Colors.green, fontSize: 108, fontWeight: FontWeight.w700)),
            ]
          )),
          SizedBox(height: MediaQuery.of(context).size.height/3,),
          Center(
            child: InkWell(
              key: Key('inkWell'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return MyHomePage();
                }));
              },
              child: Container(
                width: 200,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 20.0,
                      spreadRadius: 0.0,
                      offset: Offset(0, 20),
                    )
                  ]
                ),
                child: Center(
                  child: Text('Start Game', style: TextStyle(fontSize: 24, color: Colors.black),),
                ),
              ),
            ),
          ),
          SizedBox(height: 30,),
          Center(
            child: InkWell(
              key: Key('inkWell'),
              onTap: () {
                exit(0);
              },
              child: Container(
                width: 200,
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 20.0,
                        spreadRadius: 0.0,
                        offset: Offset(0, 20),
                      )
                    ]
                ),
                child: Center(
                  child: Text('Exit', style: TextStyle(fontSize: 24, color: Colors.black),),
                ),
              ),
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }
}


class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final cubit = GameCubit()..startGame();
  int score = 0;

  @override
  Widget build(BuildContext context) {
    GetStorage().listenKey('score', (value) {
      setState(() {
        score = value;
      });
    });
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(icon: Icon(Icons.arrow_back), onPressed: () {
            Navigator.pop(context);
          }, key: const Key('onTap'),),
          SizedBox(width: 20,),
          Text('Score: $score', style: TextStyle(fontSize: 24),),
          Expanded(
            child: Center(
              child: BlocProvider(
                create: (context) => cubit,
                child: Game(score: score,),
              ),
            ),
          ),

        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
