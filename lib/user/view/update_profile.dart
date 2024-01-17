import 'package:flutter/material.dart';
import 'package:mockapp/user/controller/user_controller.dart';
import 'package:mockapp/user/view/settings.dart';
import 'package:mockapp/user/view/user_login.dart';

class UpdateProfilePage extends StatefulWidget {
  final String loginId;
  const UpdateProfilePage({Key? key, required this.loginId}) : super(key: key);

  @override
  State<UpdateProfilePage> createState() => _UpdateProfilePage();
}

class _UpdateProfilePage extends State<UpdateProfilePage> {
  UserPageController _userPageController = UserPageController();

  String fullname = '';
  String ic = '';
  String phoneNumber = '';
  bool update = false;
  bool delete = false;
  List<String> userDetails = [];

  // Instance variables to hold values from _showEditDialog
  late String editedFullname='';
  late String editedIC='';
  late String editedPhoneNumber='';

  Future<void> details() async {
    userDetails = await _userPageController.getUserDetails(user_id: widget.loginId);

    // Set initial values for fullname, ic, and phoneNumber
    setState(() {
      fullname = userDetails.isNotEmpty ? userDetails[0] : '';
      ic = userDetails.isNotEmpty ? userDetails[1] : '';
      phoneNumber = userDetails.isNotEmpty ? userDetails[2] : '';
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

    // Set the keyboardType based on the label
    if (label == 'Phone Number' || label == 'IC Number') {
      keyboardType = TextInputType.number;
    }

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
                  if (label == 'Fullname') {
                    editedFullname = controller.text;
                  } else if (label == 'Phone Number') {
                    editedPhoneNumber = controller.text;
                  } else if (label == 'IC Number') {
                    editedIC = controller.text;
                  }
                });
                Navigator.of(context).pop();
                setState(() {
                  // Update the values
                  fullname = editedFullname;
                  ic = editedIC;
                  phoneNumber = editedPhoneNumber;
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
          buildEditableCard("Fullname", fullname),
          buildEditableCard("IC Number", ic),
          buildEditableCard("Phone Number", phoneNumber),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  print(fullname);
                  print(ic);
                  print(phoneNumber);
                  update = await _userPageController.updateProfile(
                    widget.loginId, fullname, ic, phoneNumber,
                  );

                  if (update == true) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Profile Updated'),
                      ),
                    );
                    Navigator.of(context).pop(SettingsPage(loginId: widget.loginId));
                  }
                },
                child: const Text('Update Profile'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                child: Text('Delete'),
                onPressed: () async {
                  // Delete bin and close the dialog
                  delete = await _userPageController.deleteProfile(widget.loginId);

                  if (delete == true) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Profile Deleted'),
                      ),
                    );
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => LoginPage(),
                    ));
                  }
                },
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
