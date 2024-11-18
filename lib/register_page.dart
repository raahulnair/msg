// register_page.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);
  
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String firstName = '';
  String lastName = '';
  String role = 'User'; // Default role
  bool isLoading = false;

  void _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        
        // Save additional user info to Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'uid': userCredential.user!.uid,
          'firstName': firstName,
          'lastName': lastName,
          'role': role,
          'registrationDateTime': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration Successful. Please login.')),
        );

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } on FirebaseAuthException catch (e) {
        String message = 'An error occurred, please try again.';
        if (e.code == 'email-already-in-use') {
          message = 'The account already exists for that email.';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Widget _buildFirstNameField() {
    return TextFormField(
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

  Widget _buildEmailField() {
    return TextFormField(
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.email),
        labelText: 'Email',
        border: OutlineInputBorder(),
      ),
      validator: (value) =>
          value!.isEmpty ? 'Enter email' : null,
      onChanged: (value) {
        setState(() => email = value.trim());
      },
      keyboardType: TextInputType.emailAddress,
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.lock),
        labelText: 'Password',
        border: OutlineInputBorder(),
      ),
      obscureText: true,
      validator: (value) =>
          value!.length < 6 ? 'Enter 6+ chars' : null,
      onChanged: (value) {
        setState(() => password = value.trim());
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: isLoading 
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 30),
                Icon(
                  Icons.forum,
                  size: 100,
                  color: Colors.blueAccent,
                ),
                SizedBox(height: 20),
                _buildFirstNameField(),
                SizedBox(height: 20),
                _buildLastNameField(),
                SizedBox(height: 20),
                _buildEmailField(),
                SizedBox(height: 20),
                _buildPasswordField(),
                SizedBox(height: 20),
                _buildRoleField(),
                SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50), // Full-width button
                  ),
                  child: Text('Register'),
                  onPressed: _register,
                ),
                SizedBox(height: 10),
                TextButton(
                  child: Text('Already have an account? Login'),
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
