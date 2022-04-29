import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_2048/game/game.dart';
import 'package:flutter_2048/game/state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GameCubit extends Cubit<GameState> {
  bool cantMove = false;

  GameCubit() : super(GameState([]));

  startGame() {
    emit(GameState.generateInitPosition());
  }

  test() {
    _updateCubes([
      Cube(0, 1, 0, false),
      Cube(1, 1, 0, false),
      Cube(2, 2, 0, false),
    ]);
  }

  _updateCubes(List<Cube> cubes) {
    if (const ListEquality().equals(cubes, state.cubes)) {
      return;
    }
    cantMove = true;
    var safeCubes = cubes;
    final safeState = state;
    emit(GameState(safeCubes));
    Future.delayed(const Duration(milliseconds: 10), () {
      safeCubes = cubes
          .map((e) =>
              safeState.cubes.where((element) => element.id == e.id).isEmpty
                  ? e.copyWith(visible: true)
                  : e)
          .toList();
      emit(GameState(safeCubes));
    });
    Future.delayed(Game.animationDuration, () {
      final newCubes = safeCubes.where((element) => element.visible).toList();
      final toAdd = _generationCubes(newCubes);
      if (toAdd != null) {
        newCubes.add(toAdd);
      }
      emit(GameState(newCubes));
      cantMove = false;
    });
  }

  Cube? _generationCubes(List<Cube> cubes) {
    final position = (List.generate(16, (index) => index)
            .where((element) =>
                cubes.where((cube) => cube.position == element).isEmpty)
            .toList()
          ..shuffle())
        .firstOrNull;
    return (position != null
        ? Cube(
            cubes.sorted((a, b) => a.id - b.id).last.id +
                Random().nextInt(100) +
                1,
            (Random().nextInt(2) % 2 + 1) * 2,
            position,
            true)
        : null);
  }

  moveUp() {
    print("moveUp");
    if (cantMove) {
      return;
    }
    var cubes = state.cubes;
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 3; j++) {
        for (int k = j; k >= 0; k--) {
          final newCubes =
              compareCubes(cubes, k * 4 + i, k * 4 + 4 + i, k * 4 + i);
          cubes = cubes
              .where((first) =>
                  newCubes.where((second) => second.id == first.id).isEmpty)
              .toList()
            ..addAll(newCubes);
        }
      }
    }
    _updateCubes(cubes);
  }

  moveDown() {
    print("moveDown");
    if (cantMove) {
      return;
    }
    var cubes = state.cubes;
    for (int i = 0; i < 4; i++) {
      for (int j = 2; j > -1; j--) {
        for (int k = 0; k <= j; k++) {
          final newCubes =
              compareCubes(cubes, k * 4 + i, k * 4 + 4 + i, k * 4 + 4 + i);
          cubes = cubes
              .where((first) =>
                  newCubes.where((second) => second.id == first.id).isEmpty)
              .toList()
            ..addAll(newCubes);
        }
      }
    }
    _updateCubes(cubes);
  }

  moveRight() {
    print("moveRight");
    if (cantMove) {
      return;
    }
    var cubes = state.cubes;
    for (int i = 0; i < 4; i++) {
      for (int j = 2; j > -1; j--) {
        for (int k = 0; k <= j; k++) {
          final newCubes =
              compareCubes(cubes, i * 4 + k, i * 4 + k + 1, i * 4 + k + 1);
          cubes = cubes
              .where((first) =>
                  newCubes.where((second) => second.id == first.id).isEmpty)
              .toList()
            ..addAll(newCubes);
        }
      }
    }
    _updateCubes(cubes);
  }

  moveLeft() {
    print("moveLeft");
    if (cantMove) {
      return;
    }
    var cubes = state.cubes;
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 3; j++) {
        for (int k = j; k >= 0; k--) {
          final newCubes =
              compareCubes(cubes, i * 4 + k, i * 4 + k + 1, i * 4 + k);
          cubes = cubes
              .where((first) =>
                  newCubes.where((second) => second.id == first.id).isEmpty)
              .toList()
            ..addAll(newCubes);
        }
      }
    }
    _updateCubes(cubes);
  }

  @visibleForTesting
  List<Cube> compareCubes(
    List<Cube> cubes,
    int positionFirst,
    int positionSecond,
    int goalPosition,
  ) {
    final firstCube = cubes
        .sorted((a, b) => (a.visible ? 1 : 0) - (b.visible ? 1 : 0))
        .firstWhereOrNull((element) => element.position == positionFirst);
    final secondCube = cubes
        .sorted((a, b) => (a.visible ? 1 : 0) - (b.visible ? 1 : 0))
        .firstWhereOrNull((element) => element.position == positionSecond);

    if (firstCube == null && secondCube == null) {
      return [];
    }

    if (firstCube == null && secondCube != null) {
      if (goalPosition == positionFirst) {
        return [secondCube.copyWith(position: goalPosition)];
      } else {
        return [secondCube];
      }
    }

    if (secondCube == null && firstCube != null) {
      if (goalPosition == positionSecond) {
        return [firstCube.copyWith(position: goalPosition)];
      } else {
        return [firstCube];
      }
    }

    if (firstCube!.value == secondCube!.value &&
        firstCube.visible &&
        secondCube.visible) {
      final newId = cubes.sorted((a, b) => a.id - b.id).last.id + 1;
      return [
        Cube(newId, firstCube.value * 2, goalPosition, false),
        firstCube.copyWith(
          position: goalPosition,
          visible: false,
        ),
        secondCube.copyWith(
          position: goalPosition,
          visible: false,
        )
      ];
    } else {
      return [firstCube, secondCube];
    }
  }
}
