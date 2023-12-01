import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pacman/pac_man_game.dart';

// ignore: camel_case_types
class SaveScore_UI extends StatelessWidget {
   SaveScore_UI( this.gameref, {super.key});
  final PacMan gameref;
  static const String overlay_GameOver = 'GameOver';
  static const String overlay_SaveScore = 'SaveScore';
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _fireControler = TextEditingController();
  @override
    Widget build(BuildContext context) {
     double width = MediaQuery.of(context).size.width;
     double height = MediaQuery.of(context).size.height;
    
         return  Center(
          widthFactor: width/4,
          heightFactor: height/2,
          child: Container(
                width: width/1.5,
                height: height/2,
                color: Colors.white,
                child: Scaffold (
                  backgroundColor: Colors.black87,
                  body:  Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                    Row(
                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Score: ',
                           style: TextStyle(fontSize: 30, color: Colors.red, decoration: TextDecoration.none),
                        ),
                        Text(
                          gameref.Score.toString(),
                          style: const TextStyle(fontSize: 25, color: Colors.yellow, decoration: TextDecoration.none),
                        )
                      ],
                    ),
                    Row(
                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Display Name: ',
                          style: TextStyle(fontSize: 30, color: Colors.red, decoration: TextDecoration.none),
                        ),
                        SizedBox(
                           width: width/4, // <-- Your width
                          height: height/10, // <-- Your height
                          child: TextField(
                            inputFormatters: <TextInputFormatter>[
                                 FilteringTextInputFormatter.allow(RegExp("[a-z0-9]", caseSensitive: false)),
                                 LengthLimitingTextInputFormatter(25),
                            ],
                            controller: _fireControler,
                            decoration: const InputDecoration(
                              fillColor: Colors.white,
                              focusColor: Colors.white,
                              filled: true,
                              border:OutlineInputBorder(),
                              hintText: "Enter Display Name")
                          ),
                        )
                        //ElevatedButton(onPressed: , child: const Text("Update ")),
                      ]
                    ),
                     SizedBox(
                        width: width/1.5, // <-- Your width
                        height: height/7, // <-- Your height
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            ElevatedButton(
                              onPressed: (){
                               gameref.overlays.remove(overlay_SaveScore);
                               gameref.overlays.add(overlay_GameOver);
                              },   // change to start game
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                              ), 
                              child: const Text(
                                "  CLOSE  ",
                                style: TextStyle(fontSize: 30, color: Colors.yellow),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: (){
                                // Get data and save
                                gameref.overlays.remove(overlay_SaveScore);
                                gameref.overlays.add(overlay_GameOver);
                              },   // change to start game
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                              ), 
                              child: const Text(
                                "  SAVE  ",
                                style: TextStyle(fontSize: 30, color: Colors.yellow),
                              ),
                            ),
                        
                          ]
                       )
                     ),
                  ]
                ),
              )  
                )
               
            )
         );
        
        
         
       
    }
}
  
      