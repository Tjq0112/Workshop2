import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mockapp/user/view/homepage.dart';
import 'package:mockapp/user/view/user_register.dart';
import '../controller/user_controller.dart';

// TODO: - Write status data into database
// TODO: - Reset password for user if rajin
// TODO: - Notify user when bin has picked up by driver (hardest)
// TODO: - Delete bin should affect schedule ??

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final UserPageController _loginController = UserPageController();

  String errorMessage = '';
  String loginId = '';
  bool loginStatus = false;
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.lightGreen.shade100,
      appBar: AppBar(
          title: Image.asset('assets/wastewise.png', height: 45)
      ),

      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 75.0,
                    right: 75.0,
                    top: 50.0,
                    bottom: 50.0,
                  ),
                  child: Image.asset('assets/logo.jpg'),
                ),
                const SizedBox(height: 50),
                Text(
                  'Welcome back, you\'ve been missed!',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 25),
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
                const SizedBox(height: 10),
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
                const SizedBox(height: 5),
                Text(
                  errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 5),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightGreen.shade100,
                  ),
                  onPressed: () async {
                    // Validate username and password
                    if (usernameController.text.isEmpty ||
                        passwordController.text.isEmpty) {
                      setState(() {
                        errorMessage = 'Username and password cannot be empty.';
                      });
                      return;
                    }

                    // Clear any previous error message
                    setState(() {
                      errorMessage = '';
                    });

                    // Attempt to log in
                    loginStatus = await _loginController.loginUser(
                      username: usernameController.text,
                      password: passwordController.text,
                    );

                    if (loginStatus == true) {
                      loginId = await _loginController.getUserLoginId(
                          username: usernameController.text,
                          password: passwordController.text);

                      if (loginId.length == 6) {
                        // Navigate to HomePage
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomePage(loginId: loginId)),
                        );
                      } else {}
                    } else {
                      setState(() {
                        errorMessage = 'Login Failed';
                      });
                    }
                  },
                  child: Text('Login',
                      style: TextStyle(
                        color: Colors.black,
                      )),
                ),
                GestureDetector(
                  onTap: () {
                    // nanti ubah page
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UserRegisterView()));
                  },
                  child: Text(
                    "Forgot Password? Reset here.",
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UserRegisterView()));
                  },
                  child: Text(
                    "Don't have an account? Register here.",
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
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
