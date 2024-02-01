import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

import 'models/profiledata.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<ProfileData> _futureProfileData;

  @override
  void initState() {
    // TODO: implement initState
    _futureProfileData = fetchProfileData();
    super.initState();
  }
  // loadData() async {
  //   final data = await rootBundle.loadString("assets/files/da")
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
        ),
        body: FutureBuilder<ProfileData>(
            future: _futureProfileData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error loading profile data'));
              } else {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: NetworkImage(
                            snapshot.data!.userProfilePhoto), // Replace with your profile image URL
                      ),
                      SizedBox(height: 20),
                  Text(' ${snapshot.data!.userFirstname} ${snapshot.data!.userLastname}',
                  style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text('${snapshot.data!.employeeId}'),
                      SizedBox(height: 10),
                      Text(' ${snapshot.data!.userGender}', style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),),
                      SizedBox(height: 10),
                      Text(' ${snapshot.data!.userReligion}', style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),),
                      SizedBox(height: 10),
                      Text(' ${snapshot.data!.userContactNo}',
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),

                      SizedBox(height: 10),
                  Text('${snapshot.data!.userDob}',
                    style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                      SizedBox(height: 20),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          // Implement logout logic
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                        child: Text('Logout'),
                      ),
                    ],
                  ),
                );
              }
            }));
  }
}
