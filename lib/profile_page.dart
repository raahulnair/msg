// profile_page.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);
  
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  String firstName = '';
  String lastName = '';
  String role = '';
  bool isLoading = true;
  bool isUpdating = false;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      setState(() {
        firstName = userDoc['firstName'];
        lastName = userDoc['lastName'];
        role = userDoc['role'];
        isLoading = false;
      });
    }
  }

  void _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isUpdating = true;
      });
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
          'firstName': firstName,
          'lastName': lastName,
          'role': role,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile Updated')),
        );
      }
      setState(() {
        isUpdating = false;
      });
    }
  }

  Widget _buildFirstNameField() {
    return TextFormField(
      initialValue: firstName,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.person),
        labelText: 'First Name',
        border: OutlineInputBorder(),
      ),
      validator: (value) =>
          value!.isEmpty ? 'Enter first name' : null,
      onChanged: (value) {
        setState(() => firstName = value.trim());
      },
    );
  }

  Widget _buildLastNameField() {
    return TextFormField(
      initialValue: lastName,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.person_outline),
        labelText: 'Last Name',
        border: OutlineInputBorder(),
      ),
      validator: (value) =>
          value!.isEmpty ? 'Enter last name' : null,
      onChanged: (value) {
        setState(() => lastName = value.trim());
      },
    );
  }

  Widget _buildRoleField() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.badge),
        labelText: 'Role',
        border: OutlineInputBorder(),
      ),
      value: role,
      items: <String>['User', 'Admin']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          role = newValue!;
        });
      },
      validator: (value) =>
          value!.isEmpty ? 'Select a role' : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : isUpdating
              ? Center(child: CircularProgressIndicator())
              : Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Icon(
                            Icons.person,
                            size: 100,
                            color: Colors.blueAccent,
                          ),
                          SizedBox(height: 20),
                          _buildFirstNameField(),
                          SizedBox(height: 20),
                          _buildLastNameField(),
                          SizedBox(height: 20),
                          _buildRoleField(),
                          SizedBox(height: 30),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.infinity, 50), // Full-width button
                            ),
                            child: Text('Update Profile'),
                            onPressed: _updateProfile,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
    );
  }
}
