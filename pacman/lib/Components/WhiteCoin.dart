
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:pacman/Components/player.dart';

class WhiteCoin extends SpriteComponent with CollisionCallbacks, HasGameRef{
  WhiteCoin({required this.coin});
   TiledObject coin;
   bool valid = true;
  @override
  Future<void> onLoad() async{
    await super.onLoad();
    sprite = await gameRef.loadSprite("White_Coin.png")..srcSize = Vector2.all(32);
    position = Vector2(coin.x+7, coin.y-25);
    size =  Vector2.all(18);
    add(RectangleHitbox(size: Vector2.all(14)));
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
  super.onCollision(intersectionPoints, other);
   if (other is Player ){ // if collision with player
    other.Invincible = true; // sets player invincible
    other.Inviincible_Timer = 400; // sets player timer
    other.maxSpeed = 75; // sets player maxspeed
    other.score += 50; // sets player score
    other.coinsCollected++; // increments coins collected
    other.swapAnimations();  // swaps their animations
    removeFromParent();   // deletes from world
   }
}
}




