import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pacman/Widgets/FirebaseStorage.dart';

class LEADERBOARD extends StatelessWidget {
  LEADERBOARD({super.key});
    final Fire_storage firebase = Fire_storage();
    late final Future<QuerySnapshot<Object?>?> _list;


  List<Widget> getWidgets(List<Widget> wlist, AsyncSnapshot<QuerySnapshot<Object?>?> snapshot, BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    for (int i = 0; i < snapshot.data!.docs.length; i++) {
      if (snapshot.data!.docs[i].id == 'LeaderboardSize'){
        continue;
      }
      wlist.add(Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: width/4.5, // <-- Your width
            height: 20, // <-- Your height 
            child: Center(
              widthFactor: width,
              heightFactor: height,
              child: Text(snapshot.data!.docs[i].get('DisplayName').toString()),    
            ),
          ),
          SizedBox(
            width: width/4.5, // <-- Your width
            height: 20, // <-- Your height  
             child: Center(
              widthFactor: width,
              heightFactor: height,
              child: Text(snapshot.data!.docs[i].get('Score').toString()),  
             ) 
              
          ),
          SizedBox(
              width: width/4.5, // <-- Your width
              height: 20, // <-- Your height  
               child: Center(
              widthFactor: width,
              heightFactor: height,
              child: Text(snapshot.data!.docs[i].get('Location').toString()),
              ),  
          ),
        ],
      ));
    }
    return wlist;
  }


  @override
  Widget build(BuildContext context) {
     _list = firebase.readFirebaseForm();
     List<Widget> widgetlist = []; 
    
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return  Scaffold(
      body: Center(
        child: Column(
           mainAxisAlignment: MainAxisAlignment.spaceAround,
           crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
             const Text(
              'LEADERBOARD',
              style: TextStyle(fontSize: 30, color: Colors.black),
            ),
            SizedBox(
              width: width/1.5, // <-- Your width
              height: height/2, // <-- Your height    
              child:Container(
                color: Colors.grey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                         children: [
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Text("Username",  style: TextStyle(fontSize: 20, color: Colors.yellow)),
                                  Text("Score",  style: TextStyle(fontSize: 20, color: Colors.yellow)),
                                  Text("Location",  style: TextStyle(fontSize: 20, color: Colors.yellow)),
                                ],
                              ),
                               FutureBuilder(
                                 future: _list, 
                                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Object?>?> snapshot){
                                  if(snapshot.hasData){
                                    widgetlist = getWidgets(widgetlist, snapshot, context);
                                    return Column(
                                      children: widgetlist.map((element) {
                                       return element;
                                    }).toList());
                                  }
                                  else {
                                    return const CircularProgressIndicator();
                                  }
                                }),
                            ]
                          ),
                      ]
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
    );
  }
}

