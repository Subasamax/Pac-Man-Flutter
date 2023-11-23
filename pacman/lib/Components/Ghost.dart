
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
import 'package:pacman/Components/TeleportLeft.dart';
import 'package:pacman/Components/TeleportRight.dart';
import 'dart:math';
import 'package:pacman/Components/Wall.dart';

class Ghost extends SpriteComponent  with CollisionCallbacks, HasGameRef {
Ghost(this.ghost);


  // 304.059 y
  //TiledComponent map;
  int ghost;
  double maxSpeed = 60.0;
  int timer = 0;
  Vector2 currentMove = Vector2(0,0);
  Vector2 CurrentPosition = Vector2(0,0);

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
    JoystickDirection MovDirection = JoystickDirection.idle;
  JoystickDirection Direction = JoystickDirection.idle;
  JoystickDirection PastDirection = JoystickDirection.idle;
  Vector2 IntersectPos = Vector2(0, 0);
  Vector2 Pos = Vector2(0, 0);
  bool collided = false;
  var wallCollision = false;
  bool start = true;
  bool infinite = true;
  bool newMove = false;
  int randNumber = 0;
  Random random = Random();
 



@override
 Future<void> onLoad() async {
    await super.onLoad();
    if (ghost == 1){
       sprite = await gameRef.loadSprite("Red_Ghost.png")..srcSize = Vector2.all(32);
       timer = 50;
       position = Vector2(500, 345);
       size =  Vector2.all(24);
       anchor = Anchor.center;
    }
    else if (ghost == 2){
       sprite = await gameRef.loadSprite("Blue_Ghost.png")..srcSize = Vector2.all(32);
       timer = 100;
        position = Vector2(500, 345);
       size =  Vector2.all(24);
       anchor = Anchor.center;
    }
    else if (ghost == 3){
      sprite = await gameRef.loadSprite("Orange_Ghost.png")..srcSize = Vector2.all(32);
      timer = 150;
       position = Vector2(500, 345);
       size =  Vector2.all(24);
       anchor = Anchor.center;
    }
    else if (ghost == 4){
      sprite = await gameRef.loadSprite("Pink_Ghost.png")..srcSize = Vector2.all(32);
      timer = 200;
       position = Vector2(500, 345);
       size =  Vector2.all(24);
       anchor = Anchor.center;
    }
    


   add(RectangleHitbox());
   add(RectangleHitbox(
    position: Vector2(12,12),
    size: Vector2.all(1),
    anchor: Anchor.center,
    isSolid: true
    ));
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
 }

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
    return Moves[randNumber] ;
  }


 @override
  void update(double dt) {
    super.update(dt); //player movement
    if (timer > 0) timer--;
    if (timer == 0){
      position = Vector2(495, 304.059 );
      timer--;
      wallCollision = false;
      collided = false;
    }
    if (timer < 0 && (newMove == true || start)){
        start = false;
        MovDirection = ChoosePath(currentPossibleMoves);
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
      PassiveMove(Direction, dt);
    }
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
           position[1] = intersectionPoints.elementAt(1)[1]+16;
          }
          else  if (intersectionPoints.elementAt(1)[0] < position[0] && Direction == JoystickDirection.left){   
           position[0] = intersectionPoints.elementAt(0)[0]+16; 
          }
          else  if (intersectionPoints.elementAt(1)[0] > position[0] && Direction == JoystickDirection.right){   
           position[0] = intersectionPoints.elementAt(0)[0]-16; 
          }
         else  if (intersectionPoints.elementAt(0)[1] > position[1] && Direction == JoystickDirection.down){   
           position[1] = intersectionPoints.elementAt(0)[1]-16; 
          }
          else{
            position = CurrentPosition;
          } 
        }
      
    }
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
    else if (other is TeleportLeft){
      position = Vector2(80,304);
    }
    else if (other is TeleportRight){
      position = Vector2(940,304);
    }
  }

  // TODO 1



  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
      //collided = false;
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


      //CollidedDirection = JoystickDirection.idle;
      //CollidedDirection = JoystickDirection.idle;
    //print (collided);
    
    // TODO 2
  }
}

 
