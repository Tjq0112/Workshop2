import 'package:flutter/material.dart';
import '../controller/user_controller.dart';

class UserRegisterView extends StatefulWidget {
  const UserRegisterView({Key? key}) : super(key: key);

  @override
  State<UserRegisterView> createState() => _UserRegisterViewState();
}

class _UserRegisterViewState extends State<UserRegisterView> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController fullnameController = TextEditingController();
  final TextEditingController icController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final UserPageController _newUserController = UserPageController();

  String errorMessage = '';
  bool regStatus=false;
  bool obscureText=true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register New User'),
        backgroundColor: Colors.lightGreen,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: TextField(
              controller: usernameController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.lightGreen),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: 'Username',
                  fillColor: Colors.grey[200],
                  filled: true,
                  icon: Icon(Icons.person)),
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: TextField(
              controller: passwordController,
              obscureText: obscureText,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.lightGreen),
                  borderRadius: BorderRadius.circular(12),
                ),
                hintText: 'Password',
                fillColor: Colors.grey[200],
                filled: true,
                icon: Icon(Icons.lock_outline_rounded),
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      obscureText = !obscureText;
                    });
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: TextField(
              controller: fullnameController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.lightGreen),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: 'Fullname',
                  fillColor: Colors.grey[200],
                  filled: true,
                  icon: Icon(Icons.abc)),
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: TextField(
              controller: icController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.lightGreen),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: 'IC Number',
                  fillColor: Colors.grey[200],
                  filled: true,
                  icon: Icon(Icons.credit_card)),
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: TextField(
              controller: phoneNumberController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.lightGreen),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: 'Phone Number',
                  fillColor: Colors.grey[200],
                  filled: true,
                  icon: Icon(Icons.phone_android)),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              if (usernameController.text.isEmpty ||
                  passwordController.text.isEmpty
                  || fullnameController.text.isEmpty ||
                  icController.text.isEmpty ||
                  phoneNumberController.text.isEmpty) {
                setState(() {
                  errorMessage = 'All fields cannot be empty.';
                });
                return;
              }

              // Clear any previous error message
              setState(() {
                errorMessage = '';
              });

              regStatus = await _newUserController.createUser(
                username: usernameController.text,
                password: passwordController.text,
                fullname: fullnameController.text,
                ic: icController.text,
                phoneNumber: phoneNumberController.text,
                id: "",
              );

              if (regStatus == true) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Registration Successful'),
                  ),
                );
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Registration Failed'),
                  ),
                );
              }
            },
            style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                EdgeInsets.symmetric(vertical: 10, horizontal: 20), // Adjust the padding here
              ),
            ),
            child: const Text('Register'),
          ),
        ],
      ),
    );
  }
}
