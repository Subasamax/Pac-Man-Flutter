
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:pacman/Home.dart';
import 'package:pacman/Leaderboard.dart';
import 'pac_man_game.dart';
import 'package:flutter/material.dart';

void main() {
   WidgetsFlutterBinding.ensureInitialized(); // ensures initialized
   Flame.device.fullScreen(); // sets device to fullscreen
   Flame.device.setLandscape(); // sets landscape 
  runApp(MaterialApp(
    title: 'PACMAN', // sets title
    initialRoute: '/',
    routes:{
      '/': (context) => const Home(), // define route to home
      '/pacman': (context) => GameWidget(game: PacMan(context: context)), // game
      '/leaderboard' : (context) =>  LEADERBOARD(),  // leaderboard
    }
   )
  );
  
}