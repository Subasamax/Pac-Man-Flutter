
// ignore_for_file: non_constant_identifier_names

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
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

class Ghost extends SpriteComponent with CollisionCallbacks, HasGameRef {
Ghost(this.ghost);

  // variables
  int ghost;
  double maxSpeed = 60.0;
  int timer = 0;
  int startTimer = 0;
  Vector2 currentMove = Vector2(0,0);
  Vector2 CurrentPosition = Vector2(0,0);
  Vector2 StartPosition = Vector2(0,0);

// lists of all possible move combinations on the map
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

  // joystick directions to idle
  JoystickDirection MovDirection = JoystickDirection.idle;
  JoystickDirection Direction = JoystickDirection.idle;
  JoystickDirection PastDirection = JoystickDirection.idle;
  
  // variables
  Vector2 IntersectPos = Vector2(0, 0);
  Vector2 Pos = Vector2(0, 0);
  bool collided = false;
  var wallCollision = false;
  bool start = true;
  bool infinite = true;
  bool newMove = false;
  bool resetGame = false;
  int randNumber = 0;
  Random random = Random();
 



@override
 Future<void> onLoad() async {
    await super.onLoad();
    if (ghost == 1){ // if ghost is 1 load red ghost
      sprite = await gameRef.loadSprite("Red_Ghost.png")..srcSize = Vector2.all(32);
      timer = 50;
      StartPosition = Vector2(500, 340);
      position = Vector2(500, 340);
      size =  Vector2.all(24);
      anchor = Anchor.center;

    }
    else if (ghost == 2){ // if ghost is 2 load blue ghost
      sprite = await gameRef.loadSprite("Blue_Ghost.png")..srcSize = Vector2.all(32);
      timer = 100;
      position = Vector2(525, 340);
      StartPosition = Vector2(525, 340);
      size =  Vector2.all(24);
      anchor = Anchor.center;
    }
    else if (ghost == 3){ // if ghost is 3 load orange ghost
      sprite = await gameRef.loadSprite("Orange_Ghost.png")..srcSize = Vector2.all(32);
      timer = 150;
      position = Vector2(500, 360);
      StartPosition = Vector2(500, 360);
      size =  Vector2.all(24);
      anchor = Anchor.center;
    }
    else if (ghost == 4){ // if ghost is 4 load pink ghost
      sprite = await gameRef.loadSprite("Pink_Ghost.png")..srcSize = Vector2.all(32);
      timer = 200;
      position = Vector2(525, 360);
      StartPosition = Vector2(525, 360);
      size =  Vector2.all(24);
      anchor = Anchor.center;
    }

    startTimer = timer; // sets timer
    add(RectangleHitbox()); // adds hitbox
    add(RectangleHitbox( // adds second hitbox for center of ghost
    position: Vector2(12,12),
    size: Vector2.all(1),
    anchor: Anchor.center,
    isSolid: true
    ));
  }


