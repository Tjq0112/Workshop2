import 'package:flutter/material.dart';
//import 'package:intl/intl.dart';
import '../controller/bin_controller.dart';
import '../controller/schedule_controller.dart';
import '../model/bin.dart';
import 'bin_register.dart';
import 'bin_update.dart';
import 'detailed_status.dart';

class BinPage extends StatefulWidget {
  final String loginId;

  const BinPage({super.key, required this.loginId});

  @override
  State<BinPage> createState() => _BinPage();
}

class _BinPage extends State<BinPage> {
  final BinPageController _binController = BinPageController();
  final SchedulePageController _scheduleController = SchedulePageController();

  String binId = '';
  String scheduleId = '';
  String status='Pickup';
  bool pickupResult = false;

  Future<void> _showDeleteDialog(BuildContext context, Bin bin) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Bin?'),
          content: Text('Are you sure you want to delete this bin?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                // Delete bin and close the dialog
                _binController.deleteBin(bin.bin_id);
                Navigator.of(context).pop();
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
      body: Column(children: [
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BinRegisterPage(loginId: widget.loginId),
              ),
            );
          },
          child: Text('Register New Bin'),
        ),
        Expanded(
          child: StreamBuilder<List<Bin>>(
            stream: _binController.getBinsStream(widget.loginId),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Bin> bins = snapshot.data!;
                return ListView.builder(
                  itemCount: bins.length,
                  itemBuilder: (context, index) {
                    Bin bin = bins[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DetailedStatusPage(index: index),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 4,
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.delete_sharp,
                                      color: Colors.green, size: 60.0),
                                  SizedBox(height: 16),
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        bin.alias,
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      /*Text(
                                  bin.alias, // This one should read location
                                  style: TextStyle(fontSize: 16),
                                ),*/
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () {
                                      binId = bins[index].bin_id;
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => BinUpdatePage(
                                                loginId: widget.loginId,
                                                binId: binId)),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () {
                                      _showDeleteDialog(context, bin);
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.call),
                                    onPressed: () async {
                                      DateTime date = DateTime.now();
                                      String formattedTime = "${date.year}-${date.month}-${date.day} ${date.hour}:${date.minute}";
                                      if(date.weekday == 6 || date.weekday == 7){
                                        const snackBar = SnackBar(
                                            content: Text("No pickup will be done on weekend")
                                        );
                                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                      }
                                      if(date.hour < 8 || date.hour > 18 ){
                                        const snackBar = SnackBar(
                                            content: Text("No pickup will be done before 8am and after 6pm")
                                        );
                                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                      }
                                      pickupResult = await _scheduleController.createPickup(
                                        date: formattedTime,
                                        status: false,
                                        id: scheduleId,
                                        driver_Id: " ",
                                        bin_Id: bin.bin_id,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );

                  },
                );
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ]),
    );
  }
}