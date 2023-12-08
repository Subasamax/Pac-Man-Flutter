
// ignore_for_file: non_constant_identifier_names


import 'package:flame/game.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';
import 'package:pacman/Components/Coin.dart';
import 'package:pacman/Components/Ghost.dart';
import 'package:pacman/Components/Movement/DownLeft.dart';
import 'package:pacman/Components/Movement/DownRight.dart';
import 'package:pacman/Components/Movement/LeftRightUp.dart';
import 'package:pacman/Components/Movement/LeftRightDown.dart';
import 'package:pacman/Components/Movement/UpDownLeft.dart';
import 'package:pacman/Components/Movement/UpDownRight.dart';
import 'package:pacman/Components/Movement/UpDownRightLeft.dart';
import 'package:pacman/Components/Movement/UpLeft.dart';
import 'package:pacman/Components/Movement/UpRight.dart';
import 'package:pacman/Components/Movement/TeleportLeft.dart';
import 'package:pacman/Components/Movement/TeleportRight.dart';
import 'package:pacman/Components/Wall.dart';
import 'package:pacman/Components/WhiteCoin.dart';
import 'package:pacman/Components/inGameUI.dart';
import 'package:pacman/Components/player.dart';
import 'package:flame/components.dart';
import 'package:flame/palette.dart';



class PacMan extends FlameGame with HasCollisionDetection {
  PacMan({required this.context});
  late final JoystickComponent joystick; // joystick
  late TiledComponent mapComponent; // mapcomponent from Tiled
  late final CameraComponent cameraComponent; // camera component
  BuildContext context; // creates a build context passed into this class
  final GameOver_Overlay = 'GameOver'; // defines the name of an overlay

  @override
  late final World world;
  Ghost red = Ghost(1);
  Ghost blue = Ghost(2);
  Ghost orange = Ghost(3);
  Ghost pink = Ghost(4);
  int Score = 0;
  late Player player;
  inGameUI UI = inGameUI();
  late List<TiledObject> coins;
  late List<TiledObject> Whitecoins;
  late List<Component> all_coins = [];

  void startGame(TiledComponent mapComponent){
    // sets ghost priority in render
    red.priority = 1;
    blue.priority = 1;
    orange.priority = 1;
    pink.priority = 1;

    // adding components for walls and turns
    world.add(mapComponent);
    world.add(Wall(mapComponent));
    world.add(UpDownrightLeft(mapComponent));
    world.add(DownRight(mapComponent));
    world.add(DownLeft(mapComponent));
    world.add(LeftRightUp(mapComponent));
    world.add(UpDownLeft(mapComponent));
    world.add(UpDownRight(mapComponent));
    world.add(LeftRightDown(mapComponent));
    world.add(UpLeft(mapComponent));
    world.add(UpRight(mapComponent));
    world.add(TeleportLeft(mapComponent));
    world.add(TeleportRight(mapComponent));
    // adding coins to map
    coins =  mapComponent.tileMap.getLayer<ObjectGroup>("Coins")!.objects;
     for (var coinObject in coins){ 
       Coin temp = Coin(coin: coinObject);
       temp.priority = 0;
       all_coins.add(temp);
       world.add(temp);
     }
     //adding white coins to map
    Whitecoins = mapComponent.tileMap.getLayer<ObjectGroup>("WhiteCoin")!.objects;
    for (var coinObject in Whitecoins){ 
      WhiteCoin temp = WhiteCoin(coin: coinObject);
      temp.priority = 0;
      all_coins.add(temp);
      world.add(temp);
    }

    // adding ghosts
    world.add(red);
    world.add(blue);
    world.add(orange);
    world.add(pink);
    // defining joysitck
    final knobPaint = BasicPalette.blue.withAlpha(200).paint();
    final backgroundPaint = BasicPalette.blue.withAlpha(100).paint();
    joystick = JoystickComponent(
       size: 300,
       position: Vector2(1150, 400),
       knob: CircleComponent(radius: 40, paint: knobPaint),
       background: CircleComponent(radius: 80, paint: backgroundPaint),
    );
    // creating and adding player
    player = Player(joystick, mapComponent);
    player.priority = 1;
    world.add(player);
    // add ui and joystick to world
    world.add(joystick);
    world.add(UI);
  }

  void NextLevel(){
    player.reset(); // resets player
    for (var object in all_coins){ // adds all coins back into world
        world.add(object);
    }
    softReset(); // calls soft reset
  }


  void hardReset(){
    GameOverMessage();
    for (var object in all_coins){ // checks if a coin is gone, if so , readd to world
      if(object.isRemoved != false){
        world.add(object);
      }
    }
    softReset(); // calls soft reset
    UI.level = 1; // updates UI level to 1
    player.life = 3; // resets player life
    player.score = 0; // resets player score
  }

  void softReset(){ // calls soft reset for ghosts and player
   red.softReset();
   blue.softReset();
   orange.softReset();
   pink.softReset();
   player.reset();
  }


  

  @override
  Future<void> onLoad() async {
    world = World(); // creates world
    cameraComponent = CameraComponent.withFixedResolution( // defines camera component
       world: world,
       width: 1300,
       height: 600,
     );
     cameraComponent.viewfinder.anchor = Anchor.topLeft; // sets camera viewfinder anchor
     addAll([world, cameraComponent]); // adds world and camera 
    var mapComponent = await TiledComponent.load('map.tmx', Vector2(32, 32)); // loads map
    startGame(mapComponent); // starts game with loaded mapcomponent
  }

  Future<void> GameOverMessage() async {
    pauseEngine(); // pauses the game engine
    overlays.add(GameOver_Overlay); // adds an overlay to the game
    player.reset(); // resets the player
  }

    

  @override
  void update(double dt) {
    super.update(dt);
    Score = player.score; // updates the score
    UI.Score = player.score; // updates the ui score
    if (player.life < 0){ // if player losses all lifes and dies
      hardReset();     // hard reset the game
    }
    else if (player.resetGame == true){ //else if player needs the board reset, 
      softReset(); // soft reset the game
    }
    else if (player.coinsCollected == all_coins.length){ // if player gets all collectables
      player.coinsCollected = 0; // set coins collected to 0
      UI.level++; // up the level
      NextLevel(); // set the next level
    }
    UI.lives = player.life; // updates the UI lives

  }  
}

