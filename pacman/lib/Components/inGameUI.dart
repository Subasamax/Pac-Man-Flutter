

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class inGameUI extends TextComponent with HasGameRef {

  int Score = 0;
  int lives = 3;
  int level = 1;

    final ScoreRend = TextPaint(
    style:  const TextStyle(
          color: Colors.yellow,
          fontSize: 30
        ),
        
  );
  final numberText = TextPaint(
    style:  const TextStyle(
          color: Colors.white,
          fontSize: 30
        ),
        
  );



  late TextComponent ScoreText = TextComponent(
      text: Score.toString(),
      position: Vector2(1110,10),
      textRenderer: ScoreRend
    );

    late TextComponent Life = TextComponent(
      text: lives.toString(),
      position: Vector2(1110,50),
      textRenderer: numberText
    );
     late TextComponent Level = TextComponent(
      text: level.toString(),
      position: Vector2(1110,90),
      textRenderer: numberText
    );

  @override
 Future<void> onLoad() async {
    add(TextComponent(
      text: "Score: ",
      position: Vector2(1020,10),
      textRenderer: TextPaint(
      style:  const TextStyle(
          color: Colors.yellow,
          fontSize: 30
        ),
    )));
     add(ScoreText);

      add(TextComponent(
      text:"Lives: ",
      position: Vector2(1020,50),
      textRenderer: TextPaint(
      style:  const TextStyle(
          color: Colors.red,
          fontSize: 30
        ),
    )));
    add(Life);
     add(TextComponent(
      text:"Level: ",
      position: Vector2(1020,90),
      textRenderer: TextPaint(
      style:  const TextStyle(
          color: Colors.green,
          fontSize: 30
        ),
    )));
    add(Level);

  }



  @override
  void update(double dt) {
    Life.text = lives.toString();
    ScoreText.text = Score.toString();
    Level.text = level.toString();
  }
}