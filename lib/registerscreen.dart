import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _isObscure = true;
  bool _agree = false;
  String _errorMessage = '';

  final _formKey = GlobalKey<FormState>(); // Key for the Form widget
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  void saveRegistrationData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('firstName', _firstNameController.text);
    prefs.setString('lastName', _lastNameController.text);
    prefs.setString('mobile', _mobileController.text);
    prefs.setString('email', _emailController.text);
    prefs.setString('password', _passwordController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey, // Assign the key to the Form widget
            child: Column(
              children: [
                SizedBox(height: 20),
                Image(
                  image: AssetImage('assets/images/header.jpg'),
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Create an Account',
                    style: TextStyle(
                      fontSize: 12.0,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                buildTextFormField(
                  label: 'First Name',
                  controller: _firstNameController,
                  validator: (value) =>
                  value!.isEmpty ? 'Please enter your first name.' : null,
                ),
                buildTextFormField(
                  label: 'Last Name',
                  controller: _lastNameController,
                  validator: (value) =>
                  value!.isEmpty ? 'Please enter your last name.' : null,
                ),
                buildTextFormField(
                  label: 'Mobile No.',
                  controller: _mobileController,
                  validator: (value) =>
                  value!.isEmpty
                      ? 'Please enter your mobile number.'
                      : null,
                ),
                buildTextFormField(
                  label: 'E-mail',
                  controller: _emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    // Email validation
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                buildTextFormField(
                  label: 'Password',
                  controller: _passwordController,
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password.';
                    }
                    // Password validation (at least 6 characters)
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters long';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                if (_errorMessage.isNotEmpty)
                  Text(
                    _errorMessage,
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Checkbox(
                      value: _agree,
                      onChanged: (value) {
                        setState(() {
                          _agree = value!;
                        });
                      },
                    ),
                    Text('I agree with terms and conditions'),
                    SizedBox(width: 80),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                                         if (!_agree) {
                                           setState(() {
                                             _errorMessage =
                                             'Please agree to the terms and conditions.';
                                           });
                                           return;
                                         }
    saveRegistrationData();
                      if (_firstNameController.text.isNotEmpty &&
                          _emailController.text.isNotEmpty &&
                          _passwordController.text.isNotEmpty &&
                          _lastNameController.text.isNotEmpty &&
                          _mobileController.text.isNotEmpty) {
                        Navigator.pushReplacementNamed(context, '/login');
                      }
                    }
                  },
                  child: Text('Register'),
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  child: Text('Already have an account? Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextFormField({
    required String label,
    required TextEditingController controller,
    required FormFieldValidator<String> validator,
    bool isPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controller,
          validator: (value) {
            if (validator(value) != null) {
              return validator(value);
            }
            // Validation for password
            if (label == 'Password') {
              if (value!.length < 6) {
                return 'Password must be at least 6 characters long';
              }
            }
            // Validation for mobile number
            if (label == 'Mobile No.') {
              if (value!.length != 10) {
                return 'Mobile number must be 10 digits';
              }
            }
            return null;
          },
          obscureText: isPassword && _isObscure, // Toggle obscureText
          decoration: InputDecoration(
            suffixIcon: isPassword
                ? IconButton(
              onPressed: () {
                setState(() {
                  _isObscure = !_isObscure;
                });
              },
              icon: Icon(
                _isObscure ? Icons.visibility : Icons.visibility_off,
              ),
            )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(13)),
            ),
          ),
        ),
      ],
    );
  }
}