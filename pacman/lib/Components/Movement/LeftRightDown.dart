
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/foundation.dart';



class LeftRightDown extends ShapeComponent with  HasGameRef, CollisionCallbacks{
  LeftRightDown( this.map);
  TiledComponent map;

   @override
  Future<void> onLoad() async {
    List<TiledObject> wall =  map.tileMap.getLayer<ObjectGroup>("DLR")!.objects;
    if (kDebugMode) {
      debugMode = true;
    }
    for (var mov in wall){
      add(RectangleHitbox(
        position: Vector2(mov.x+16, mov.y-16),
        size: Vector2.all(1),
        isSolid: true
        ));
    }  
  }
}