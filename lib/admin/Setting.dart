import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'Driver.dart';
import 'Login.dart';
import 'ManageDriver.dart';
import 'Menu.dart';
import 'Schedule.dart';
import 'package:mockapp/pages/map_page.dart';
class Setting extends StatefulWidget {
  final String username;
  final String password;

  Setting({required this.username, required this.password});

  @override
  State<Setting> createState() => _SettingState(username,password);
}

class _SettingState extends State<Setting> {
  String username;
  String password;
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController newUsernameController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController newPasswordController1 = TextEditingController();
  bool _isSecuredPassword = true;

  _SettingState(this.username, this.password);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: new Center(
              child: const Text('Setting', style: TextStyle(fontSize: 50),)),
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
                                builder: (context) => Schedule(username: username,password: password)
                            ),
                          );
                        },
                        child: const MenuAcceleratorLabel('&Schedule'),
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
                Text("Change username or password",
                style: TextStyle(
                  fontSize: 30
                ),),

                Padding(
                  padding: const EdgeInsets.fromLTRB(250.0, 20.0, 250.0, 20.0),
                  child:
                  TextField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      labelText: "Please enter your current username",
                    ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.fromLTRB(250.0, 20.0, 250.0, 20.0),
                    child: TextField(
                      obscureText: _isSecuredPassword,
                      controller: passwordController,
                      decoration: InputDecoration(
                        labelText: "Please enter your current password",
                        suffixIcon: togglePassword(),
                      ),
                    )
                ),
                Padding(
                    padding: const EdgeInsets.fromLTRB(250.0, 20.0, 250.0, 20.0),
                    child: TextField(
                      controller: newUsernameController,
                      decoration: InputDecoration(
                        labelText: "New username",
                      ),
                    )
                ),
                Padding(
                    padding: const EdgeInsets.fromLTRB(250.0, 20.0, 250.0, 20.0),
                    child: TextField(
                      obscureText: _isSecuredPassword,
                      controller: newPasswordController,
                      decoration: InputDecoration(
                        labelText: "New password",
                        suffixIcon: togglePassword(),
                      ),
                    )
                ),
                Padding(
                    padding: const EdgeInsets.fromLTRB(250.0, 20.0, 250.0, 20.0),
                    child: TextField(
                      obscureText: _isSecuredPassword,
                      controller: newPasswordController1,
                      decoration: InputDecoration(
                        labelText: "Re-enter new password",
                        suffixIcon: togglePassword(),
                      ),
                    )
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          String username1 = usernameController.text;
                          String password1 = passwordController.text;
                          String newUsername = newUsernameController.text;
                          String newPassword = newPasswordController.text;
                          String newPassword1 = newPasswordController1.text;

                          if(username == username1 && password == password1 && newPassword == newPassword1){
                            final editAdmin = FirebaseFirestore.instance.collection('Admin').doc('A01');
                            
                            editAdmin.update({'username' : newUsername, 'password' : newPassword});

                          }else{
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Update Failed'),
                                  content: const Text('Invalid username or password or the new password are not consistent'),
                                  actions: [
                                    TextButton(
                                      child: const Text('OK'),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          }

                        },
                        child: const Text("Sure")
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Menu(username: username,password: password),
                            ),
                          );
                        },
                        child: const Text("Cancel")
                    )
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
}


