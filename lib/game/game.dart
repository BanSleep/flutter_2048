import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_2048/game/cubit.dart';
import 'package:flutter_2048/game/state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Game extends StatelessWidget {
  static const animationDuration = Duration(milliseconds: 300);

  const Game({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.arrowLeft): () =>
            context.read<GameCubit>().moveLeft(),
        const SingleActivator(LogicalKeyboardKey.arrowDown): () =>
            context.read<GameCubit>().moveDown(),
        const SingleActivator(LogicalKeyboardKey.arrowRight): () =>
            context.read<GameCubit>().moveRight(),
        const SingleActivator(LogicalKeyboardKey.arrowUp): () =>
            context.read<GameCubit>().moveUp(),
      },
      child: Focus(
        autofocus: true,
        child: BlocBuilder<GameCubit, GameState>(builder: (context, state) {
          return LayoutBuilder(
            builder: (context, constraints) {
              final size =
                  math.min(constraints.maxHeight, constraints.maxWidth) / 4;
              return SizedBox(
                width: size * 4,
                height: size * 4,
                child: GestureDetector(
                  onHorizontalDragEnd: (details) {
                    final pixels = details.velocity.pixelsPerSecond.dx;
                    if (math.sqrt(pixels * pixels) < 500) {
                      return;
                    }
                    if (pixels < 0) {
                      context.read<GameCubit>().moveLeft();
                    } else {
                      context.read<GameCubit>().moveRight();
                    }
                  },
                  onVerticalDragEnd: (details) {
                    final pixels = details.velocity.pixelsPerSecond.dy;
                    if (math.sqrt(pixels * pixels) < 500) {
                      return;
                    }
                    if (pixels < 0) {
                      context.read<GameCubit>().moveUp();
                    } else {
                      context.read<GameCubit>().moveDown();
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0x00000000),
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                    child: Stack(
                      children: [
                        for (int i = 1; i <= 3; i++) ...[
                          Positioned(
                            left: i * size - 2,
                            top: 0,
                            bottom: 0,
                            width: 2,
                            child: Container(
                              color: Colors.black,
                            ),
                          ),
                          Positioned(
                            top: i * size - 2,
                            left: 0,
                            right: 0,
                            height: 2,
                            child: Container(
                              color: Colors.black,
                            ),
                          ),
                        ],
                        ...state.cubes.map(
                          (e) => AnimatedPositioned(
                            curve: Curves.linearToEaseOut,
                            key: Key("Cube: ${e.id}"),
                            left: size * (e.position % 4),
                            top: size * (e.position ~/ 4),
                            child: AnimatedOpacity(
                              opacity: e.visible ? 1 : 0,
                              curve: Curves.linearToEaseOut,
                              duration: Game.animationDuration,
                              child: Container(
                                color: Colors.primaries[e.value],
                                width: size - 2,
                                height: size - 2,
                                child: Center(
                                    child: Text(
                                  e.value.toString(),
                                  style: TextStyle(
                                    fontSize: 40,
                                    color: Colors.white,
                                  ),
                                )),
                              ),
                            ),
                            duration: Game.animationDuration,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
