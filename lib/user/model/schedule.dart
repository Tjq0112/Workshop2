class Schedule{
  String schedule_id;
  String date; // Format?
  bool status;
  String driver_Id;
  String bin_Id;


  Schedule({
    this.schedule_id= '',
    required this.date,
    required this.status,
    required this.driver_Id,
    required this.bin_Id
  });

  // Named constructor to create a Bin instance from a JSON object
  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      schedule_id: json['id'] ?? '', // Use 'id' as the key if that's what's used in your JSON
      date: json['date'] ?? '',
      status: json['status'] ?? '',
      driver_Id: json['driver_Id'] ?? '',
      bin_Id: json['bin_Id'] ?? '',
    );
  }

  Map<String, dynamic> toJson()=>{
    'id' : schedule_id,
    'date' : date,
    'status' : status,
    'driver_Id' : driver_Id,
    'bin_Id' : bin_Id
  };
}