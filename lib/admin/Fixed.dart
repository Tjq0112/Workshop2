import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../pages/map_page.dart';
//import '../pages/schedule.dart';
import 'Driver.dart';
import 'Login.dart';
import 'ManageDriver.dart';
import 'Schedule.dart';
import 'Setting.dart';
import 'model/Pickup.dart';

class Fixed extends StatefulWidget {
  final String username;
  final String password;

  Fixed({required this.username, required this.password});

  @override
  State<Fixed> createState() => _FixedState(username, password);
}

class _FixedState extends State<Fixed> {
  String username;
  String password;
  DateTime dates = DateTime(2024, 1, 1);
  String date1 = "date havent choose";
  DateTime? newDate;
  final TextEditingController dateController = TextEditingController();
  final TextEditingController driverController = TextEditingController();

  _FixedState(this.username, this.password);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Center(
            child: const Text('Fixed Schedule', style: TextStyle(fontSize: 50),)),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Expanded(
                child: MenuBar(
                  children: <Widget>[
                    MenuItemButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Fixed(username: username,password: password)
                          ),
                        );
                      },
                      child: const MenuAcceleratorLabel('&Fixed'),
                    ),
                    MenuItemButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Schedule(username: username,password: password)
                          ),
                        );
                      },
                      child: const MenuAcceleratorLabel('&Demand'),
                    ),
                    MenuItemButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ManageDriver(username: username,password: password)
                          ),
                        );
                      },
                      child: const MenuAcceleratorLabel('&Manage Driver'),
                    ),
                    MenuItemButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Driver(username: username,password: password)
                          ),
                        );
                      },
                      child: const MenuAcceleratorLabel('&Add Driver'),
                    ),
                    MenuItemButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MapPage()), // Add this line for MapPage navigation
                        );
                      },
                      child: const MenuAcceleratorLabel('&Map'),
                    ),
                    MenuItemButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Setting(username: username,password: password)
                          ),
                        );
                      },
                      child: const MenuAcceleratorLabel('Setting'),
                    ),
                    MenuItemButton(
                      onPressed: () => showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Logout'),
                          content: const Text('Do you sure you want to logout?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginScreen()
                                  ),
                                );},
                              child: const Text('Sure'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'Cancel'),
                              child: const Text('Cancel'),
                            ),
                          ],
                        ),
                      ),
                      child: const MenuAcceleratorLabel('&Logout'),
                    ),
                  ],

                ),

              ),
            ],
          ),
          Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                  children: [
                    Container(
                      child: SizedBox(
                        height: 50.0,
                        width: 150,
                        child: TextField(
                          controller: dateController,
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: "Date",
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          DateTime? newDate = await showDatePicker(
                              context: context,
                              initialDate: dates,
                              firstDate: DateTime(2024),
                              lastDate: DateTime(2100)
                          );

                          if (newDate == null) return;

                          else if(newDate.weekday == 2 || newDate.weekday == 5){
                            setState(() {
                              dates = newDate;
                              date1 = dateController.text =
                              "${dates.year} - ${dates.month} - ${dates.day}";
                            });
                          }
                          else{
                            setState(() {
                              date1 = "(Please rechoose either tuesday or friday)";
                            });
                          }
                        },
                        child: Icon(Icons.calendar_today)
                    )
                  ]

              )
          ),
          Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text("Please select date and assign driver to selected date: ${date1}")
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(400.0,20.0,400.0,20.0),
            child: TextField(
              controller: driverController,
              decoration: const InputDecoration(
                labelText: 'Driver Id',
              ),
            ),
          ),
          ElevatedButton(
              onPressed: (){
                String driver = driverController.text;
                if(newDate != null){
                  final schedule = Pickup(
                      bin_Id: "Fixed" ,
                      date: date1,
                      status: false,
                      driver_Id: driver,
                      type: "Fixed"
                  );

                  createSchedule(schedule);
                }
                else
                {
                  const snackBar = SnackBar(
                    content: Text('Please select either Tuesday or Friday'),
                  );

                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              },
              child: const Text("Add")
          )

        ],
      ),

    );
  }
  Future createSchedule(Pickup schedule) async{
    String ids = " ";
    CollectionReference collectionReference =
    FirebaseFirestore.instance.collection('Schedule');

    QuerySnapshot querySnapshot = await collectionReference.get();
    int numberOfDocuments = querySnapshot.size;

    if (numberOfDocuments == 0) {
      print('Collection is empty.');
      String leading = "S";
      String formattedInteger = numberOfDocuments.toString().padLeft(5, '0');
      ids = "$leading${formattedInteger}1";
    } else {
      print('Collection is not empty.');
      String leading = "S";
      int idplacholder = 0;

      // Access the latest document
      QuerySnapshot latestDocument = await FirebaseFirestore.instance
          .collection('Schedule')
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
      ids = leading + formattedInteger;
      print(ids);
      schedule.id = ids;
    }
    final docDriver = FirebaseFirestore.instance.collection('Schedule').doc(schedule.id);
    final json = schedule.toJson();
    await docDriver.set(json);

    const snackBar = SnackBar(
      content: Text('Fixed Schedule Added!'),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

}