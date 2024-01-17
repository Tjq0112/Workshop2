import 'dart:async';
import 'package:flutter/material.dart';
import '../controller/bin_controller.dart';
import 'bin_map.dart';

class DetailedStatusPage extends StatefulWidget {
  final int index;

  const DetailedStatusPage({Key? key, required this.index}) : super(key: key);

  @override
  State<DetailedStatusPage> createState() => _DetailedStatusPageState();
}

class _DetailedStatusPageState extends State<DetailedStatusPage> {
  final BinPageController _newBinController = BinPageController();
  dynamic temperature;
  dynamic weight;
  dynamic full;
  late Timer timer;

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted) {
        _newBinController.getJsonDataT().then((resultT) {
          setState(() {
            temperature = resultT;
          });
          double temperatureT = double.parse(temperature);
          if(temperatureT>=40)
          {
            _newBinController.SendNotificationTemperature();
          }
        });

        _newBinController.getJsonDataW().then((resultW) {
          setState(() {
            weight = resultW;
          });
          double weightW = double.parse(weight);
          if(weightW>=5000)
          {
            _newBinController.SendNotificationWeight();
          }
        });

        _newBinController.getJsonDataF().then((resultF) {
          setState(() {
            full = resultF;
          });
          double fullF = double.parse(full);
          if(fullF<=2)
          {
            _newBinController.SendNotificationFull();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Bin Status'),
        backgroundColor: Colors.lightGreen,
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          buildCard(Icons.location_on, 'Location',
              'FTMK'),
          buildCard(Icons.restore_from_trash, 'Full Level',
              '${full ?? _newBinController.getJsonDataF()}(cm)'),
          buildCard(Icons.scale_outlined, 'Weight Level',
              '${weight ?? _newBinController.getJsonDataW()} (g)'),
          buildCard(Icons.local_fire_department, 'Temperature Level',
              '${temperature ?? _newBinController.getJsonDataT()} °C'),
        ],
      ),
    );
  }

  Widget buildCard(IconData icon, String title, String subtitle) {
    return GestureDetector(
      onTap: () {
        // Check if the title is 'Location', then navigate to the map page
        if (title == 'Location') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MapPage(), // Replace with your MapPage
            ),
          );
        }
      },
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, color: Colors.red, size: 60.0),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}