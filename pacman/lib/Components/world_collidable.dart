import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/widgets.dart';
import 'package:flame/flame.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:tiled/tiled.dart';
 /*
 class WorldCollidable extends PositionComponent{
   WorldCollidable() {
     add(RectangleHitbox());
   }
   late TiledComponent mapComponent;
   @override
     Future<void> onLoad() async {
     mapComponent = await TiledComponent.load('map.tmx', Vector2.all(16));
     add(mapComponent);
  }

 }
 */