import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mockapp/Driver/Pages/home.dart';
import 'package:mockapp/main.dart';
import 'package:mockapp/Driver/Pages/login.dart';
import 'package:mockapp/user/view/user_login.dart';
class IntroPage extends StatelessWidget {
  const IntroPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // logo
            Padding(
              padding: const EdgeInsets.only(
                left: 75.0,
                right: 75.0,
                top: 50.0,
                bottom: 50.0,
              ),
              child: Image.asset('assets/intro.jpg'),
            ),

            // description
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'WASTE WISE',
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // subtitle
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'A smart waste collection system for a cleaner, efficient future.',
                textAlign: TextAlign.center,
                style: GoogleFonts.raleway(fontSize: 20),
              ),
            ),

            const SizedBox(height: 24),

            const Spacer(),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // User button
                GestureDetector(
                  onTap: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        // Replace with UserLoginPage if available
                        return LoginPage(); // Replace with UserLoginPage();
                      },
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.lightGreen,
                    ),
                    child: Text(
                      "User",
                      style: GoogleFonts.montserrat(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                // Spacer between buttons
                SizedBox(width: 20),

                // Driver button
                GestureDetector(
                  onTap: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return DLoginPage();
                      },
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.lightGreen, // Set both buttons to green
                    ),
                    child: Text(
                      "Driver",
                      style: GoogleFonts.montserrat(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const Spacer(),
          ],
        ),
      ),
    );
  }
}
