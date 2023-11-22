

// ignore_for_file: non_constant_identifier_names

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/foundation.dart';
import 'package:pacman/Components/Coin.dart';
import 'package:pacman/Components/Movement/DownLeft.dart';
import 'package:pacman/Components/Movement/DownRight.dart';
import 'package:pacman/Components/Movement/LeftRightDown.dart';
import 'package:pacman/Components/Movement/LeftRightUp.dart';
import 'package:pacman/Components/Movement/UpDownLeft.dart';
import 'package:pacman/Components/Movement/UpDownRight.dart';
import 'package:pacman/Components/Movement/UpDownRightLeft.dart';
import 'package:pacman/Components/Movement/UpLeft.dart';
import 'package:pacman/Components/Movement/UpRight.dart';
import 'dart:math';

import 'package:pacman/Components/Wall.dart';




 
class Player extends SpriteAnimationComponent  with CollisionCallbacks, HasGameRef {
 Player(this.joystick, this.map)
     : super(size: Vector2.all(24), anchor: Anchor.center, position: Vector2(496, 432) );
  double maxSpeed = 55.0;
  
  
//right tunnel x = 930  left -2?
// 1100, 530

// [482.6272500000005,431.76087500000045] spawn
  final JoystickComponent joystick;
  late JoystickComponent  currentJoystickDir;
  TiledComponent map;
  final double _animationSpeed = .05;
  late final SpriteAnimation _runDownAnimation;
  late final SpriteAnimation _runLeftAnimation;
  late final SpriteAnimation _runUpAnimation;
  late final SpriteAnimation _runRightAnimation;
  late final SpriteAnimation _standingAnimation;
  Vector2 currentMove = Vector2(0,0);
  Vector2 CurrentPosition = Vector2(0,0);
  bool collided = false;
  JoystickDirection CollidedDirection = JoystickDirection.idle;
   JoystickDirection idleCollidedDirection = JoystickDirection.idle;
  JoystickDirection MovDirection = JoystickDirection.idle;
  JoystickDirection Direction = JoystickDirection.idle;
  late SpriteAnimation current;
  
  List<JoystickDirection> LeftRightDownUp = [JoystickDirection.left,JoystickDirection.right, JoystickDirection.down,JoystickDirection.up];
  List<JoystickDirection> LeftRight = [JoystickDirection.left,JoystickDirection.right];
  List<JoystickDirection> DownUp = [JoystickDirection.down,JoystickDirection.up];
  List<JoystickDirection> LeftUp = [JoystickDirection.left,JoystickDirection.up];
  List<JoystickDirection> RightLeftDown = [JoystickDirection.left,JoystickDirection.right, JoystickDirection.down];
  List<JoystickDirection> RightLeftUp = [JoystickDirection.left,JoystickDirection.right,JoystickDirection.up];
  List<JoystickDirection> RightDownUp = [JoystickDirection.right, JoystickDirection.down,JoystickDirection.up];
  List<JoystickDirection> LeftDownUp = [JoystickDirection.left,JoystickDirection.down,JoystickDirection.up];
  List<JoystickDirection> RightDown = [JoystickDirection.right, JoystickDirection.down];
  List<JoystickDirection> RightUp = [JoystickDirection.right, JoystickDirection.up];
  List<JoystickDirection> LeftDown = [JoystickDirection.left, JoystickDirection.down];
  List<JoystickDirection> currentPossibleMoves = [JoystickDirection.left,JoystickDirection.right];
  Vector2 IntersectPos = Vector2(0, 0);
  Vector2 Pos = Vector2(0, 0);
  var wallCollision = false;




  

