import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_2048/game/cubit.dart';
import 'package:flutter_2048/game/state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';

import 'game.dart';

class Game extends StatefulWidget {
  final int score;
  static const animationDuration = Duration(milliseconds: 300);

  const Game({Key? key, required this.score}) : super(key: key);

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  int score = 0;

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
          return Stack(
            children: [

              LayoutBuilder(
                builder: (context, constraints) {
                  final size =
                      math.min(constraints.maxHeight, constraints.maxWidth) / 4;
                  return SizedBox(
                    width: size * 4,
                    height: size * 4,
                    child: GestureDetector(

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
                                    color: Colors.primaries[
                                        (math.log(e.value) / math.log(2)).floor()],
                                    width: size - 2,
                                    height: size - 2,
                                    child: Center(
                                        child: Text(
                                      e.value.toString(),
                                      style: const TextStyle(
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
              ),
              if (state.gameEnded) ...[
                Positioned.fill(
                  child: Center(
                    child: Container(
                      width: 400,
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('You lose!', style: TextStyle(fontSize: 36),),
                          SizedBox(height: 15,),
                          Text('Your score: $score'),
                          SizedBox(height: 20,),
                          TextButton(
                            onPressed: () {
                              context.read<GameCubit>().startGame();
                            },
                            child: const Text("Try Again", style: TextStyle(fontSize: 22),),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ]
            ],
          );
        }),
      ),
    );
  }
}
