import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/src/events/messages/drag_update_event.dart';
import 'package:flame/sprite.dart';
import 'dart:math';

 
class Player extends SpriteAnimationComponent  with HasGameRef {
 Player(this.joystick)
     : super(size: Vector2.all(100.0), anchor: Anchor.center);
  double maxSpeed = 300.0;

  final JoystickComponent joystick;
  final double _animationSpeed = .05;
  late final SpriteAnimation _runDownAnimation;
  late final SpriteAnimation _runLeftAnimation;
  late final SpriteAnimation _runUpAnimation;
  late final SpriteAnimation _runRightAnimation;
  late final SpriteAnimation _standingAnimation;
  Vector2 currentMove = Vector2(0,0);
 
 @override
 Future<void> onLoad() async {
   await _loadAnimations().then((_) => {animation = _standingAnimation});
}

Future<void> _loadAnimations() async {
   final spriteSheet = SpriteSheet(
     image: await gameRef.images.load('player_movement.png'),
     srcSize: Vector2(32, 32),
   );
 
   _runDownAnimation =
       spriteSheet.createAnimation(row: 3, stepTime: _animationSpeed, to: 6);
  
   _runLeftAnimation =
       spriteSheet.createAnimation(row: 2, stepTime: _animationSpeed, to: 7);
 
  _runUpAnimation =
       spriteSheet.createAnimation(row: 1, stepTime: _animationSpeed, to: 7);
 
  _runRightAnimation =
       spriteSheet.createAnimation(row: 0, stepTime: _animationSpeed, to: 7);
  _standingAnimation = 
        spriteSheet.createAnimation(row: 0, stepTime: _animationSpeed, to: 1);
 
 }

 @override
  void update(double dt) {
    super.update(dt); //player movement
    if (joystick.direction != JoystickDirection.idle) {
      if (joystick.direction == JoystickDirection.up || joystick.relativeDelta[1] < 0 && pow(joystick.relativeDelta[1],2) > pow(joystick.relativeDelta[0],2)){
        currentMove = Vector2(0,dt*-maxSpeed);
        position.add(currentMove);
        animation = _runUpAnimation;
      }
      else if (joystick.direction == JoystickDirection.left || joystick.relativeDelta[0] < 0 && pow(joystick.relativeDelta[0],2) > pow(joystick.relativeDelta[1],2)){
        currentMove =Vector2(dt * -maxSpeed, 0);
        position.add(currentMove);
         animation = _runLeftAnimation;
      }
       else if (joystick.direction == JoystickDirection.right || joystick.relativeDelta[0] > 0 && pow(joystick.relativeDelta[0],2) > pow(joystick.relativeDelta[1],2)){
        currentMove = Vector2(dt * maxSpeed, 0);
        position.add(currentMove);
         animation = _runRightAnimation;
      }
      else if (joystick.direction == JoystickDirection.down || joystick.relativeDelta[1] > 0 && pow(joystick.relativeDelta[1],2) > pow(joystick.relativeDelta[0],2)){
        currentMove = Vector2(0, dt * maxSpeed);
        position.add(currentMove);
        animation = _runDownAnimation;
      }
    }
    else{
      position.add(currentMove);
    }
  }
}