 @override
 Future<void> onLoad() async {
   await _loadAnimations().then((_) => {animation = _standingAnimation});
    if (kDebugMode) {
      //debugMode = true;
    }
   add(RectangleHitbox());
   add(RectangleHitbox(
    position: Vector2(12,12),
    size: Vector2.all(.01),
    anchor: Anchor.center,
    isSolid: false
   ));
   currentJoystickDir = joystick;
  
   
     // size[0] = gameRef.size[0]/33;
     // size[1] = gameRef.size[1]/21;
   //sprite!.originalSize
   //size.scale(.4);

}

Future<void> _loadAnimations() async {
   final spriteSheet = SpriteSheet(
     image: await gameRef.images.load('Player_movement.png'),
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
  current = _standingAnimation;
 
 }

  void PassiveMove(JoystickDirection mov, double dt){
       if (mov == JoystickDirection.up){
          currentMove = Vector2(0,dt*-maxSpeed);
          position.add(currentMove);         
        }
        else if (mov == JoystickDirection.right){         
          currentMove = Vector2(dt * maxSpeed, 0);
          position.add(currentMove);
        }
        else if (mov == JoystickDirection.left){
          currentMove =Vector2(dt * -maxSpeed, 0);
          position.add(currentMove);
        }
        else if (mov == JoystickDirection.down){
          currentMove = Vector2(0,dt*maxSpeed);
          position.add(currentMove);
        }
         animation = current;
 }




 @override
  void update(double dt) {
    
    CurrentPosition = position;
    //print(position);
    if (joystick.direction != JoystickDirection.idle && wallCollision == false) {
      if (((joystick.direction == JoystickDirection.up || joystick.relativeDelta[1] < 0 && pow(joystick.relativeDelta[1],2) > pow(joystick.relativeDelta[0],2)) )){
           MovDirection = JoystickDirection.up;
      }
      else if ((joystick.direction == JoystickDirection.left || joystick.relativeDelta[0] < 0 && pow(joystick.relativeDelta[0],2) > pow(joystick.relativeDelta[1],2))){
       MovDirection = JoystickDirection.left;
      }
       else if ((joystick.direction == JoystickDirection.right || joystick.relativeDelta[0] > 0 && pow(joystick.relativeDelta[0],2) > pow(joystick.relativeDelta[1],2))){
       MovDirection = JoystickDirection.right;
      }
      else if ((joystick.direction == JoystickDirection.down || joystick.relativeDelta[1] > 0 && pow(joystick.relativeDelta[1],2) > pow(joystick.relativeDelta[0],2))){
            MovDirection = JoystickDirection.down;
      }
      if (currentPossibleMoves.contains(MovDirection)){
        if (MovDirection == JoystickDirection.up){
          currentPossibleMoves = DownUp;
          currentMove = Vector2(0,dt*-maxSpeed);
          position.add(currentMove);
          animation = _runUpAnimation;
          current = _runUpAnimation;
          Direction = JoystickDirection.up;
        }
        else if (MovDirection == JoystickDirection.right){
          currentPossibleMoves = LeftRight;
          currentMove = Vector2(dt * maxSpeed, 0);
          position.add(currentMove);
          animation = _runRightAnimation;
          current = _runRightAnimation;
          Direction = JoystickDirection.right;
        }
        else if (MovDirection == JoystickDirection.left){
          currentPossibleMoves = LeftRight;
          currentMove =Vector2(dt * -maxSpeed, 0);
          position.add(currentMove);
          animation = _runLeftAnimation;
          current = _runLeftAnimation;
          Direction = JoystickDirection.left;
        }
        else if (MovDirection == JoystickDirection.down){
          currentPossibleMoves = DownUp;
          currentMove = Vector2(0,dt*maxSpeed);
          position.add(currentMove);
          animation = _runDownAnimation;
          current = _runDownAnimation;
          Direction = JoystickDirection.down;
        }
      }
      else{
        
        if (collided == false) PassiveMove(Direction, dt);
      }
    }
    else{
      if (collided == false) PassiveMove(Direction, dt);
    }
    super.update(dt); //player movement
  }




@override
void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
  super.onCollision(intersectionPoints, other);
  IntersectPos= Vector2(intersectionPoints.elementAt(0)[0].toInt().toDouble(), intersectionPoints.elementAt(0)[1].toInt().toDouble());
  Pos= Vector2(position[0].toInt().toDouble(), position[1].toInt().toDouble());
   if (other is Wall ){
    if (!collided ){
          wallCollision = true;
          collided = true;
          if (intersectionPoints.elementAt(1)[1] < position[1] && Direction == JoystickDirection.up){   
           position[1] = intersectionPoints.elementAt(1)[1]+17;
          }
          else  if (intersectionPoints.elementAt(1)[0] < position[0] && Direction == JoystickDirection.left){   
           position[0] = intersectionPoints.elementAt(0)[0]+17; 
          }
          else  if (intersectionPoints.elementAt(1)[0] > position[0] && Direction == JoystickDirection.right){   
           position[0] = intersectionPoints.elementAt(0)[0]-17; 
          }
         else  if (intersectionPoints.elementAt(0)[1] > position[1] && Direction == JoystickDirection.down){   
           position[1] = intersectionPoints.elementAt(0)[1]-17; 
          }
          else{
            position = CurrentPosition;
          } 
          idleCollidedDirection = CollidedDirection;
        }
      
   }
   else if (other is UpDownrightLeft && Pos == IntersectPos){
     currentPossibleMoves = LeftRightDownUp;
     wallCollision = false;
   }
   else if (other is DownRight && Pos == IntersectPos){
    if (Direction == JoystickDirection.left || Direction == JoystickDirection.up){
      collided = true;
    }
    currentPossibleMoves = RightDown;
    wallCollision = false;
   }
   else if (other is LeftRightUp && Pos == IntersectPos){
    if (Direction == JoystickDirection.down){
      collided = true;
    }
    currentPossibleMoves = RightLeftUp;
    wallCollision = false;
   }
  else if (other is LeftRightDown && Pos == IntersectPos){
    if (Direction == JoystickDirection.up){
      collided = true;
    }
    currentPossibleMoves = RightLeftDown;
    wallCollision = false;
  }
   else if (other is UpDownLeft && Pos == IntersectPos){
    if (Direction == JoystickDirection.right){
      collided = true;
    }
    currentPossibleMoves = LeftDownUp;
    wallCollision = false;
   }
   else if (other is UpDownRight && Pos == IntersectPos){
    if (Direction == JoystickDirection.left){
      collided = true;
    }
    currentPossibleMoves = RightDownUp;
    wallCollision = false;
   }
  else if (other is DownLeft && Pos == IntersectPos){
    if (Direction == JoystickDirection.right || Direction == JoystickDirection.up){
      collided = true;
    }
    currentPossibleMoves = LeftDown;
    wallCollision = false;
   }
   else if (other is UpLeft && Pos == IntersectPos){
    if (Direction == JoystickDirection.right || Direction == JoystickDirection.down){
      collided = true;
    }
    currentPossibleMoves = LeftUp ;
    wallCollision = false;
   }
   else if (other is UpRight && Pos == IntersectPos){
    if (Direction == JoystickDirection.left || Direction == JoystickDirection.down){
      collided = true;
    }
    currentPossibleMoves = RightUp;
    wallCollision = false;
   }
  else if (other is Coin ){
    other.removeFromParent();
  }
   

  // TODO 1
}


  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
      collided = false;
      CollidedDirection = JoystickDirection.idle;
      if (Direction == JoystickDirection.up){
        currentPossibleMoves = DownUp;
      }
      else if (Direction == JoystickDirection.down){
         currentPossibleMoves = DownUp;
      }
      else if (Direction == JoystickDirection.left){
         currentPossibleMoves = LeftRight;
      }
      else if (Direction == JoystickDirection.right){
         currentPossibleMoves = LeftRight;
      }


