class CreateUserModel {
  final String? firstname;
  final String? lastname;
  final String? pinfl;
  final String? phoneNumber;
  final int? genderId;

  CreateUserModel({
    this.firstname,
    this.lastname,
    this.pinfl,
    this.phoneNumber,
    this.genderId,
  });

  factory CreateUserModel.fromJson(Map<String, dynamic> json) {
    return CreateUserModel(
      firstname: json['firstname'] as String?,
      lastname: json['lastname'] as String?,
      pinfl: json['pinfl'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      genderId: json['genderId'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstname': firstname,
      'lastname': lastname,
      'pinfl': pinfl,
      'phoneNumber': phoneNumber,
      'genderId': genderId,
    };
  }
}
