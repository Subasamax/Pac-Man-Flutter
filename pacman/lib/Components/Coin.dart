
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:pacman/Components/player.dart';

class Coin extends SpriteComponent with CollisionCallbacks, HasGameRef{
  Coin({required this.coin});
   TiledObject coin;
   bool valid = true;
  @override
  Future<void> onLoad() async{
    
    await super.onLoad();
    sprite = await gameRef.loadSprite("Coin.png")..srcSize = Vector2.all(32);
    position = Vector2(coin.x+7, coin.y-25);
    size =  Vector2.all(18);
    add(RectangleHitbox(size: Vector2.all(14)));
  }


@override
void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
  super.onCollision(intersectionPoints, other);
   if (other is Player ){
    other.score += 10;
    other.coinsCollected++; 
    removeFromParent();
   }

  // TODO 1
}


  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
     
    // TODO 2
  }
}

