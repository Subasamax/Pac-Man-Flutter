



import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/foundation.dart';

class TeleportLeft extends ShapeComponent with  HasGameRef, CollisionCallbacks{
  TeleportLeft( this.map);
  TiledComponent map;
  
  @override
  Future<void> onLoad() async {
    List<TiledObject> wall =  map.tileMap.getLayer<ObjectGroup>("TPL")!.objects;
    if (kDebugMode) {
      debugMode = true;
    }
    for (var wallObject in wall){
      add(RectangleHitbox(
        position: Vector2(wallObject.x, wallObject.y-32),
        size: Vector2(wallObject.width,wallObject.height),
        isSolid: true
        ));
    }  
  }
}