import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import '../controller/bin_controller.dart';

class BinRegisterPage extends StatefulWidget {
  final String loginId;

  const BinRegisterPage({Key? key, required this.loginId}) : super(key: key);

  @override
  State<BinRegisterPage> createState() => _BinRegisterPage();
}

class _BinRegisterPage extends State<BinRegisterPage> {
  final TextEditingController aliasController = TextEditingController();
  final BinPageController _newBinController = BinPageController();

  dynamic temperature;
  dynamic weight;
  dynamic fill_level;

  // Create a timer that updates the data every second
  late Timer timer;
  bool regResult=false;

  @override
  void initState() {
    super.initState();

    // Initialize the timer
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      // Fetch latest data of temperature and weight
      if (mounted) {
        _newBinController.getJsonDataT().then((resultT) {
          setState(() {
            temperature = resultT;
          });
        });

        _newBinController.getJsonDataW().then((resultW) {
          setState(() {
            weight = resultW;
          });
        });

        _newBinController.getJsonDataF().then((resultF) {
          setState(() {
            fill_level = resultF;
          });
        });

      }
    });
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Image.asset('assets/wastewise.png', height: 45)
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          const SizedBox(height: 24),
          TextField(
            decoration: const InputDecoration(
              labelText: "Alias",
            ),
            controller: aliasController,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              temperature = await _newBinController.getJsonDataT();
              weight = await _newBinController.getJsonDataW();
              fill_level= await _newBinController.getJsonDataF();
              regResult = await _newBinController.createBin(
                alias: aliasController.text,
                id: "",
                user_id: widget.loginId,
                temperature: temperature,
                weight: weight,
                fill_level: fill_level,
              );
              print(regResult);

              if(regResult==true){
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('New Bin Registration Successful.'),
                  ),
                );
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('New Bin Registration Failed.'),
                  ),
                );
              }

            },
            child: const Text('Register Bin'),
          ),
        ],
      ),
    );
  }
}
