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
      emit(GameState(safeCubes.where((element) => element.visible).toList()));
      cantMove = false;
    });
  }

  moveUp() {
    print("moveUp");
  }

  moveDown() {
    print("moveDown");
  }

  moveRight() {
    print("moveRight");
  }

  moveLeft() {
    print("moveLeft");
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
