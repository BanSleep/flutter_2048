import 'package:flutter_2048/game/cubit.dart';
import 'package:flutter_2048/game/state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testComparingCubes();
}

void testComparingCubes() {
  final cubit = GameCubit();
  test('compare cubes test cubes with equal value', () {
    final firstCube = Cube(1, 1, 0, true);
    final secondCube = Cube(2, 1, 1, true);

    final result = cubit.compareCubes([firstCube, secondCube], 0, 1, 0);
    expect(result.length, 3);
    expect(result.contains(Cube(3, 2, 0, false)), true);
    expect(result.contains(Cube(1, 1, 0, false)), true);
    expect(result.contains(Cube(2, 1, 0, false)), true);
  });

  test('compare cubes test cubes with diff value', () {
    final firstCube = Cube(1, 1, 0, true);
    final secondCube = Cube(2, 2, 1, true);

    final result = cubit.compareCubes([firstCube, secondCube], 0, 1, 0);
    expect(result.length, 2);
    expect(result.contains(firstCube), true);
    expect(result.contains(secondCube), true);
  });

  test('compare cube with empty', () {
    final firstCube = Cube(1, 1, 0, true);

    final result = cubit.compareCubes([firstCube], 0, 1, 0);
    expect(result.length, 1);
    expect(result.first, firstCube);
  });

  test('compare empty with cube', () {
    final firstCube = Cube(1, 1, 0, true);

    final result = cubit.compareCubes([firstCube], 0, 1, 1);
    expect(result.length, 1);
    expect(result.first, Cube(1, 1, 1, true));
  });

  test('compare empty with empty', () {
    final result = cubit.compareCubes([Cube(1, 1, 3, true)], 0, 1, 0);

    expect(result.length, 0);
  });
}