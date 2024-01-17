import 'package:flutter/material.dart';
import 'package:mockapp/user/controller/user_controller.dart';
import 'package:mockapp/user/view/settings.dart';

class UpdatePrivacyPage extends StatefulWidget {
  final String loginId;
  const UpdatePrivacyPage({Key? key, required this.loginId}) : super(key: key);

  @override
  State<UpdatePrivacyPage> createState() => _UpdatePrivacyPage();
}

class _UpdatePrivacyPage extends State<UpdatePrivacyPage> {
  UserPageController _userPageController = UserPageController();

  String username = '';
  String password = '';
  bool update = false;

  List<String> userPrivacy = [];

  // Instance variables to hold values from _showEditDialog
  late String editedUsername='';
  late String editedPassword='';

  Future<void> details() async {
    userPrivacy = await _userPageController.getUserDetails(user_id: widget.loginId);

    // Set initial values for fullname, ic, and phoneNumber
    setState(() {
      username = userPrivacy.isNotEmpty ? userPrivacy[3] : '';
      password = userPrivacy.isNotEmpty ? userPrivacy[4] : '';
    });
  }

  @override
  void initState() {
    super.initState();

    details();

  }

  Future<void> _showEditDialog(String label, String currentValue) async {
    TextEditingController controller = TextEditingController(text: currentValue);
    TextInputType keyboardType = TextInputType.text; // Default to a text keyboard

    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit $label'),
          content: TextField(
            controller: controller,
            keyboardType: keyboardType, // Set the keyboard type
            decoration: InputDecoration(labelText: label),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                // Update the respective value based on the label
                setState(() {
                  if (label == 'Username') {
                    editedUsername = controller.text;
                  } else if (label == 'Password') {
                    editedPassword = controller.text;
                  }
                });
                Navigator.of(context).pop();
                setState(() {
                  // Update the values
                  username = editedUsername;
                  password = editedPassword;
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Waste'),
        backgroundColor: Colors.lightGreen,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          buildEditableCard("Username", username),
          buildEditableCard("Password", password),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  update = await _userPageController.updatePrivacy(
                      widget.loginId, username, password);

                  if (update == true) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Privacy Updated'),
                      ),
                    );
                    Navigator.of(context).pop(SettingsPage(loginId: widget.loginId));
                  }
                },
                child: const Text('Update Privacy Settings'),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget buildEditableCard(String title, String value) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        // Add left and right padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // Align items at the start and end
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20, // Reduce the font size for the label
                    fontWeight: FontWeight.bold, // Make the label bold
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    // Show the edit dialog when the edit icon is pressed
                    _showEditDialog(title, value);
                  },
                ),
              ],
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 18, // Font size for the value
              ),
            ),
            SizedBox(height: 15), // Add space between the fields
          ],
        ),
      ),
    );
  }
}