  // makes sure ghost moves passively in current direction
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
 }

  // chooses next direction based on list of moves and random number
  JoystickDirection ChoosePath(List<JoystickDirection> Moves){ 
    
      if (Moves.length == 2){
        randNumber = random.nextInt(2);
        while(infinite){
          if (Moves[randNumber] != PastDirection){
            return Moves[randNumber] ;
          }
          else{
             randNumber = random.nextInt(2);
          }
        }
      }
      else if (Moves.length == 3){
        randNumber = random.nextInt(3);
        while(true){
          if (Moves[randNumber] != PastDirection){
           return Moves[randNumber] ;
          }
          else{
             randNumber = random.nextInt(3);
          }
        }
      }
      else if (Moves.length == 4){
        randNumber = random.nextInt(4);
        while(true){
          if (Moves[randNumber] != PastDirection){
            return Moves[randNumber] ;
          }
          else{
             randNumber = random.nextInt(4);
          }
        }
      }
    return Moves[randNumber] ; // return move
  }

  // resets the ghost
   void softReset(){
       position = StartPosition;
       timer = startTimer;
       Direction = JoystickDirection.idle;
       PastDirection = JoystickDirection.idle;
       currentPossibleMoves = LeftRight;
       start = true;
   }


 @override
  void update(double dt) {
    super.update(dt); //player movement
    if (timer > 0) timer--; // if timer is greater than 0, decrement
    if (timer == 0){ // if timer is 0
      position = Vector2(495, 304.059 ); // spawn ghost
      timer--; // decrement
      wallCollision = false; // wall collision to false
      collided = false; // collided to false
    }
    if (timer < 0 && (newMove == true || start)){ // if timer is < 0 and time to move
        start = false;
        MovDirection = ChoosePath(currentPossibleMoves); // chooses direciton
        if (MovDirection == JoystickDirection.up){
          currentPossibleMoves = DownUp;
          currentMove = Vector2(0,dt*-maxSpeed);
          position.add(currentMove);
          Direction = JoystickDirection.up;
          PastDirection = JoystickDirection.down;
        }
        else if (MovDirection == JoystickDirection.right){
          currentPossibleMoves = LeftRight;
          currentMove = Vector2(dt * maxSpeed, 0);
          position.add(currentMove);
          Direction = JoystickDirection.right;
          PastDirection = JoystickDirection.left;
        }
        else if (MovDirection == JoystickDirection.left){
          currentPossibleMoves = LeftRight;
          currentMove =Vector2(dt * -maxSpeed, 0);
          position.add(currentMove);
          Direction = JoystickDirection.left;
           PastDirection = JoystickDirection.right;
        }
        else if (MovDirection == JoystickDirection.down){
          currentPossibleMoves = DownUp;
          currentMove = Vector2(0,dt*maxSpeed);
          position.add(currentMove);
          Direction = JoystickDirection.down;
           PastDirection = JoystickDirection.up;
        }

    }
    else if (timer < 0 && wallCollision == false && collided == false){
      PassiveMove(Direction, dt); // if no new direction, passively move 
    }
  }




  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    IntersectPos= Vector2(intersectionPoints.elementAt(0)[0].toInt().toDouble(), intersectionPoints.elementAt(0)[1].toInt().toDouble()); // gets intersect
    Pos= Vector2(position[0].toInt().toDouble(), position[1].toInt().toDouble()); // gets position
    if (other is Wall && !start){ // if collided with wall, move opposite direction
      if (!collided ){
          wallCollision = true;
          collided = true;
          if (intersectionPoints.elementAt(1)[1] < position[1] && Direction == JoystickDirection.up){   
           position[1] = intersectionPoints.elementAt(1)[1]+18;
          }
          else  if (intersectionPoints.elementAt(1)[0] < position[0] && Direction == JoystickDirection.left){   
           position[0] = intersectionPoints.elementAt(0)[0]+18; 
          }
          else  if (intersectionPoints.elementAt(1)[0] > position[0] && Direction == JoystickDirection.right){   
           position[0] = intersectionPoints.elementAt(0)[0]-18; 
          }
         else  if (intersectionPoints.elementAt(0)[1] > position[1] && Direction == JoystickDirection.down){   
           position[1] = intersectionPoints.elementAt(0)[1]-18; 
          }
          else{
            position = CurrentPosition;
          }
        }
      
    }
    // The rest of collision is for movement changes
    else if (other is UpDownrightLeft && Pos == IntersectPos&& !newMove){
       currentPossibleMoves = LeftRightDownUp;
       newMove = true;
      wallCollision = false;
    }
    else if (other is DownRight && Pos == IntersectPos&& !newMove){
      if (Direction == JoystickDirection.left || Direction == JoystickDirection.up){
        collided = true;
      }
      currentPossibleMoves = RightDown;
       newMove = true;
      wallCollision = false;
    }
    else if (other is LeftRightUp && Pos == IntersectPos&& !newMove){
      if (Direction == JoystickDirection.down){
        collided = true;
      }
       newMove = true;
      currentPossibleMoves = RightLeftUp;
      wallCollision = false;
    }
    else if (other is LeftRightDown && Pos == IntersectPos&& !newMove){
      if (Direction == JoystickDirection.up){
        collided = true;
      }
       newMove = true;
      currentPossibleMoves = RightLeftDown;
      wallCollision = false;
    }
    else if (other is UpDownLeft && Pos == IntersectPos&& !newMove){
      if (Direction == JoystickDirection.right){
        collided = true;
      }
       newMove = true;
      currentPossibleMoves = LeftDownUp;
      wallCollision = false;
    }
    else if (other is UpDownRight && Pos == IntersectPos&& !newMove){
      if (Direction == JoystickDirection.left){
        collided = true;
      }
       newMove = true;
      currentPossibleMoves = RightDownUp;
      wallCollision = false;

     }
    else if (other is DownLeft && Pos == IntersectPos&& !newMove){
      if (Direction == JoystickDirection.right || Direction == JoystickDirection.up){
        collided = true;
      }
       newMove = true;
      currentPossibleMoves = LeftDown;
      wallCollision = false;
       
    }
    else if (other is UpLeft && Pos == IntersectPos && !newMove){
      if (Direction == JoystickDirection.right || Direction == JoystickDirection.down){
        collided = true;
      }
       newMove = true;
      currentPossibleMoves = LeftUp ;
      wallCollision = false;
      
    }
    else if (other is UpRight && Pos == IntersectPos&& !newMove){
      if (Direction == JoystickDirection.left || Direction == JoystickDirection.down){
        collided = true;
      }
      newMove = true;
      currentPossibleMoves = RightUp;
      wallCollision = false;
     }
    else if (other is TeleportLeft){ // if teleport move position
      position = Vector2(80,304);
    }
    else if (other is TeleportRight){ // if teleport move position
      position = Vector2(940,304);
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
      newMove = false;
      wallCollision = false;
      collided = false;

      
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

 
