import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isObscure = true;
  bool _rememberMe = false;
  final _formKey = GlobalKey<FormState>(); // Key for the Form widget
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';

  // Predefined ID and password
  // final String _validId = 'MID0001';
  // final String _validPassword = '111';

  @override
  void dispose() {
    _idController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // void _login() {
  //   if (_formKey.currentState!.validate()) {
  //     String enteredId = _idController.text;
  //     String enteredPassword = _passwordController.text;
  //
  //     if (enteredId == _validId && enteredPassword == _validPassword) {
  //       // Navigate to the next screen or perform login logic
  //       Navigator.pushReplacementNamed(context, '/profile');
  //     } else {
  //       setState(() {
  //         _errorMessage = 'Invalid ID or password. Please try again.';
  //       });
  //     }
  //   }
  // }
  void _login() async {
    if (_formKey.currentState!.validate()) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String storedEmail = prefs.getString('email') ?? '';
      String storedPassword = prefs.getString('password') ?? '';

      if (_idController.text == storedEmail &&
          _passwordController.text == storedPassword) {
        // Navigate to the next screen or perform login logic
        Navigator.pushReplacementNamed(context, '/profile');
      } else {
        setState(() {
          _errorMessage = 'Invalid email or password. Please try again.';
        });
      }

      if (_rememberMe) {
        // Store user credentials if Remember Me is checked
        await prefs.setString('email', _idController.text);
        await prefs.setString('password', _passwordController.text);
      } else {
        // Clear stored credentials if Remember Me is unchecked
        await prefs.remove('email');
        await prefs.remove('password');
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey, // Assign the key to the Form widget
            child: Column(
              children: [
                SizedBox(height: 30),
                Image(image: AssetImage('assets/images/header.jpg'),fit: BoxFit.cover,),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Welcome Back!',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Please Login To Your account',
                    style: TextStyle(
                      fontSize: 12.0,
                    ),
                  ),
                ),
                SizedBox(height: 40),
                buildTextFormField(
                  label: 'Email',
                  controller: _idController,
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
                      value: _rememberMe,
                      onChanged: (value) {
                        setState(() {
                          _rememberMe = value!;
                        });
                      },
                    ),
                    Text('Remember Me'),
                    SizedBox(width: 80),
                    TextButton(
                      onPressed: () {
                        // Navigate to forgot password screen
                      },
                      child: Text('Forgot Password?'),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _login,
                  child: Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/register');
                  },
                  child: Text('New User ? Sign Up'),
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
          validator: validator,
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
