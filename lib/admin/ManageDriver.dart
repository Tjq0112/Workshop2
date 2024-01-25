import 'package:mockapp/admin/model/driver1.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'Driver.dart';
import 'Fixed.dart';
import 'Login.dart';
import 'Schedule.dart';
import 'Setting.dart';
import 'package:mockapp/pages/map_page.dart';
class ManageDriver extends StatefulWidget {
  final String username;
  final String password;

  ManageDriver({required this.username, required this.password});

  @override
  State<ManageDriver> createState() => _ManageDriverState(username, password);
}

class _ManageDriverState extends State<ManageDriver> {
  String username;
  String password;

  _ManageDriverState(this.username, this.password);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Center(
            child: const Text('Manage Driver', style: TextStyle(fontSize: 50),)),
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
            child: StreamBuilder<List<Driver1>>(
                stream: readDriver(),
                builder: (context,snapshot) {
                  if (snapshot.hasError) {
                    return Text("Something went wrong! ${snapshot.error}");
                  }
                  else if (snapshot.hasData) {
                    final drivers = snapshot.data!;

                    return Container(
                      height: 500,
                      child: ListView(
                        children: drivers.map(buildDriver).toList()
                      ),
                    );
                  }
                  else if(!snapshot.hasData){
                    return Text("no data");
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
            ),
          )
        ],
      ),
    );
  }

  Stream<List<Driver1>> readDriver() =>
      FirebaseFirestore.instance
          .collection('Driver')
          .snapshots()
          .map((snapshot) =>
          snapshot.docs.map((doc) => Driver1.fromJson(doc.data())).toList());

  Widget buildDriver(Driver1 driver1){
    return ListTile(
      title: Text("${driver1.id}"),
      subtitle: Text("${driver1.d_name}"),
      trailing: IconButton(

          onPressed: (){
            if(driver1.d_active == true){
              setState(() {
                bool active = !driver1.d_active;
                final editDriver = FirebaseFirestore.instance.collection('Driver').doc(driver1.id);
                editDriver.update({'active' : active});
              });
            }
            else if(driver1.d_active == false){
              setState(() {
                bool active = !driver1.d_active;
                final editDriver = FirebaseFirestore.instance.collection('Driver').doc(driver1.id);
                editDriver.update({'active' : active});
              });
            }
          },
          icon: driver1.d_active ? Icon(Icons.check_circle) : Icon(Icons.check_circle_outline)),
        shape: Border(
          top: BorderSide(),
          bottom: BorderSide(),
          left: BorderSide(),
          right: BorderSide()
        ),
    );
  }
}
