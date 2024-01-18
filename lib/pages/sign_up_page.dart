import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mockapp/pages/login_page.dart'; // Import your LoginPage

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();

  String _email = "";
  String _password = "";
  String _message = "";

  void _handleSignUp() async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _email,
        password: _password,
      );
      print("User Registered: ${userCredential.user!.email}");
      _showSuccessMessage();
    } catch (e) {
      print("Error during Registration: $e");
      _showErrorMessage();
    }
  }

  void _showSuccessMessage() {
    setState(() {
      _message = "Sign up success!";
    });

    Future.delayed(Duration(seconds: 3), () {
      // Navigate back to the login page after 3 seconds
      Navigator.pop(context);
    });
  }

  void _showErrorMessage() {
    setState(() {
      _message = "Sign up not successful.";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Email",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please Enter Your Email";
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _email = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _passController,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Password",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please Enter Your Password";
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _password = value;
                    });
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _handleSignUp();
                    }
                  },
                  child: Text("Sign Up"),
                ),
                SizedBox(height: 10),
                Text(
                  _message,
                  style: TextStyle(
                    color: _message.contains("success") ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
