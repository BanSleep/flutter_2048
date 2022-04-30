import 'package:flutter/material.dart';
import 'package:flutter_2048/game/cubit.dart';
import 'package:flutter_2048/game/game.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: '2048',
      home: MyHomePage(),
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
  final BannerAd myBanner = BannerAd(
    adUnitId: 'ca-app-pub-4069764265251800/7848862363',
    size: AdSize.banner,
    request: const AdRequest(),
    listener: const BannerAdListener(),
  );
  bool adIsLoaded = false;

  @override
  void initState() {
    myBanner.load().then((value) {
      setState(() {
        adIsLoaded = true;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    myBanner.dispose().then((value) {
      setState(() {
        adIsLoaded = false;
      });
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: BlocProvider(
                create: (context) => cubit,
                child: const Game(),
              ),
            ),
          ),
          if (adIsLoaded)
            AdWidget(ad: myBanner),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: cubit.test,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
