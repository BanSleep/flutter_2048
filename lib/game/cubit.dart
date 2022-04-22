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
    cantMove = true;
    emit(GameState([
      Cube(0, 1, 0, false),
      Cube(1, 1, 0, false),
      Cube(2, 2, 0, false),
    ]));
    Future.delayed(const Duration(milliseconds: 10), () {
      emit(GameState([
        Cube(0, 1, 0, false),
        Cube(1, 1, 0, false),
        Cube(2, 2, 0, true),
      ]));
    });
    Future.delayed(Game.animationDuration, () {
      emit(GameState([
        Cube(2, 2, 0, true),
      ]));
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
    final safeState = state;
    for (int i = 0; i<4; i++) {
      for (int j = 0; j<3; j++) {
        for(int k = 0; k<=j; k++) {

        }
      }
    }
  }

  @visibleForTesting
  List<Cube> compareCubes(List<Cube> cubes, int positionFirst,
      int positionSecond, int goalPosition) {
    final firstCube = cubes
        .where((element) => element.visible)
        .firstWhereOrNull((element) => element.position == positionFirst);
    final secondCube = cubes
        .where((element) => element.visible)
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

    if (firstCube!.value == secondCube!.value) {
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
