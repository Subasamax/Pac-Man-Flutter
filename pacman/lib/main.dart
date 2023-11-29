
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:pacman/Home.dart';
import 'package:pacman/Leaderboard.dart';
import 'pac_man_game.dart';





import 'package:flutter/material.dart';

void main() {
   WidgetsFlutterBinding.ensureInitialized();
   Flame.device.fullScreen();
   Flame.device.setLandscape();
  runApp(MaterialApp(
    title: 'PACMAN',
    initialRoute: '/',
    routes:{
      '/': (context) => const Home(),
      '/pacman': (context) => GameWidget(game: PacMan(context: context)),
      '/leaderboard' : (context) => const LEADERBOARD(), 
    }
   )
  );
  
}








// void main() {
//   print("setup game orientation");
//   WidgetsFlutterBinding.ensureInitialized();
//   Flame.device.fullScreen();
//   Flame.device.setLandscape();
//   final game = PacMan();
//   runApp(GameWidget(game: game));
// }