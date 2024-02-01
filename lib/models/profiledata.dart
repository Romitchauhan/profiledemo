import 'dart:convert';
import 'package:flutter/services.dart';

class ProfileData {
  final String employeeId;
  final String userFirstname;
  final String userLastname;
  final String userDob;
  final String userContactNo;
  final String userGender;
  final String userReligion;
  final String userProfilePhoto;

  ProfileData({
    required this.employeeId,
    required this.userFirstname,
    required this.userLastname,
    required this.userDob,
    required this.userContactNo,
    required this.userGender,
    required this.userReligion,
    required this.userProfilePhoto,
  });

  factory ProfileData.fromMap(Map<String, dynamic> map) {
    return ProfileData(
      employeeId: map['employee_id'],
      userFirstname: map['userfirstname'],
      userLastname: map['userlastname'],
      userDob: map['userdob'],
      userContactNo: map['usercontactno'],
      userGender: map['usergender'],
      userReligion: map['userreligion'],
      userProfilePhoto: map['userprofilephoto'],
    );
  }
}

Future<ProfileData> fetchProfileData() async {
  String jsonString = await rootBundle.loadString('assets/files/data.json');
  Map<String, dynamic> jsonData = json.decode(jsonString);
  var profileDataList = jsonData['data'] as List;
  var profileData = ProfileData.fromMap(profileDataList[0]);
  return profileData;
}
