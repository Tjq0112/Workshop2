class Driver1{
  String id;
  final String d_name;
  final String d_username;
  final String d_password;
  final String d_icNumber;
  final String d_phoneNumber;
  final bool d_active;

  Driver1({
    this.id = "",
    required this.d_name,
    required this.d_username,
    required this.d_password,
    required this.d_icNumber,
    required this.d_phoneNumber,
    required this.d_active
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': d_name,
    'username': d_username,
    'password': d_password,
    'ic number': d_icNumber,
    'phone number': d_phoneNumber,
    'active' : d_active,
  };

  static Driver1 fromJson(Map<String, dynamic> json) => Driver1(
      id: json['id'],
      d_name: json['name'],
      d_username: json['username'],
      d_password: json['password'],
      d_icNumber: json['ic number'],
      d_phoneNumber: json['phone number'],
      d_active: json['active'],
  );
}