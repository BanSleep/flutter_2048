class GameState {
  final List<Cube> cubes;
  final bool gameEnded;

  GameState(this.cubes, this.gameEnded);

  GameState copyWith({List<Cube>? cubes, bool? gameEnded}) => GameState(
        cubes ?? this.cubes,
        gameEnded ?? this.gameEnded,
      );

  @override
  String toString() {
    return 'GameState{cubes: $cubes}';
  }

  GameState.generateInitPosition()
      : cubes = _randomInitPosition(),
        gameEnded = false;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameState &&
          runtimeType == other.runtimeType &&
          cubes.compare(other.cubes) &&
          gameEnded == other.gameEnded;

  @override
  int get hashCode => cubes.fold(gameEnded.hashCode,
      (previousValue, element) => previousValue ^ element.hashCode);
}

List<Cube> _randomInitPosition() {
  return [
    Cube(0, 1, 0, true),
    Cube(1, 1, 4, true),
    Cube(2, 2, 8, true),
    Cube(3, 4, 12, true),
  ];
}

class Cube {
  final int id;
  final int value;
  final int position;
  final bool visible;

  Cube(this.id, this.value, this.position, this.visible);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Cube &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          value == other.value &&
          position == other.position &&
          visible == other.visible;

  @override
  int get hashCode =>
      id.hashCode ^ value.hashCode ^ position.hashCode ^ visible.hashCode;

  @override
  String toString() {
    return 'Cube{id: $id, value: $value, position: $position, visible: $visible}';
  }

  Cube copyWith({int? position, bool? visible}) => Cube(
        id,
        value,
        position ?? this.position,
        visible ?? this.visible,
      );
}

extension CubesExt on List<Cube> {
  bool compare(List<Cube> other) {
    if (other.length != length) {
      return false;
    }
    for (int i = 0; i < length; i++) {
      if (!other.contains(this[i])) {
        return false;
      }
    }
    return true;
  }
}
