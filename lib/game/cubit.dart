import 'dart:math';
import 'dart:developer' as l;

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_2048/game/game.dart';
import 'package:flutter_2048/game/state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';

class GameCubit extends Cubit<GameState> {
  bool cantMove = false;
  final bool removeRecursion;
  int result = 0;

  GameCubit({this.removeRecursion = false}) : super(GameState([], false));

  GameCubit.test(GameState initState, {this.removeRecursion = false})
      : super(initState);

  startGame() {

    emit(state.copyWith(gameEnded: false));
    final firstCube = _generationCubes([]);
    final secondCube = _generationCubes([firstCube!]);
    final thirdCube = _generationCubes([firstCube, secondCube!]);
    _updateCubes([firstCube, secondCube, thirdCube!]);
  }

  _updateCubes(List<Cube> cubes) {
    if (cubes.compare(state.cubes)) {
      return;
    }
    cantMove = true;
    var safeCubes = cubes;
    final safeState = state;
    final toAdd = _generationCubes(safeCubes);
    if (toAdd != null) {
      safeCubes.add(toAdd);
    }
    emit(state.copyWith(cubes: safeCubes));
    Future.delayed(const Duration(milliseconds: 10), () {
      safeCubes = cubes
          .map((e) =>
              safeState.cubes.where((element) => element.id == e.id).isEmpty
                  ? e.copyWith(visible: true)
                  : e)
          .toList();
      emit(state.copyWith(cubes: safeCubes));
    });
    Future.delayed(Game.animationDuration, () {
      final newCubes = safeCubes.where((element) => element.visible).toList();
      emit(state.copyWith(cubes: newCubes));
      l.log(removeRecursion.toString(), name: "recuesion");
      if (cubes.length == 16) {
        _checkNextMove();
      }
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
            (cubes.sorted((a, b) => a.id - b.id).lastOrNull?.id ?? 0) +
                Random().nextInt(100) +
                1,
            (Random().nextInt(2) % 2 + 1) * 2,
            position,
            false,
          )
        : null);
  }

  _checkNextMove() {
    bool noWayUp = false;
    bool noWayDown = false;
    bool noWayLeft = false;
    bool noWayRight = false;
    final test = GameCubit.test(
      state,
      removeRecursion: true,
    );
    l.log("test25: ${_debilTest()}");
    l.log('1111');
    test.moveDown();
    if (test.state != state) {
      return;
    } else {
      noWayDown = true;
    }
    l.log('2222');
    test.moveUp();
    if (test.state != state) {
      return;
    } else {
      noWayUp = true;
    }
    l.log('3333');
    test.moveLeft();
    if (test.state != state) {
      return;
    } else {
      noWayLeft = true;
    }
    test.moveRight();
    l.log('4444');
    if (test.state != state) {
      return;
    } else {
      noWayRight = true;
    }
    if (noWayRight && noWayLeft && noWayDown && noWayUp) {
      l.log('1111111123');
      emit(state.copyWith(gameEnded: true));
    }
  }

  bool _debilTest() {
    bool noWayUp = false;
    bool noWayDown = false;
    bool noWayLeft = false;
    bool noWayRight = false;
    final test = GameCubit.test(
      state,
      removeRecursion: true,
    );
    l.log('1111');
    test.moveDown();
    if (test.state != state) {
      return false;
    }
    l.log('2222');
    test.moveUp();
    if (test.state != state) {
      return false;
    }
    l.log('3333');
    test.moveLeft();
    if (test.state != state) {
      return false;
    }
    test.moveRight();
    l.log('4444');
    if (test.state != state) {
      return false;
    }
    return true;
  }

  moveUp() {
    l.log('TUT');
    if (cantMove) {
      l.log('TUT');
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
    if (cantMove) {
      return;
    }
    var cubes = state.cubes;
    for (int i = 0; i < 4; i++) {
      for (int j = 2; j > -1; j--) {
        for (int k = j; k < 3; k++) {
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
      result += firstCube.value * 2;
      GetStorage().write('score', result);
      l.log(result.toString(), name: "result");
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
