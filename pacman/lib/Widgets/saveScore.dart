

// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pacman/Widgets/FirebaseStorage.dart';

import 'package:pacman/pac_man_game.dart';


// ignore: camel_case_types
class SaveScore_UI extends StatefulWidget{
  const SaveScore_UI(this.gameref, {super.key});
  final PacMan gameref;
 @override
  State<SaveScore_UI> createState() => MySaveScore_UI();
}
// ignore: camel_case_types
class MySaveScore_UI extends State<SaveScore_UI> {
   MySaveScore_UI();
  late final PacMan gameref = widget.gameref;
  static const String overlay_GameOver = 'GameOver';
  static const String overlay_SaveScore = 'SaveScore';
  final TextEditingController _fireControler = TextEditingController();
  late Position _position;
  late String County = "ERROR";
  Fire_storage firebase = Fire_storage();
   bool _loading = true;




  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

  // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the 
    // App to enable the location services.
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale 
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }
  
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately. 
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
    } 

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  Future<void> _getAddressFromLatLng(Position ?position) async {
    await placemarkFromCoordinates(
      position!.latitude, position.longitude)
      .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
        setState(() {
          County = '${place.administrativeArea}, ${place.locality}';
        });
      }).catchError((e) {
        debugPrint(e);
    });
  } 

   Future<void> SaveScore_Firebase() async{
    await _determinePosition().then((position) {
      _position = position;
    });
    await _getAddressFromLatLng(_position);
    await firebase.WriteLeaderboard(_fireControler.text, gameref.Score,County);
    return;
  }


    @override
  void initState() {
      super.initState();

  }

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
                  resizeToAvoidBottomInset: false,
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
                        ),
                        //ElevatedButton(onPressed: , child: const Text("Update ")),
                        
                      ],
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
                          _loading ? ElevatedButton(
                              onPressed: () async {
                                // Get data and save
                                if (_fireControler.text.isNotEmpty){
                                     setState(() {
                                       _loading = false;
                                     });
                                     await SaveScore_Firebase();
                                      setState(() {
                                       _loading = true;
                                     });
                                     gameref.overlays.remove(overlay_SaveScore);
                                     gameref.overlays.add(overlay_GameOver);
                                } 
                              },   // change to start game
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                              ), 
                              child: const Text(
                                "  SAVE  ",
                                style: TextStyle(fontSize: 30, color: Colors.yellow),
                              ),
                            ) : const Center(child:CircularProgressIndicator()),
                        
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
  
      