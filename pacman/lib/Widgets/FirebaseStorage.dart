
// ignore_for_file: non_constant_identifier_names
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pacman/firebase_options.dart';

// ignore: camel_case_types
class Fire_storage{
  bool _initialized = false;
  Future<void> initializDefault() async {
    FirebaseApp  app = await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    _initialized = true;
    if (kDebugMode) {
      print("Initialized default Firebase app $app");
    }


  }
  Fire_storage();


  Future<QuerySnapshot<Object?>> getData(FirebaseFirestore instance) async{
    
    QuerySnapshot querySnapshot = await instance.collection('Leaderboard').get();
    final scoreRef = instance.collection("Leaderboard");
    scoreRef.orderBy("Score", descending: true);
    Query query = scoreRef.orderBy("Score", descending: true);
    querySnapshot = await query.get();
    return querySnapshot;
 }

  bool get isInitialized => _initialized;
  
  Future<bool> WriteLeaderboard(String DisplayName, int Score, String Location) async {
    try {
      if (!isInitialized){
        await initializDefault();
      }
      FirebaseFirestore firestore = FirebaseFirestore.instance;
       DocumentSnapshot querySnapshot = await  firestore.collection("Leaderboard").doc("LeaderboardSize").get();
       int count = querySnapshot.get('count')+1;
       
      var data = {"DisplayName": DisplayName, "Score": Score, "Location": Location};
      var countData = {"count": count};
      await firestore.collection("Leaderboard").doc(count.toString()).set(data).then((value){
      firestore.collection("Leaderboard").doc('LeaderboardSize').set(countData);
        if (kDebugMode){
              print("Added Data for $DisplayName to Database");
            }
            return true;
          }).catchError((error){
            if (kDebugMode){
              print("Failed to set Data: $error");
            }
            return false;
          });
    }catch(e){
      if (kDebugMode) {
        print(e);
      }
    }
    return false;
  }



  Future<QuerySnapshot<Object?>?> readFirebaseForm() async{
    try{
      if (!isInitialized){
        await initializDefault();
      }
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      return getData(firestore);
    } catch(e){
      if (kDebugMode) {
        print(e);
      }

    }
    return null;
  }
  
}