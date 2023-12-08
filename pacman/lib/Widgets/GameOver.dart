

// ignore_for_file: constant_identifier_names
import 'package:flutter/material.dart';
import 'package:pacman/pac_man_game.dart';

// ignore: camel_case_types
class GameOver_UI extends StatelessWidget {
  const GameOver_UI( this.gameref, {super.key});
  final PacMan gameref;
  static const String overlay_GameOver = 'GameOver';
  static const String overlay_SaveScore = 'SaveScore';
  @override
    Widget build(BuildContext context) {
     double width = MediaQuery.of(context).size.width;  // screen size
     double height = MediaQuery.of(context).size.height;  // screen size
    
         return  Center(
          widthFactor: width/2,
          heightFactor: height/2,
          child: Container(
                width: width/2,
                height: height/1.5,
                color: Colors.grey,
                child: Center(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                   const Text(
                      'Game Over',
                      style: TextStyle(fontSize: 30, color: Colors.red, decoration: TextDecoration.none),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Score: ',
                          style:  TextStyle(fontSize: 25, color: Colors.yellow, decoration: TextDecoration.none),
                        ),
                        Text(
                          gameref.Score.toString(),
                          style: const TextStyle(fontSize: 25, color: Colors.yellow, decoration: TextDecoration.none),
                        ),

                      ],
                    ),
                     SizedBox(
                        width: width/3, // <-- Your width
                        height: height/2, // <-- Your height
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            ElevatedButton(
                              onPressed: (){
                                gameref.overlays.remove(overlay_GameOver);
                                gameref.overlays.add(overlay_SaveScore);
                              },   // changte to save score screen
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                              ), 
                              child: const Text(
                                "  Save Score  ",
                                style: TextStyle(fontSize: 25, color: Colors.yellow),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: (){
                                gameref.resumeEngine();
                                gameref.overlays.remove(overlay_GameOver);
                              },   // change to game again
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                              ), 
                              child: const Text(
                                "  Restart  ",
                                style: TextStyle(fontSize: 25, color: Colors.yellow),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: (){
                                Navigator.pop(context);
                              },   // change to main menu
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                              ), 
                              child: const Text(
                                "Main Menu",
                                style: TextStyle(fontSize: 25, color: Colors.yellow),
                              ),
                            ),
                          ]
                       )
                     ),
                  ]
                ),
              )  
            )
          ) ; 
    }
}
  
      