import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import '../model/bin.dart';
import 'package:http/http.dart' as http;

class BinPageController {
  // Method to create a user
  Future<bool> createBin({
    required String alias,
    required String id,
    required String user_id,
    required String temperature,
    required String weight,
    required String fill_level,
  }) async {
    // Create user id with auto increment
    try {
      // Get the total number of id in the users collection
      CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('bin');

      QuerySnapshot querySnapshot = await collectionReference.get();
      int numberOfDocuments = querySnapshot.size;

      if (numberOfDocuments == 0) {
        print('Collection is empty.');
        String leading = "B";
        String formattedInteger = numberOfDocuments.toString().padLeft(5, '0');
        id = "$leading${formattedInteger}1";
      } else {
        print('Collection is not empty.');
        String leading = "B";
        int idplacholder = 0;

        // Access the latest document
        QuerySnapshot latestDocument = await FirebaseFirestore.instance
            .collection('bin')
            .orderBy('id', descending: true)
            .limit(1)
            .get();

        DocumentSnapshot latestData = latestDocument.docs.first;
        Map<String, dynamic> data = latestData.data() as Map<String, dynamic>;

        String latestID = data['id'];
        print(latestID);

        // Detect integer from String id, assign to a variable,
        // Increase the variable value by 1
        // Combine with leading variable to create new ID
        RegExp regExp = RegExp(r'\d+');
        Match? match = regExp.firstMatch(latestID);

        if (match != null) {
          String numericPartString = match.group(0)!;
          idplacholder = int.parse(numericPartString) + 1;
        } else {
          print('No numeric part found in the id.');
        }

        String formattedInteger = idplacholder.toString().padLeft(5, '0');
        id = leading + formattedInteger;
      }
      // Create instance of User class and initialize its properties with values
      // passed as arguments
      final Bin bin = Bin(
        alias: alias,
        bin_id: id,
        user_id: user_id,
        temperature: temperature,
        weight: weight,
        fill_level: fill_level,
      );

      print(id);
      // Set the desired path of a collection
      final docUser = FirebaseFirestore.instance.collection('bin');
      // Convert data to Json method and write into database
      final json = bin.toJson();
      await docUser.doc(id).set(json);
      return true;
    } catch (e) {
      print('Error checking collection: $e');
      return false;
    }
  }

  Stream<List<Bin>> getBinsStream(String user_id) {
    return FirebaseFirestore.instance
        .collection('bin')
        .where('user_id', isEqualTo: user_id)
        .snapshots()
        .map((QuerySnapshot query) {
      List<Bin> bins = [];
      for (QueryDocumentSnapshot doc in query.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        bins.add(Bin.fromJson(data));
      }
      return bins;
    });
  }

  Future<void> deleteBin(String binId) async {
    try {
      await FirebaseFirestore.instance.collection('bin').doc(binId).delete();
    } catch (e) {
      print('Error deleting bin: $e');
      // Handle the error accordingly
    }
  }

  // Method to update bin alias
  Future<bool> updateBinAlias(String user_id, String newAlias, String binId) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('bin')
          .where('user_id', isEqualTo: user_id)
          .where('id', isEqualTo: binId)
          .get();

