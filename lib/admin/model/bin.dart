import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class bin{
  //final String name;
  final String date;
  //final double latitude;
  //final String location_name;
  final String id;
  //final double longitude;


  //final DocumentReference reference;
  bin({
   required this.date,
    //required this.latitude,
    //required this.location_name,
    required this.id,
    //required this.longitude,

  });
  
  
  /*bin.fromMap(Map<String, dynamic> map, {required this.reference})
      : assert(map['date'] != null),
        date = map['date'],
        assert(map['latitude'] != null),
        latitude = map['date'],
        assert(map['location'] != null),
        location = map['location_name'],
        assert(map['longitude'] != null),
        longitude = map['longitude'];

  bin.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data() as Map<String, dynamic>,
      reference: snapshot.reference);*/

  //Stream<List<bin>> readBin() => FirebaseFirestore.instance.collection('bin')
      //.snapshots().map((snapshot) => snapshot.docs.map((doc) => bin.fromJson(doc.data())).toList());

  static bin fromJson(Map<String, dynamic> json) => bin(
    date: json['date'].toString(),
    //latitude : json['latitude'],
    //location_name : json["location_name"],
    //longitude : json['longitude'],
    id: json['id'],

  );
  @override
  String toString() => "Record<$date>";
}