import 'package:flutter/material.dart';

class HelpCenterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help Center'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search bar
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Search for help topics',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
              SizedBox(height: 20),
              // Help categories
              Text(
                'Help Categories',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(getCategoryName(index)),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CategoryDetailsPage(
                              index + 1,
                              getSubtopics(index),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
              SizedBox(height: 20),
              // Frequently asked questions
              Text(
                'Frequently Asked Questions',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              ExpansionPanelList(
                elevation: 1,
                expandedHeaderPadding: EdgeInsets.zero,
                expansionCallback: (index, expanded) {},
                children: getFaqExpansionPanels(),
              ),
              SizedBox(height: 20),
              // Contact us
              Text(
                'Contact Us',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'For further assistance, please reach out to our support team at support@example.com.',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<ExpansionPanel> getFaqExpansionPanels() {
    return [
      _buildExpansionPanel('How do I register as a driver?', 'To register as a driver, go to the app, click on the registration button, and follow the on-screen instructions to provide your details and documents.'),
      _buildExpansionPanel('What are the vehicle requirements?', 'Yes, your vehicle must meet certain requirements such as age, model, and condition. Check the \'Vehicle Requirements\' section in your profile for details.'),
      _buildExpansionPanel('How do I update my profile information?', 'Absolutely. Navigate to the \'Profile\' section in the app, where you can edit and update your personal information, including contact details and profile picture.'),
      _buildExpansionPanel('How does the payment system work?', 'Payments are typically processed weekly. You can view your earnings and payment history in the \'Earnings\' section of the app. Make sure your payment details are accurate.'),
      _buildExpansionPanel('What should I do if I encounter technical issues with the app?', 'If you encounter technical issues, try restarting the app. If the problem persists, contact our support team through the \'Help Center\' for prompt assistance.'),
      _buildExpansionPanel('How can I view my ride history?', 'Your ride history can be accessed in the \'History\' or \'Trips\' section of the app. It provides a detailed overview of your completed trips.'),
      _buildExpansionPanel('What safety measures are in place for drivers?', 'We prioritize safety. Our app includes features such as trip tracking, emergency assistance, and a two-way rating system to maintain a secure environment for drivers.'),
      _buildExpansionPanel('Can I drive in multiple cities or regions?', 'Depending on our service availability, you may have the flexibility to drive in multiple cities. Check the \'Drive Zones\' section for details on where you can operate.'),
    ];
  }

  ExpansionPanel _buildExpansionPanel(String question, String answer) {
    return ExpansionPanel(
      headerBuilder: (context, isExpanded) {
        return ListTile(
          title: Text(question),
        );
      },
      body: ListTile(
        title: Text(answer),
      ),
      isExpanded: false,
    );
  }

  String getCategoryName(int index) {
    switch (index) {
      case 0:
        return 'Account and Registration';
      case 1:
        return 'Vehicle Information';
      case 2:
        return 'Payment and Earnings';
      case 3:
        return 'App Usage and Technical Support';
      case 4:
        return 'Safety and Security';
      default:
        return 'Category ${index + 1}';
    }
  }

  List<String> getSubtopics(int index) {
    switch (index) {
      case 0:
        return [
          'How do I register as a driver?',
          'Account verification process.',
          'Updating and managing profile information.',
          'Resolving login issues.',
        ];
      case 1:
        return [
          'Vehicle registration and approval process.',
          'Understanding and meeting vehicle requirements.',
          'Updating vehicle details.',
          'Vehicle inspection and maintenance guidelines.',
        ];
      case 2:
        return [
          'Payment processing and schedule.',
          'Viewing and understanding earnings.',
          'Managing payment methods.',
          'Handling payment-related issues.',
        ];
      case 3:
        return [
          'Navigating the driver app.',
          'Troubleshooting technical issues.',
          'App feature explanations.',
          'Reporting bugs or glitches.',
        ];
      case 4:
        return [
          'Safety measures during rides.',
          'Emergency procedures.',
          'Two-way rating system.',
          'Reporting safety concerns or incidents.',
        ];
      default:
        return [];
    }
  }
}

class CategoryDetailsPage extends StatelessWidget {
  final int categoryIndex;
  final List<String> subtopics;

  CategoryDetailsPage(this.categoryIndex, this.subtopics);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Category $categoryIndex Details'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Subtopics:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          ListView.builder(
            shrinkWrap: true,
            itemCount: subtopics.length,
            itemBuilder: (context, index) {
              return ExpansionTile(
                title: Text(subtopics[index]),
                subtitle: Text('Q: ${subtopics[index]}\nA: Placeholder answer'),
                children: [
                  ListTile(
                    title: Text('Placeholder answer goes here'),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HelpCenterPage(),
    );
  }
}
