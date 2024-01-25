import 'package:mockapp/admin/model/driver1.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'Fixed.dart';
import 'Login.dart';
import 'ManageDriver.dart';
import 'Schedule.dart';
import 'Setting.dart';
import 'package:mockapp/pages/map_page.dart';
class Driver extends StatefulWidget {
  final String username;
  final String password;

  Driver({required this.username, required this.password});

  @override
  State<Driver> createState() => _DriverState(username, password);
}

class _DriverState extends State<Driver> {
  String username;
  String password;
  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController icController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  bool _isSecuredPassword = true;

  _DriverState(this.username, this.password);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: new Center(
              child: const Text('Add Driver', style: TextStyle(fontSize: 50),)),
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
            Column(
              children: [
                Text("Add new driver",style: TextStyle(
                    fontSize: 30
                ),),
                Padding(
                  padding: const EdgeInsets.fromLTRB(250.0, 20.0, 250.0, 20.0),
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Enter driver name',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(250.0, 20.0, 250.0, 20.0),
                  child: TextField(
                    controller: icController,
                    decoration: InputDecoration(
                      labelText: 'Enter driver IC',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(250.0, 20.0, 250.0, 20.0),
                  child: TextField(
                    controller: phoneNumberController,
                    decoration: InputDecoration(
                      labelText: 'Enter driver phone number',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(250.0, 20.0, 250.0, 20.0),
                  child: TextField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      labelText: 'Enter driver username',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(250.0, 20.0, 250.0, 20.0),
                  child: TextField(
                    obscureText: _isSecuredPassword,
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: 'Enter driver password',
                      suffixIcon: togglePassword(),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: (){
                          String d_name = nameController.text;
                          String d_username = usernameController.text;
                          String d_password = passwordController.text;
                          String d_icNumber = icController.text;
                          String d_phoneNumber = phoneNumberController.text;
                          bool active = true;

                          final driver = Driver1(
                              d_name: d_name,
                              d_username: d_username,
                              d_password: d_password,
                              d_icNumber: d_icNumber,
                              d_phoneNumber: d_phoneNumber,
                              d_active: active,
                          );

                          createDriver(driver);
                        },
                        child: const Text("Add")
                    ),
                  ],
                )
              ],
            )
          ],
        )
    );
  }
  Widget togglePassword(){
    return IconButton(onPressed: (){
      setState(() {
        _isSecuredPassword = !_isSecuredPassword;
      });
    }, icon: _isSecuredPassword ? Icon(Icons.visibility_off) : Icon(Icons.visibility));
  }
  
  Future createDriver(Driver1 driver) async{
    String ids = " ";
    CollectionReference collectionReference =
    FirebaseFirestore.instance.collection('Driver');

    QuerySnapshot querySnapshot = await collectionReference.get();
    int numberOfDocuments = querySnapshot.size;

    if (numberOfDocuments == 0) {
      print('Collection is empty.');
      String leading = "D";
      String formattedInteger = numberOfDocuments.toString().padLeft(5, '0');
      ids = "$leading${formattedInteger}1";
    } else {
      print('Collection is not empty.');
      String leading = "D";
      int idplacholder = 0;

      // Access the latest document
      QuerySnapshot latestDocument = await FirebaseFirestore.instance
          .collection('Driver')
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

      String formattedInteger = idplacholder.toString().padLeft(3, '0');
      ids = leading + formattedInteger;
      print(ids);
      driver.id = ids;
    }
    final docDriver = FirebaseFirestore.instance.collection('Driver').doc(driver.id);
    final json = driver.toJson();
    await docDriver.set(json);

    const snackBar = SnackBar(
      content: Text('Driver Added!'),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

}
