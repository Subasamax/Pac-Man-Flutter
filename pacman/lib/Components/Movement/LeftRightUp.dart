
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/foundation.dart';



class LeftRightUp extends ShapeComponent with  HasGameRef, CollisionCallbacks{
  LeftRightUp( this.map);
  TiledComponent map;

   @override
  Future<void> onLoad() async {
    List<TiledObject> wall =  map.tileMap.getLayer<ObjectGroup>("ULR")!.objects;
    if (kDebugMode) {
      debugMode = true;
    }
    for (var mov in wall){
      add(RectangleHitbox(
        position: Vector2(mov.x+13.5, mov.y-18.5),
        size: Vector2.all(5),
        isSolid: true
        ));
    }  
  }
}