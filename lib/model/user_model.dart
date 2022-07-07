class UserModel {
  //fields / variables
  String? userId;
  String? name;
  String? email;
  String? age;
  String? gender;
  String? status;
  String? urlImage;

  //constructor
  UserModel(
      {this.userId,
      this.name,
      this.email,
      this.age,
      this.gender,
      this.status,
      this.urlImage});

  //named constructor to receive data from firebase
  factory UserModel.fromMap(Map<String, dynamic>? map) {
    return UserModel(
        userId: map!['uid'],
        name: map['name'],
        email: map['email'],
        age: map['age'],
        gender: map['gender'],
        status: map['status'],
        urlImage: map['urlImage']);
  }

  //function to send data to firebase
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': userId,
      'name': name,
      'email': email,
      'age': age,
      'gender': gender,
      'status': status,
      'urlImage': urlImage
    };
  }
}
