import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_2048/game/cubit.dart';
import 'package:flutter_2048/game/game.dart';
import 'package:flutter_2048/game/state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
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
            child: const Game(),
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
      cubit.state.cubes.firstWhere((element) => element.position == 0).value,
      4,
    );
    expect(
      cubit.state.cubes.firstWhere((element) => element.position == 4).value,
      1,
    );
    expect(
      cubit.state.cubes.firstWhere((element) => element.position == 5).value,
      2,
    );
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
            child: const Game(),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pump(const Duration(seconds: 1));
    print(cubit.state.cubes.join("\n"));
    expect(
      cubit.state.cubes.length,
      6,
    );
    expect(
      cubit.state.cubes.firstWhere((element) => element.position == 3).value,
      4,
    );
    expect(
      cubit.state.cubes.firstWhere((element) => element.position == 7).value,
      2,
    );
    expect(
      cubit.state.cubes.firstWhere((element) => element.position == 6).value,
      1,
    );
    expect(
      cubit.state.cubes.firstWhere((element) => element.position == 11).value,
      4,
    );
    expect(
      cubit.state.cubes.firstWhere((element) => element.position == 10).value,
      2,
    );
  });
}
