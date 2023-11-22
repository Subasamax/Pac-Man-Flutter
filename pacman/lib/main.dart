import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';
import 'pac_man_game.dart';


void main() {
  print("setup game orientation");
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.fullScreen();
  Flame.device.setLandscape();
  final game = PacMan();
  runApp(GameWidget(game: game));
}