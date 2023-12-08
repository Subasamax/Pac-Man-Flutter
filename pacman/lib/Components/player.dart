
// ignore_for_file: non_constant_identifier_names
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:pacman/Components/Ghost.dart';
import 'package:pacman/Components/Movement/DownLeft.dart';
import 'package:pacman/Components/Movement/DownRight.dart';
import 'package:pacman/Components/Movement/LeftRightDown.dart';
import 'package:pacman/Components/Movement/LeftRightUp.dart';
import 'package:pacman/Components/Movement/UpDownLeft.dart';
import 'package:pacman/Components/Movement/UpDownRight.dart';
import 'package:pacman/Components/Movement/UpDownRightLeft.dart';
import 'package:pacman/Components/Movement/UpLeft.dart';
import 'package:pacman/Components/Movement/UpRight.dart';
import 'package:pacman/Components/Movement/TeleportLeft.dart';
import 'package:pacman/Components/Movement/TeleportRight.dart';
import 'dart:math';
import 'package:pacman/Components/Wall.dart';

class Player extends SpriteAnimationComponent  with CollisionCallbacks, HasGameRef {
 Player(this.joystick, this.map)
     : super(size: Vector2.all(24), anchor: Anchor.center, position: Vector2(496, 432) );
  // sets speed values
  double maxSpeed = 60.0;
  double speed = 60;
  
  final JoystickComponent joystick;
  late JoystickComponent  currentJoystickDir;
  TiledComponent map;
  
  // creates animation variables
  final double _animationSpeed = .05;
  late final SpriteAnimation _runDownAnimation;
  late final SpriteAnimation _runLeftAnimation;
  late final SpriteAnimation _runUpAnimation;
  late final SpriteAnimation _runRightAnimation;
  late final SpriteAnimation _standingAnimation;
  late final SpriteAnimation _runDownAnimationInvincible;
  late final SpriteAnimation _runLeftAnimationInvincible;
  late final SpriteAnimation _runUpAnimationInvincible;
  late final SpriteAnimation _runRightAnimationInvincible;
  late  SpriteAnimation _runDown;
  late  SpriteAnimation _runLeft;
  late  SpriteAnimation _runUp;
  late  SpriteAnimation _runRight;
 
 // variables
  Vector2 currentMove = Vector2(0,0);
  Vector2 CurrentPosition = Vector2(0,0);
  bool collided = false;
  JoystickDirection CollidedDirection = JoystickDirection.idle;
  JoystickDirection idleCollidedDirection = JoystickDirection.idle;
  JoystickDirection MovDirection = JoystickDirection.idle;
  JoystickDirection Direction = JoystickDirection.idle;
  late SpriteAnimation current;
  
  // lists of all posible move directions in the map
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

  // sets timers, collision, life and score variables
  var wallCollision = false;
  bool Invincible = false;
  bool resetGame = false;
  int life = 3;
  int score = 0;
  int Inviincible_Timer = -1;
  int coinsCollected = 0;


