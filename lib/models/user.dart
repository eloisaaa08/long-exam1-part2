// added this model to represent the authenticated dummyjson user for enhancement 1
class User {
  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String image;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.image,
  });

  // convenience getter used by the app bar / profile screen titles
  String get fullName => '$firstName $lastName'.trim();

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      image: json['image'] ?? '',
    );
  }

  // used by UserService to cache the logged-in user as json in SharedPreferences
  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'email': email,
    'firstName': firstName,
    'lastName': lastName,
    'image': image,
  };
}
