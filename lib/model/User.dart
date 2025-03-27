class User {
  int? id;
  String? name;
  String? contact;
  String? email;
  String? imagePath; // New field for image path
  String? latitude;
  String? longitude;

  User({
    this.id,
    this.name,
    this.contact,
    this.email,
    this.imagePath,
    this.latitude,
    this.longitude,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      contact: json['contact'],
      email: json['email'],
      imagePath: json['imagePath'], // New field for image path
      latitude: json['latitude'],
      longitude: json['longitude']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'contact': contact,
      'email': email,
      'imagePath': imagePath, // New field for image path
      'latitude': latitude,
      'longitude': longitude
    };
  }
}