      //CollidedDirection = JoystickDirection.idle;
      //CollidedDirection = JoystickDirection.idle;
    //print (collided);
    
    // TODO 2
  }
}




 /*
        
        */




/*

@override
  void update(double dt) {
    super.update(dt); //player movement
    CurrentPosition = position;
    //print(position);
    if (joystick.direction != JoystickDirection.idle) {
      if (((CollidedDirection != JoystickDirection.up) && (joystick.direction == JoystickDirection.up || joystick.relativeDelta[1] < 0 && pow(joystick.relativeDelta[1],2) > pow(joystick.relativeDelta[0],2)) )){
           
          currentMove = Vector2(0,dt*-maxSpeed);
          position.add(currentMove);
          animation = _runUpAnimation;
          current = _runUpAnimation;
          MovDirection = JoystickDirection.up;
          idleCollidedDirection = JoystickDirection.idle;   
                
      }
      else if ((CollidedDirection != JoystickDirection.left) &&(joystick.direction == JoystickDirection.left || joystick.relativeDelta[0] < 0 && pow(joystick.relativeDelta[0],2) > pow(joystick.relativeDelta[1],2))){
        currentMove =Vector2(dt * -maxSpeed, 0);
        position.add(currentMove);
         animation = _runLeftAnimation;
         current = _runLeftAnimation;
           MovDirection = JoystickDirection.left;
           idleCollidedDirection = JoystickDirection.idle;
      }
       else if ((CollidedDirection != JoystickDirection.right) && (joystick.direction == JoystickDirection.right || joystick.relativeDelta[0] > 0 && pow(joystick.relativeDelta[0],2) > pow(joystick.relativeDelta[1],2))){
        currentMove = Vector2(dt * maxSpeed, 0);
        position.add(currentMove);
        animation = _runRightAnimation;
        current = _runRightAnimation;
          MovDirection = JoystickDirection.right;
          idleCollidedDirection = JoystickDirection.idle;
      }
      else if ((CollidedDirection != JoystickDirection.down) &&  (joystick.direction == JoystickDirection.down || joystick.relativeDelta[1] > 0 && pow(joystick.relativeDelta[1],2) > pow(joystick.relativeDelta[0],2))){
            currentMove = Vector2(0,dt*maxSpeed);
            position.add(currentMove);
            animation = _runDownAnimation;
            current = _runDownAnimation;
            MovDirection = JoystickDirection.down;
            idleCollidedDirection = JoystickDirection.idle;
            
      }
    }
    else if (joystick.direction == JoystickDirection.idle && collided == false){
      if (MovDirection == JoystickDirection.up && idleCollidedDirection != JoystickDirection.up){
        currentMove = Vector2(0,dt*-maxSpeed);
        position.add(currentMove);
      }
      else if (MovDirection == JoystickDirection.left && idleCollidedDirection != JoystickDirection.left){
        currentMove =Vector2(dt * -maxSpeed, 0);
        position.add(currentMove);
      }
       else if (MovDirection == JoystickDirection.right && idleCollidedDirection != JoystickDirection.right){
        currentMove = Vector2(dt * maxSpeed, 0);
        position.add(currentMove);
      }
      else if (MovDirection == JoystickDirection.down && idleCollidedDirection != JoystickDirection.down){
        currentMove = Vector2(0,dt*maxSpeed);
        position.add(currentMove);
      }
      animation = current;
    }
  }
*/