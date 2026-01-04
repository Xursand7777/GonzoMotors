import 'package:equatable/equatable.dart';

/*

{
    "success": true,
    "statusCode": 200,
    "message": "",
    "data": {
        "id": 16,
        "email": null,
        "phone": "+998973245224",
        "first_name": "muniraaaa",
        "last_name": null,
        "birth_date": null,
        "pinfl": null,
        "gender": null,
        "roles": null,
        "Companies": null
    }
}

 */

class UserModel extends Equatable {
  final int id;
  final String? email;
  final String phone;
  final String firstName;
  final String? lastName;
  final String? birthDate;
  final String? pinfl;
  final String? gender;

  const UserModel({
    required this.id,
    this.email,
    required this.phone,
    required this.firstName,
    this.lastName,
    this.birthDate,
    this.pinfl,
    this.gender,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      email: json['email'] as String?,
      phone: json['phone'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String?,
      birthDate: json['birth_date'] as String?,
      pinfl: json['pinfl'] as String?,
      gender: json['gender'] as String?,
    );
  }

  UserModel copyWith({
    int? id,
    String? email,
    String? phone,
    String? firstName,
    String? lastName,
    String? birthDate,
    String? pinfl,
    String? gender,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      birthDate: birthDate ?? this.birthDate,
      pinfl: pinfl ?? this.pinfl,
      gender: gender ?? this.gender,
    );

  }

  Map<String, dynamic> toJson() {
    final user =  {
      'id': id,
      'phone': phone,
      'first_name': firstName,
    };

    if(email != null) {
      user['email'] = email!;
    }
    if(lastName != null) {
      user['last_name'] = lastName!;

    }
    if(birthDate != null) {
      user['birth_date'] = birthDate!;

    }
    if(pinfl != null) {
      user['pinfl'] = pinfl!;
    }
    if(gender != null) {
      user['gender'] = gender!;
    }

    return user;
  }


  @override
  List<Object?> get props => [
    id,
    email,
    phone,
    firstName,
    lastName,
    birthDate,
    pinfl,
    gender,
  ];
}
