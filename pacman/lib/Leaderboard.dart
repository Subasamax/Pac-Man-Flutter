import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LEADERBOARD extends StatelessWidget {
  const LEADERBOARD({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
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
              width: width/1.5, // <-- Your width
              height: height/2, // <-- Your height    
              child:Container(
                color: Colors.grey,
                child:const SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                             mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                               Text("Username"),
                               Text('Max'),
                            ]
                          ),
                          Column(
                             mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text("Score"),
                              Text('1002334'),
                            ]
                          ),
                          Column(
                             mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text("Location"),
                              Text('Chico'),
                            ]
                          ),
                        ],
                      )
                    ],
                  ), 
                ), 
              ) 
            ),
            Column(
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

