class User{
  String user_id;
  String username;
  String fullname;
  String ic;
  String phoneNumber;
  String password;

  User({
    this.user_id = '',
    required this.username,
    required this.password,
    required this.fullname,
    required this.ic,
    required this.phoneNumber,
  });

  Map<String, dynamic> toJson()=>{
    'id' : user_id,
    'username' : username,
    'password' : password,
    'fullname' : fullname,
    'ic' : ic,
    'phoneNumber' : phoneNumber,
  };
}