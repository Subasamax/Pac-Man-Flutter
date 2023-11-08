import 'dart:math';

import 'package:flame/camera.dart';
import 'package:flame/effects.dart';
import 'package:flame/game.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/foundation.dart';
import 'package:pacman/Components/world.dart';
//import 'components/world_collidable.dart';
//import 'helpers/map_loader.dart';
//import 'package:flame/components.dart';
import 'package:pacman/Components/player.dart';
import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/painting.dart';

class PacMan extends FlameGame {
  late final JoystickComponent joystick;
  //late TiledComponent mapComponent;
  late final CameraComponent cameraComponent;
  @override
  late final World world;
  
  
  @override
  Future<void> onLoad() async {
    world = World();
    cameraComponent = CameraComponent.withFixedResolution(
       world: world,
       width: 1200,
       height: 600,
     );
     cameraComponent.viewfinder.anchor = Anchor.topLeft;
     //cameraComponent.viewport = FixedResolutionViewport(resolution: Vector2(1200, 600));
     addAll([world, cameraComponent]);

    var mapComponent = await TiledComponent.load('map.tmx', Vector2(32, 32));
    await world.add(mapComponent);
    

   // addAll([world, cameraComponent]);
    //camera.viewport = FixedResolutionViewport(resolution: Vector2(1200, 1200));
    //add(camera);
    final knobPaint = BasicPalette.blue.withAlpha(200).paint();
    final backgroundPaint = BasicPalette.blue.withAlpha(100).paint();
    joystick = JoystickComponent(
       size: 200,
       position: Vector2(1100, 530),
       knob: CircleComponent(radius: 30, paint: knobPaint),
       background: CircleComponent(radius: 60, paint: backgroundPaint),
    );
    final Player player = Player(joystick);
    await world.add(player);
    await world.add(joystick);
  }
}