      // Update the specified field in each matching document
      for (QueryDocumentSnapshot document in querySnapshot.docs) {
        await document.reference.update({
          'alias': newAlias,
        });
      }
      print('Update successful');
      print(binId);
      return true;
    } catch (e) {
      print('Error updating bin alias: $e');
      // Handle the error accordingly
      return false;
    }
  }

  Future<String> getJsonDataT() async {
    final String urlT =
        "https://api.thingspeak.com/channels/2364486/fields/1/last.json?api_key=2WBJ4ZYNMCJCAFC0&results";
    String temperature='';
    try {
      var response = await http
          .get(Uri.parse(urlT), headers: {"Accept": "application/json"});

      if (response.statusCode == 200) {
        var convertDataToJson = jsonDecode(response.body);

        // Ensure the response contains the expected field name 'field1'
        if (convertDataToJson.containsKey('field1')) {
          temperature = convertDataToJson['field1'];
        } else {
          // Handle the case where 'field1' is not present in the response
          print("Field 'field1' not found in API response");
        }
      } else {
        // Handle HTTP error
        print("HTTP Error: ${response.statusCode}");
      }
    } catch (e) {
      // Handle other errors
      print("Error fetching data: $e");
    }
    return temperature;
  }

  Future<String> getJsonDataW() async {
    final String urlW =
        "https://api.thingspeak.com/channels/2364486/fields/2/last.json?api_key=2WBJ4ZYNMCJCAFC0&results";
    dynamic weight;
    try {
      var response = await http
          .get(Uri.parse(urlW), headers: {"Accept": "application/json"});

      if (response.statusCode == 200) {
        var convertDataToJson = jsonDecode(response.body);

        // Ensure the response contains the expected field name 'field1'
        if (convertDataToJson.containsKey('field2')) {
          weight = convertDataToJson['field2'];
        } else {
          // Handle the case where 'field1' is not present in the response
          print("Field 'field2' not found in API response");
        }
      } else {
        // Handle HTTP error
        print("HTTP Error: ${response.statusCode}");
      }
    } catch (e) {
      // Handle other errors
      print("Error fetching data: $e");
    }
    return weight;
  }

  Future<String> getJsonDataF() async {
    final String urlW =
        "https://api.thingspeak.com/channels/2364486/fields/3/last.json?api_key=2WBJ4ZYNMCJCAFC0&results";
    dynamic full;
    try {
      var response = await http
          .get(Uri.parse(urlW), headers: {"Accept": "application/json"});

      if (response.statusCode == 200) {
        var convertDataToJson = jsonDecode(response.body);

        // Ensure the response contains the expected field name 'field1'
        if (convertDataToJson.containsKey('field3')) {
          full = convertDataToJson['field3'];
        } else {
          // Handle the case where 'field1' is not present in the response
          print("Field 'field2' not found in API response");
        }
      } else {
        // Handle HTTP error
        print("HTTP Error: ${response.statusCode}");
      }
    } catch (e) {
      // Handle other errors
      print("Error fetching data: $e");
    }
    return full;
  }

  Future<void> SendNotificationTemperature() async{
    var header = {
      'Content-Type': 'application/json; charset=utf-8',
      'Authorization': 'Basic ZWE3ZTBhM2EtZGIxYy00ZDM0LThjMzMtMjRiODM0ODk2MWFj'
    };

    var request = {
      'app_id': '3ca1eddc-83b8-4c20-84da-41906c958cb6',
      'include_external_user_ids': ['playanator'],
      'headings': {'en': 'Waste Wise'},
      'contents': {'en': 'Caution: Bin temperature exceeds safe limit'}
    };

    var response = await http.post(
      Uri.parse('https://onesignal.com/api/v1/notifications'),
      headers: header,
      body: json.encode(request),
    );

    if (response.statusCode == 200) {
      print("Notification sent successfully.");
    } else {
      print("Failed to send notification. Status code: ${response.statusCode}");
    }
  }

  Future<void> SendNotificationWeight() async{
    var header = {
      'Content-Type': 'application/json; charset=utf-8',
      'Authorization': 'Basic ZWE3ZTBhM2EtZGIxYy00ZDM0LThjMzMtMjRiODM0ODk2MWFj'
    };

    var request = {
      'app_id': '3ca1eddc-83b8-4c20-84da-41906c958cb6',
      'include_external_user_ids': ['playanator'],
      'headings': {'en': 'Waste Wise'},
      'contents': {'en': 'Weight Limit Alert: Bin is too heavy.'}
    };

    var response = await http.post(
      Uri.parse('https://onesignal.com/api/v1/notifications'),
      headers: header,
      body: json.encode(request),
    );

    if (response.statusCode == 200) {
      print("Notification sent successfully.");
    } else {
      print("Failed to send notification. Status code: ${response.statusCode}");
    }
  }

  Future<void> SendNotificationFull() async{
    var header = {
      'Content-Type': 'application/json; charset=utf-8',
      'Authorization': 'Basic ZWE3ZTBhM2EtZGIxYy00ZDM0LThjMzMtMjRiODM0ODk2MWFj'
    };

    var request = {
      'app_id': '3ca1eddc-83b8-4c20-84da-41906c958cb6',
      'include_external_user_ids': ['playanator'],
      'headings': {'en': 'Waste Wise'},
      'contents': {'en': 'Full Bin Warning: Please empty the bin'}
    };

    var response = await http.post(
      Uri.parse('https://onesignal.com/api/v1/notifications'),
      headers: header,
      body: json.encode(request),
    );

    if (response.statusCode == 200) {
      print("Notification sent successfully.");
    } else {
      print("Failed to send notification. Status code: ${response.statusCode}");
    }
  }

}
