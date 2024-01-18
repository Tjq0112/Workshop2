import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'Menu.dart';
import 'model/admin.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();

}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isSecuredPassword = true;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<admin>>(
      stream: readAdmin(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong! ${snapshot.error}");
        }
        else if (snapshot.hasData) {
          final admins = snapshot.data!;

          return _login(context, admins);
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
    Widget _login(BuildContext context, List<admin> admins) {
      //final record = Record.fromSnapshot(data as DocumentSnapshot<Object?>);
      return Scaffold(
        appBar: AppBar(
          title: new Center(child: const Text(
            'Login Screen', style: TextStyle(fontSize: 50),)),
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(250.0, 40.0, 250.0, 40.0),
                child: TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(250.0, 40.0, 250.0, 40.0),
                child: TextField(
                  obscureText: _isSecuredPassword,
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    suffixIcon: togglePassword(),
                  ),
                ),
              ),

              ElevatedButton(
                onPressed: () {
                  //Implement Login logic here
                  String username = usernameController.text;
                  String password = passwordController.text;
                  List<admin> admin1 = admins;
                  String username1 = " a ";
                  String password1 = " a ";
                  for(int i = 0; i < admin1.length; i++)
                    {
                      username1 = admin1[i].username;
                      password1 = admin1[i].password;
                    }
                  if (username == username1 && password == password1) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Menu(username: username,password: password),
                      ),
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Login Failed'),
                          content: const Text('Invalid username or password.'),
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
                child: const Text('login'),
              ),

            ],
          ),
        ),
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

  Stream<List<admin>> readAdmin() =>
      FirebaseFirestore.instance
          .collection('Admin')
          .snapshots()
          .map((snapshot) =>
          snapshot.docs.map((doc) => admin.fromJson(doc.data())).toList());

