import 'package:mockapp/admin/model/Pickup.dart';
import 'package:mockapp/admin/model/Schedule1.dart';
import 'package:mockapp/admin/model/driver1.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:mockapp/admin/model/bin.dart';
import 'Driver.dart';
import 'Fixed.dart';
import 'Login.dart';
import 'ManageDriver.dart';
import 'Setting.dart';
import 'package:mockapp/pages/map_page.dart';
class Schedule extends StatefulWidget {
  final String username;
  final String password;

  Schedule({required this.username, required this.password});

  @override
  State<Schedule> createState() => _ScheduleState(username, password);
}

class _ScheduleState extends State<Schedule> {
  DateTime dates = DateTime(2023, 12, 18);
  String date1 = "2023-12-18";
  final TextEditingController dateController = TextEditingController();
  String username;
  String password;
  final TextEditingController sequenceController = TextEditingController();
  final TextEditingController driverController = TextEditingController();
  _ScheduleState(this.username,this.password);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: new Center(
              child: const Text('Schedule', style: TextStyle(fontSize: 50),)),
          automaticallyImplyLeading: false,
        ),
        body:
        Column(
          children: <Widget>[
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

            /*Padding(
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
                    ),),
                  ElevatedButton(
                      onPressed: () async {
                        DateTime? newDate = await showDatePicker(
                            context: context,
                            initialDate: dates,
                            firstDate: DateTime(2023),
                            lastDate: DateTime(2100)
                        );

                        if (newDate == null) return;

                        else
                          setState(() {
                            String weekday = " ";
                            if(dates.weekday == 1)
                              weekday = "Monday";
                            else if(dates.weekday == 1)
                              weekday = "Tuesday";
                            dates = newDate;
                            date1 = dateController.text =
                            "${dates.year} - ${dates.month} - ${dates.day}";


                          });
                        /*StreamBuilder<List<bin>>(
                          stream: readBin(newDate.toString()),
                          builder: (context,snapshot) {
                            if (snapshot.hasError) {
                              return Text("Something went wrong! ${snapshot.error}");
                            }
                            else if (snapshot.hasData) {
                              final bins = snapshot.data!;

                              return  Container(
                                height: 400,

                                child: ListView(
                                  children: bins.map(buildbin).toList(),
                                ),
                              );
                            } else if(!snapshot.hasData){
                              return Text("no data");
                            } else {
                              return Center(child: CircularProgressIndicator());
                            }
                          },
                        );*/

                      },
                      child: Icon(Icons.calendar_today)
                  ),
                  /*Padding(
                      padding: EdgeInsets.all(8.0),
                    child: StreamBuilder<List<Driver1>>(
                      stream: readDriver(),
                      builder: (context,snapshot) {
                        if (snapshot.hasError) {
                          return Text("Something went wrong! ${snapshot.error}");
                        }
                        else if (snapshot.hasData) {
                          final drivers = snapshot.data!;
                          List<Driver1> driver= drivers.toList();
                          Driver1? selectedItem = driver[0];
                          //return drivers.map(buildDriver).toList();
                          return Container(
                            child: ListView.builder(
                                itemCount: driver.length,
                                itemBuilder: (context, index){
                                  final item = driver[index];

                                  return DropdownButton<Driver1>(
                                      value: selectedItem,
                                      items: driver.map((item) => DropdownMenuItem(
                                        child: Text(item.d_name),
                                      ))
                                      onChanged: onChanged
                                  ),
                                }
                            )

                          )
                        }
                        else if(!snapshot.hasData){
                          return Text("no data");
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      },
                    ),
                  )*/

                ],
              ),
            ),*/
            Column(
              children: [
                Text("Click on the list tile to assign driver.")
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: StreamBuilder<List<Pickup>>(
                stream: readPickup(date1),
                builder: (context,snapshot) {
                  if (snapshot.hasError) {
                    return Text("Something went wrong! ${snapshot.error}");
                  }
                  else if (snapshot.hasData) {
                    final pickups = snapshot.data!;

                    return Container(
                      height: 400,

                      child: ListView(
                        children: pickups.map(buildPickup).toList(),
                      ),
                    );
                  } else if(!snapshot.hasData){
                    return Text("no data");
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              )
            ),
          ],

        )
    );
  }
  /*Widget buildDriver(Driver1 driver){
    return DropdownMenu<Driver1>(
        dropdownMenuEntries: driver.d_name,
    );
  }*/

  Widget buildPickup(Pickup pickup){
        return ListTile(
          title: Text("${pickup.id}"),
          subtitle: Text("${pickup.date}"),

          onTap: (){
            driverController.text = pickup.driver_Id;
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("Assign to : "),
                  content: TextField(
                    controller: driverController,
                    decoration: const InputDecoration(
                      labelText: 'Driver Id',
                    ),
                  ),
                  actions: [
                    TextButton(
                        onPressed: (){
                          String driver_Id = driverController.text;
                          final editSequence = FirebaseFirestore.instance.collection('Schedule').doc(pickup.id);
                          editSequence.update({'driver_Id' : driver_Id});
                          Text(pickup.id);
                          const snackBar = SnackBar(
                            content: Text("Successfully assigned to driver"),
                          );

                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        },
                        child: Text("Save")
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'Cancel'),
                      child: const Text('Cancel'),
                    ),
                  ],
                )
            );
          },
          shape: Border(
              top: BorderSide(),
              bottom: BorderSide(),
              left: BorderSide(),
              right: BorderSide()
          ),
        );

  }

  Stream<List<Schedule1>> readSchedule(String a) =>
      FirebaseFirestore.instance
          .collection('Schedule').where('date', isEqualTo: a)
          .snapshots()
          .map((snapshot) =>
            snapshot.docs.map((doc) => Schedule1.fromJson(doc.data())).toList());

  Stream<List<Pickup>> readPickup(String a) =>
      FirebaseFirestore.instance
          .collection('Schedule').where('status', isEqualTo: false)
          .snapshots()
          .map((snapshot) =>
          snapshot.docs.map((doc) => Pickup.fromJson(doc.data())).toList());

  Stream<List<Driver1>> readDriver() =>
      FirebaseFirestore.instance
          .collection('Driver').where('active', isEqualTo: true)
          .snapshots()
          .map((snapshot) =>
          snapshot.docs.map((doc) => Driver1.fromJson(doc.data())).toList());



}

/*enum DriverList{
  StreamBuilder<List<Driver1>>(
    stream: readDriver(),
    builder: (context,snapshot) {
      /*if (snapshot.hasError) {
        return Text("Something went wrong! ${snapshot.error}");
      }
      else if (snapshot.hasData) {*/
        final drivers = snapshot.data!;
        List<Driver1> driver= drivers.toList();
        final item = driver[index];
        return item;
      /*}
      else if(!snapshot.hasData){
        return Text("no data");
      } else {
        return Center(child: CircularProgressIndicator());
      }*/
    },
  ),

  Stream<List<Driver1>> readDriver() =>
    FirebaseFirestore.instance
        .collection('Driver').where('active', isEqualTo: true)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => Driver1.fromJson(doc.data())).toList());

}*/

