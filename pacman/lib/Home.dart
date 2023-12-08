
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pacman/Leaderboard.dart';
import 'package:pacman/Widgets/GameOver.dart';
import 'package:pacman/Widgets/saveScore.dart';
import 'package:pacman/pac_man_game.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: 'Pacman',
      home: const MyHomePage(title: 'Pacman'),
      theme: ThemeData(scaffoldBackgroundColor: Colors.black),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  // blank function to substitute for settings
  void _incrementCounter() {
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      body: Center(
        child: Column(
           mainAxisAlignment: MainAxisAlignment.spaceAround,
           crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
             const Text(
              'PACMAN',
              style: TextStyle(fontSize: 50, color: Colors.yellow),
            ),
            SizedBox(
              width: 300, // <-- Your width
              height: 250, // <-- Your height
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context)=> GameWidget(
                          game: PacMan(context: context),
                          overlayBuilderMap: {
                            'GameOver': (BuildContext context, PacMan gameRef) {
                                return GameOver_UI(gameRef);
                            },
                            'SaveScore': (BuildContext context, PacMan gameRef) {
                                return SaveScore_UI(gameRef);
                            },
                          },
                        ))
                      );
                    },   // change to start game
                    style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    ), 
                    child: const Text(
                    "  START GAME  ",
                    style: TextStyle(fontSize: 30, color: Colors.yellow),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: (){
                       Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context)=>  LEADERBOARD())
                      );
                    },   // change to leaderboard
                    style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    ), 
                    child: const Text(
                      "LEADERBOARD",
                      style: TextStyle(fontSize: 30, color: Colors.yellow),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _incrementCounter,   // blank function for settings button
                    style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    ), 
                    child: const Text(
                      "SETTINGS",
                      style: TextStyle(fontSize: 30, color: Colors.yellow),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: (){
                     SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                    },   // Quits the game
                    style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    ), 
                    child: const Text(
                      "QUIT",
                      style: TextStyle(fontSize: 30, color: Colors.yellow),
                    ),
                  ),
                ]
              )
            ),
          ],
        ),
      ),
    );
  }
}
