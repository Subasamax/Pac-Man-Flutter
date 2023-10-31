import 'package:flame/game.dart';
//import 'components/world_collidable.dart';
//import 'helpers/map_loader.dart';
//import 'package:flame/components.dart';
import 'package:pacman/Components/player.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flutter/painting.dart';

class PacMan extends FlameGame {
 late final JoystickComponent joystick;


 @override
 Future<void> onLoad() async {
    
      final knobPaint = BasicPalette.blue.withAlpha(200).paint();
      final backgroundPaint = BasicPalette.blue.withAlpha(100).paint();
      joystick = JoystickComponent(
      knob: CircleComponent(radius: 30, paint: knobPaint),
      background: CircleComponent(radius: 100, paint: backgroundPaint),
      margin: const EdgeInsets.only(left: 40, bottom: 40),
    );
    final Player player = Player(joystick);
    add(player);
    add(joystick);
  

  
    
 
 }
    


}