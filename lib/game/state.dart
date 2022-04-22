class GameState {
  final List<Cube> cubes;

  GameState(this.cubes);

  GameState.generateInitPosition() : cubes = _randomInitPosition();
}

List<Cube> _randomInitPosition() {
  return [
    Cube(0, 1, 0, true),
    Cube(1, 1, 1, true),
    Cube(2, 2, 2, true),
    Cube(3, 4, 3, true),
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
