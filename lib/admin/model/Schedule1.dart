class Schedule1{
  String id;
  String date;
  String driver_Id;

  Schedule1({
    required this.id,
    required this.date,
    required this.driver_Id,
  });

  static Schedule1 fromJson(Map<String, dynamic> json) => Schedule1(
    id: json['id'],
    date: json['date'],
    driver_Id: json['driver_Id']
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date,
    'driver_Id': driver_Id,
  };
}