 @override
 Future<void> onLoad() async {
   await _loadAnimations().then((_) => {animation = _standingAnimation});
   // adds hitbox for center of player plus the whole player
   add(RectangleHitbox());
   add(RectangleHitbox(
    position: Vector2(12,12),
    size: Vector2.all(1),
    anchor: Anchor.center,
    isSolid: false
   ));
   currentJoystickDir = joystick;

}
  // loads all animations for the player
Future<void> _loadAnimations() async {
   final spriteSheet = SpriteSheet(
     image: await gameRef.images.load('Player_movement.png'),
     srcSize: Vector2(32, 32),
    
   );

    final spriteSheetInvincible = SpriteSheet(
     image: await gameRef.images.load('Invincible_Mode.png'),
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
 
  _runDownAnimationInvincible =
       spriteSheetInvincible.createAnimation(row: 3, stepTime: _animationSpeed, to: 6);
  
   _runLeftAnimationInvincible =
       spriteSheetInvincible.createAnimation(row: 2, stepTime: _animationSpeed, to: 7);
 
  _runUpAnimationInvincible =
       spriteSheetInvincible.createAnimation(row: 1, stepTime: _animationSpeed, to: 7);
 
  _runRightAnimationInvincible =
       spriteSheetInvincible.createAnimation(row: 0, stepTime: _animationSpeed, to: 7);
  
  _runDown =  _runDownAnimation;
  _runLeft =  _runLeftAnimation;
  _runUp =  _runUpAnimation;
  _runRight =  _runRightAnimation;
  current = _standingAnimation;
 
 }

// swaps the animations for the player between original and invincible
  void swapAnimations(){
  if (_runLeft == _runLeftAnimation){
    _runDown =  _runDownAnimationInvincible;
    _runLeft =  _runLeftAnimationInvincible;
    _runUp =  _runUpAnimationInvincible;
    _runRight =  _runRightAnimationInvincible;
    if (current == _runDownAnimation){
      animation = _runDown;
      current = _runDown;
    }
    else if (current == _runLeftAnimation){
      animation = _runLeft;
      current = _runLeft;
    }
     else if (current == _runUpAnimation){
      animation = _runUp;
      current = _runUp;
    }
     else if (current == _runRightAnimation){
      animation = _runRight;
      current = _runRight;
    }
  }
  else{
    _runDown =  _runDownAnimation;
    _runLeft =  _runLeftAnimation;
    _runUp =  _runUpAnimation;
    _runRight =  _runRightAnimation;
  }



}


// reserts the player 
 void reset(){
  position =  Vector2(496, 432);
  Direction = JoystickDirection.idle;
  currentPossibleMoves = LeftRight;
  current = _standingAnimation;
  _runDown =  _runDownAnimation;
  _runLeft =  _runLeftAnimation;
  _runUp =  _runUpAnimation;
  _runRight =  _runRightAnimation;
  Inviincible_Timer = -1;
  Invincible = false;
  resetGame = false;
 }

// moves passively in the direction without any input from player
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
    if (resetGame){ // if resetgame reset
      reset();
    }
    if (Inviincible_Timer > 0){ // if timer is greater than 0
      Inviincible_Timer--; // decrement
      if (Inviincible_Timer < 150 && Inviincible_Timer % 15 == 0){
        swapAnimations();
      }
    }
    else if(Inviincible_Timer == 0){ // if 0, reset invincible status to false
      Invincible = false;
      maxSpeed = speed;
      swapAnimations();
      Inviincible_Timer = -1;
    }
    // gets movement direction of joystick
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
      // checks and determines new move direction
      if (currentPossibleMoves.contains(MovDirection)){
        if (MovDirection == JoystickDirection.up){
          currentPossibleMoves = DownUp;
          currentMove = Vector2(0,dt*-maxSpeed);
          position.add(currentMove);
          animation = _runUp;
          current = _runUp;
          Direction = JoystickDirection.up;
        }
        else if (MovDirection == JoystickDirection.right){
          currentPossibleMoves = LeftRight;
          currentMove = Vector2(dt * maxSpeed, 0);
          position.add(currentMove);
          animation = _runRight;
          current = _runRight;
          Direction = JoystickDirection.right;
        }
        else if (MovDirection == JoystickDirection.left){
          currentPossibleMoves = LeftRight;
          currentMove =Vector2(dt * -maxSpeed, 0);
          position.add(currentMove);
          animation = _runLeft;
          current = _runLeft;
          Direction = JoystickDirection.left;
        }
        else if (MovDirection == JoystickDirection.down){
          currentPossibleMoves = DownUp;
          currentMove = Vector2(0,dt*maxSpeed);
          position.add(currentMove);
          animation = _runDown;
          current = _runDown;
          Direction = JoystickDirection.down;
        }
      }
      else{
        // passive moves if no collision
        if (collided == false) PassiveMove(Direction, dt);
      }
    }
    else{
      // passive moves if no collisions
      if (collided == false) PassiveMove(Direction, dt);
    }
    super.update(dt); //player movement
  }




@override
void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
  super.onCollision(intersectionPoints, other);
  IntersectPos= Vector2(intersectionPoints.elementAt(0)[0].toInt().toDouble(), intersectionPoints.elementAt(0)[1].toInt().toDouble()); // gets collision pos
  Pos= Vector2(position[0].toInt().toDouble(), position[1].toInt().toDouble()); // gets pos
   if (other is Wall ){ // if wall, move opposite direction
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
   //////////// Defines Movement Collisions ////////////////
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
   /////////////// End define movement collisions /////////////
  else if (other is TeleportLeft){  // if teleport update position
     position = Vector2(80,304);
  }
  else if (other is TeleportRight){ // if teleport update position
    position = Vector2(940,304);
  }
  else if (other is Ghost){ // if ghost, check if invincible, if not lose a life and soft reset
    if (Invincible){ // if invincible
        other.position = other.StartPosition; // resets ghost pos
        other.timer = 250; // sets timer
        other.start = true; // sets start
        score += 100; // add score
        other.Direction = JoystickDirection.idle;
        other.PastDirection = JoystickDirection.idle;
        other.currentPossibleMoves = LeftRight;
      }
      else{
        life--; // decrement life
        resetGame = true; // sets reset game
      }
  }
  
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
  }
}

