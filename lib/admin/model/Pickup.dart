class Pickup{
  String id;
  String bin_Id;
  String date;
  bool status;
  String driver_Id;
  String type;

  Pickup({
    this.id = " ",
    required this.bin_Id,
    required this.date,
    required this.status,
    required this.driver_Id,
    required this.type
  });

  static Pickup fromJson(Map<String, dynamic> json) => Pickup(
      id : json['id'],
      bin_Id: json['bin_Id'],
      date: json['date'],
      status: json['status'],
      driver_Id: json['driver_Id'],
    type: json['type']
  );

  Map<String, dynamic> toJson() => {
    'id' : id,
    'bin_Id': bin_Id,
    'date': date,
    'status': status,
    'driver_Id': driver_Id,
    'type' : type
  };
}