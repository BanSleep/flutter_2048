import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_2048/game/cubit.dart';
import 'package:flutter_2048/game/game.dart';
import 'package:flutter_2048/game/state.dart';
import 'package:flutter_2048/main.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_2048/main.dart' as app;

void main() {
  testWidgets('game test', (tester) async {
    final cubit = GameCubit.test(GameState([
      Cube(0, 2, 1, true),
      Cube(1, 2, 3, true),
      Cube(2, 1, 4, true),
      Cube(3, 2, 5, true),
    ], false));
    await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Row(
              children: [
                IconButton(icon: Icon(Icons.arrow_back), onPressed: () {},),
                Expanded(
                  child: Center(
                    child: BlocProvider(
                      create: (context) => cubit,
                      child: Game(score: 1,),
                    ),
                  ),
                ),
              ],
            ), // This trailing comma makes auto-formatting nicer for build methods.
          ),
        )
    );
  });
  testWidgets('move left test', (tester) async {
    final cubit = GameCubit.test(GameState([
      Cube(0, 2, 1, true),
      Cube(1, 2, 3, true),
      Cube(2, 1, 4, true),
      Cube(3, 2, 5, true),
    ], false));
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BlocProvider<GameCubit>.value(
            value: cubit,
            child: Game(score: 1,),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
    await tester.pump(const Duration(seconds: 1));
    expect(
      cubit.state.cubes.length,
      4,
    );
    expect(
      cubit.state.cubes
          .firstWhere((element) => element.position == 0)
          .value,
      4,
    );
    expect(
      cubit.state.cubes
          .firstWhere((element) => element.position == 4)
          .value,
      1,
    );
    expect(
      cubit.state.cubes
          .firstWhere((element) => element.position == 5)
          .value,
      2,
    );
  });

  testWidgets('ui test', (tester) async {

    app.main();
    await tester.pumpAndSettle();
    final cubit = GameCubit.test(GameState([
      Cube(0, 2, 0, true),
      Cube(1, 2, 2, true),
      Cube(2, 1, 4, true),
      Cube(3, 2, 5, true),
      Cube(4, 2, 9, true),
      Cube(5, 2, 10, true),
      Cube(6, 2, 11, true),
    ], false));
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Row(
            children: [
              IconButton(icon: Icon(Icons.arrow_back), onPressed: () {}, key: const Key('onTap'),),
              Expanded(
                child: Center(
                  child: BlocProvider(
                    create: (context) => cubit,
                    child: Game(score: 1,),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pump();

    // await tester.tap(find.text("Start Game"));
    // await tester.pump();
  });

  testWidgets('mainScreen test', (tester) async {
    await tester.pumpWidget(MaterialApp(home: MainScreen(),));
  });

  testWidgets('move right test', (tester) async {
    final cubit = GameCubit.test(GameState([
      Cube(0, 2, 0, true),
      Cube(1, 2, 2, true),
      Cube(2, 1, 4, true),
      Cube(3, 2, 5, true),
      Cube(4, 2, 9, true),
      Cube(5, 2, 10, true),
      Cube(6, 2, 11, true),
    ], false));
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BlocProvider<GameCubit>.value(
            value: cubit,
            child: Game(score: 1,),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pump(const Duration(seconds: 1));
    expect(
      cubit.state.cubes.length,
      6,
    );
    expect(
      cubit.state.cubes
          .firstWhere((element) => element.position == 3)
          .value,
      4,
    );
    expect(
      cubit.state.cubes
          .firstWhere((element) => element.position == 7)
          .value,
      2,
    );
    expect(
      cubit.state.cubes
          .firstWhere((element) => element.position == 6)
          .value,
      1,
    );
    expect(
      cubit.state.cubes
          .firstWhere((element) => element.position == 11)
          .value,
      4,
    );
    expect(
      cubit.state.cubes
          .firstWhere((element) => element.position == 10)
          .value,
      2,
    );
  });

  testWidgets('move up test', (tester) async {
    final cubit = GameCubit.test(GameState([
      Cube(0, 2, 0, true),
      Cube(1, 2, 1, true),
      Cube(2, 1, 2, true),
      Cube(3, 2, 4, true),
    ], false));
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BlocProvider<GameCubit>.value(
            value: cubit,
            child: Game(score: 1,),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
    await tester.pump(const Duration(seconds: 1));
    expect(
      cubit.state.cubes.length,
      4,
    );
    expect(
      cubit.state.cubes
          .firstWhere((element) => element.position == 0)
          .value,
      4,
    );
    expect(
      cubit.state.cubes
          .firstWhere((element) => element.position == 1)
          .value,
      2,
    );
    expect(
      cubit.state.cubes
          .firstWhere((element) => element.position == 2)
          .value,
      1,
    );
  });
  testWidgets('move down test', (tester) async {
    final cubit = GameCubit.test(GameState([
      Cube(0, 2, 0, true),
      Cube(1, 2, 1, true),
      Cube(2, 1, 2, true),
      Cube(3, 2, 4, true),
    ], false));
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BlocProvider<GameCubit>.value(
            value: cubit,
            child: Game(score: 1,),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pump(const Duration(seconds: 1));
    expect(
      cubit.state.cubes.length,
      4,
    );
    expect(
      cubit.state.cubes
          .firstWhere((element) => element.position == 12)
          .value,
      4,
    );
    expect(
      cubit.state.cubes
          .firstWhere((element) => element.position == 13)
          .value,
      2,
    );
    expect(
      cubit.state.cubes
          .firstWhere((element) => element.position == 14)
          .value,
      1,
    );
  });
}
