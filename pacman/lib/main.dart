import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';
import 'pac_man_game.dart';
import 'components/player.dart';

void main() {
  final game = PacMan();
  runApp(GameWidget(game: game));
}