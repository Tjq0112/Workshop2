class Bin{
  String bin_id;
  String alias;
  String user_id;
  String temperature;
  String weight;
  String fill_level;

  Bin({
    this.bin_id= '',
    required this.alias,
    required this.user_id,
    required this.temperature,
    required this.weight,
    required this.fill_level,
  });

  // Named constructor to create a Bin instance from a JSON object
  factory Bin.fromJson(Map<String, dynamic> json) {
    return Bin(
      bin_id: json['id'] ?? '', // Use 'id' as the key if that's what's used in your JSON
      alias: json['alias'] ?? '',
      user_id: json['user_id'] ?? '',
      temperature: json['temperature'] ?? '',
      weight: json['weight'] ?? '',
      fill_level: json['fill_level'] ?? '',
    );
  }

  Map<String, dynamic> toJson()=>{
    'id' : bin_id,
    'alias' : alias,
    'user_id' : user_id,
    'temperature' : temperature,
    'weight' : weight,
    'fill_level': fill_level,
  };
}