import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/src/events/messages/drag_update_event.dart';
import 'dart:math';

 
class Player extends SpriteComponent with HasGameRef {
 Player(this.joystick)
     : super(size: Vector2.all(100.0), anchor: Anchor.center);
  double maxSpeed = 300.0;

  final JoystickComponent joystick;
  
 
 @override
 Future<void> onLoad() async {
   super.onLoad();
   sprite = await gameRef.loadSprite('Player.png');
    position = gameRef.size / 2;
    add(RectangleHitbox());
 }

 @override
  void update(double dt) { //player movement
    if (joystick.direction != JoystickDirection.idle) {
      if (joystick.direction == JoystickDirection.up || joystick.relativeDelta[1] < 0 && pow(joystick.relativeDelta[1],2) > pow(joystick.relativeDelta[0],2)){
        position.add(Vector2(0, dt * -maxSpeed));
      }
      else if (joystick.direction == JoystickDirection.left || joystick.relativeDelta[0] < 0 && pow(joystick.relativeDelta[0],2) > pow(joystick.relativeDelta[1],2)){
        position.add(Vector2(dt * -maxSpeed, 0));
      }
       else if (joystick.direction == JoystickDirection.right || joystick.relativeDelta[0] > 0 && pow(joystick.relativeDelta[0],2) > pow(joystick.relativeDelta[1],2)){
        position.add(Vector2(dt * maxSpeed, 0));
      }
      else if (joystick.direction == JoystickDirection.down || joystick.relativeDelta[1] > 0 && pow(joystick.relativeDelta[1],2) > pow(joystick.relativeDelta[0],2)){
        position.add(Vector2(0, dt * maxSpeed));
      }
    }
  }
}