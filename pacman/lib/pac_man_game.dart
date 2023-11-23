
import 'package:flame/game.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:pacman/Components/Coin.dart';
import 'package:pacman/Components/Ghost.dart';
import 'package:pacman/Components/Movement/DownLeft.dart';
import 'package:pacman/Components/Movement/DownRight.dart';
import 'package:pacman/Components/Movement/LeftRightUp.dart';
import 'package:pacman/Components/Movement/LeftRightDown.dart';
import 'package:pacman/Components/Movement/UpDownLeft.dart';
import 'package:pacman/Components/Movement/UpDownRight.dart';
import 'package:pacman/Components/Movement/UpDownRightLeft.dart';
import 'package:pacman/Components/Movement/UpLeft.dart';
import 'package:pacman/Components/Movement/UpRight.dart';
import 'package:pacman/Components/TeleportLeft.dart';
import 'package:pacman/Components/TeleportRight.dart';
import 'package:pacman/Components/Wall.dart';
import 'package:pacman/Components/player.dart';
import 'package:flame/components.dart';
import 'package:flame/palette.dart';

class PacMan extends FlameGame with HasCollisionDetection {
  late final JoystickComponent joystick;
  //late TiledComponent mapComponent;
  late final CameraComponent cameraComponent;
  @override
  late final World world;
  
  
  @override
  Future<void> onLoad() async {
    world = World();
    cameraComponent = CameraComponent.withFixedResolution(
       world: world,
       width: 1300,
       height: 600,
     );
     cameraComponent.viewfinder.anchor = Anchor.topLeft;
     //cameraComponent.viewport = FixedResolutionViewport(resolution: Vector2(1200, 600));
     addAll([world, cameraComponent]);

    var mapComponent = await TiledComponent.load('map.tmx', Vector2(32, 32));
    await world.add(mapComponent);
      List<TiledObject> coins =  mapComponent.tileMap.getLayer<ObjectGroup>("Coins")!.objects;
     for (var coinObject in coins){ 
       world.add(Coin(coin: coinObject));
     }
    world.add(Wall(mapComponent));
    world.add(UpDownrightLeft(mapComponent));
    world.add(DownRight(mapComponent));
    world.add(DownLeft(mapComponent));
    world.add(LeftRightUp(mapComponent));
    world.add(UpDownLeft(mapComponent));
    world.add(UpDownRight(mapComponent));
    world.add(LeftRightDown(mapComponent));
    world.add(UpLeft(mapComponent));
    world.add(UpRight(mapComponent));
    world.add(Ghost(1));
    world.add(Ghost(2));
    world.add(Ghost(3));
    world.add(Ghost(4));
    world.add(TeleportLeft(mapComponent));
    world.add(TeleportRight(mapComponent));
    print("got it");
    final knobPaint = BasicPalette.blue.withAlpha(200).paint();
    final backgroundPaint = BasicPalette.blue.withAlpha(100).paint();
    joystick = JoystickComponent(
       size: 300,
       position: Vector2(1150, 400),
       knob: CircleComponent(radius: 40, paint: knobPaint),
       background: CircleComponent(radius: 80, paint: backgroundPaint),
    );
    final Player player = Player(joystick, mapComponent);
    await world.add(player);
    await world.add(joystick);
  }
}
