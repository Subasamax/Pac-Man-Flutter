
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';

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
}

