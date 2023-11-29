
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
  late final JoystickComponent joystick;
  late TiledComponent mapComponent;
  late final CameraComponent cameraComponent;
  BuildContext context;
  
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

      final GameOver = TextPaint(
    style:  const TextStyle(
          color: Colors.red,
          fontSize: 100
        ),
        
  );
  late TextComponent GameOverText = TextComponent(
    text: "Game Over",
    position: Vector2(300,250),
    textRenderer: GameOver
  );



  
  void startGame(TiledComponent mapComponent){
    red.priority = 1;
    blue.priority = 1;
    orange.priority = 1;
    pink.priority = 1;
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
    coins =  mapComponent.tileMap.getLayer<ObjectGroup>("Coins")!.objects;
     for (var coinObject in coins){ 
       Coin temp = Coin(coin: coinObject);
       temp.priority = 0;
       all_coins.add(temp);
       world.add(temp);
     }
    Whitecoins = mapComponent.tileMap.getLayer<ObjectGroup>("WhiteCoin")!.objects;
    for (var coinObject in Whitecoins){ 
      WhiteCoin temp = WhiteCoin(coin: coinObject);
      temp.priority = 0;
      all_coins.add(temp);
      world.add(temp);
    }
    world.add(red);
    world.add(blue);
    world.add(orange);
    world.add(pink);
    final knobPaint = BasicPalette.blue.withAlpha(200).paint();
    final backgroundPaint = BasicPalette.blue.withAlpha(100).paint();
    joystick = JoystickComponent(
       size: 300,
       position: Vector2(1150, 400),
       knob: CircleComponent(radius: 40, paint: knobPaint),
       background: CircleComponent(radius: 80, paint: backgroundPaint),
    );
    player = Player(joystick, mapComponent);
    player.priority = 1;
    world.add(player);
    world.add(joystick);
    world.add(UI);

  }

  void NextLevel(){
    player.reset();
    for (var object in all_coins){
      if(object.isRemoved != false){
        world.add(object);
      }
    }
    softReset();
  }


  void hardReset(){
    GameOverMessage();
    player.reset();
    for (var object in all_coins){
      if(object.isRemoved != false){
        world.add(object);
      }
    }
    softReset();
    UI.level = 1;
    player.life = 3;
    player.score = 0;
  }

  void softReset(){
   red.softReset();
   blue.softReset();
   orange.softReset();
   pink.softReset();
   player.reset();
  }

  @override
  Future<void> onLoad() async {
    world = World();
    cameraComponent = CameraComponent.withFixedResolution(
       world: world,
       width: 1300,
       height: 600,
     );
     cameraComponent.viewfinder.anchor = Anchor.topLeft;
     //cameraComponent.viewport = FixedResolutionViewport(resolution: Vector2(1200, 600));
     addAll([world, cameraComponent]);
    var mapComponent = await TiledComponent.load('map.tmx', Vector2(32, 32));
    startGame(mapComponent);
  }

   Future<void> GameOverMessage() async {
    world.add(GameOverText);
    Future.delayed(const Duration(milliseconds: 30));
    pauseEngine();
    Future.delayed(const Duration(seconds: 4));
    world.remove(GameOverText);
    resumeEngine();
    Navigator.pop(context);
  }

    

  @override
  void update(double dt) {
    super.update(dt);
   
    UI.Score = player.score;
    if (player.life == -1){
      hardReset();    
    }
    else if (player.resetGame == true){
      softReset();
    }
    else if (player.coinsCollected == all_coins.length){
      player.coinsCollected = 0;
      UI.level++;
      NextLevel();
    }
    UI.lives = player.life;
    

  }
    
    
  
}
