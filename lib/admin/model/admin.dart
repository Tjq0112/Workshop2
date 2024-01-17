class admin{
  final String password;
  final String username;

  admin({
    required this.password,
    required this.username,
  });

  static admin fromJson(Map<String, dynamic> json) => admin(
    password: json['password'],
    username: json['username'],
  );
}