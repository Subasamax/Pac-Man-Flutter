
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pacman/Leaderboard.dart';
import 'package:pacman/Widgets/GameOver.dart';
import 'package:pacman/Widgets/saveScore.dart';
import 'package:pacman/pac_man_game.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  // This widget is the root of your application.
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

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

 

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
                    },   // change to start game
                    style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    ), 
                    child: const Text(
                      "LEADERBOARD",
                      style: TextStyle(fontSize: 30, color: Colors.yellow),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _incrementCounter,   // change to start game
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
                    },   // change to start game
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
