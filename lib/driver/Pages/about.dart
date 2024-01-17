import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Waste Wise®'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero image
            Hero(
              tag: 'aboutUsHero',
              child: Image.asset('assets/WASTE WISE.png'),
            ),
            // Section for main content
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // Headline
                  Text(
                    'Creating a Cleaner Future with Smart Waste Collection',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  // Subheading
                  SizedBox(height: 20),
                  Text(
                      'Our Story',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  // Body text
                  SizedBox(height: 20),
                  Text(
                      'We are a team of passionate individuals dedicated to transforming waste management through innovative technology.'),
                  SizedBox(height: 40),
                  Text(''
                      'Team Members',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                    SizedBox(height: 20),
                    Text('MUHD IQHWAN'),
                    SizedBox(height: 20),
                    Text('SAIFUL IMRAN'),
                    SizedBox(height: 20),
                    Text('TEOH JIAQI'),
                    SizedBox(height: 20),
                    Text('WAN MAHIRAH'),
                    SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
