import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LEADERBOARD extends StatelessWidget {
  const LEADERBOARD({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
           mainAxisAlignment: MainAxisAlignment.spaceAround,
           crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
             const Text(
              'LEADERBOARD',
              style: TextStyle(fontSize: 50, color: Colors.yellow),
            ),
            SizedBox(
              width: 300, // <-- Your width
              height: 250, // <-- Your height
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },   // change to start game
                    style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    ), 
                    child: const Text(
                    "  BACK  ",
                    style: TextStyle(fontSize: 30, color: Colors.yellow),
                    ),
                  ),
                
                ]
              )
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

