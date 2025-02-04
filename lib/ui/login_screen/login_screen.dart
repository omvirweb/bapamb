// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jewelbook_calculator/services/dataModel.dart';
import 'package:jewelbook_calculator/services/urlApi.dart';
import 'package:jewelbook_calculator/ui/dashboard/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

// import 'login_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;
  bool _isButtonEnabled = false;
  bool _obscureText = true;

  bool isFormValid() {
    // Check if both fields are not empty
    return usernameController.text.isNotEmpty &&
        passwordController.text.isNotEmpty;
  }

  void _updateButtonState() {
    setState(() {
      _isButtonEnabled =
          isFormValid(); // Enable button when both fields are non-empty
    });
  }

  Future<dataModel?> submitData(
      String username, String password, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      isLoading = true;
      _isButtonEnabled = false;
    });

    try {
      var request = http.MultipartRequest(
          'POST', Uri.parse('${ApiConstants.apiurl}login'));

      // Add form fields
      request.fields['username'] = username;
      request.fields['password'] = password;

      // Send the request
      var response = await request.send();
      print(response);

      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        var responseData = jsonDecode(responseBody);
        print(responseData);

        if (responseData['status'] == true) {
          String token = responseData['token'];
          print('Login successful. Token: $token');

          // Save token in SharedPreferences
          prefs.setString('auth_token', token);
          prefs.setBool('isLoggedIn', true);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const Dashboard(),
            ),
          );
          // Create and return a dataModel instance
          return dataModel.fromJson(responseData);
        } else {
          print('Login failed: ${responseData['message']}');
          prefs.setBool('isLoggedIn', false);

          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Error'),
                content: Text(responseData['message'] ?? 'Invalid Credentials'),
                actions: [
                  TextButton(
                    onPressed: () {
                      usernameController.clear();
                      passwordController.clear();
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'OK',
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                ],
              );
            },
          );
          return null; // Return null in case of failure
        }
      } else {
        print('Request failed with status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error occurred: $e');
      return null;
    } finally {
      setState(() {
        isLoading = false;
        _isButtonEnabled = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    // Add listeners to text controllers
    usernameController.addListener(_updateButtonState);
    passwordController.addListener(_updateButtonState);
    // checkIfAlreadyLogin();
  }

  SharedPreferences? prefs;
  bool? newUser;

  // ignore: unused_field
  dataModel? _dataModel;
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // return GetBuilder<LoginController>(builder: (controller) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        SystemNavigator.pop(); // Exit the app when back button is pressed
      },
      child: Scaffold(
          body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus(); // Close the keyboard
              },
              child: SingleChildScrollView(
                child: Form(
                  key: _formkey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 80),
                      Card(
                        color: Colors.black,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: 200,
                            height: 150,
                            child: Image.asset('assets/images/app_icon.png'),
                          ),
                        ),
                      ),
                      const SizedBox(height: 50),
                      const Text(
                        "We've been awaiting you",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 30),
                      TextField(
                        controller: usernameController,
                        keyboardType: TextInputType.text,
                        maxLength: 10,
                        decoration: const InputDecoration(
                          labelText: 'Enter Username',
                          border: OutlineInputBorder(),
                          counterText: "",
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: passwordController,
                        keyboardType: TextInputType.text,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          labelText: 'Enter Password',
                          border: OutlineInputBorder(),
                          counterText: "",
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.deepOrange.shade900,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText =
                                    !_obscureText; // Toggle the obscureText flag
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: _isButtonEnabled
                            ? () async {
                                if (isFormValid()) {
                                  setState(() {
                                    isLoading = true;
                                    _isButtonEnabled = false;
                                    FocusScope.of(context).unfocus();
                                  });
                                  login();
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Both Mobile Number and Password are required.',
                                      ),
                                    ),
                                  );
                                }
                              }
                            : null,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.symmetric(
                              vertical: 13.0, horizontal: 30.0),
                          decoration: BoxDecoration(
                            gradient: _isButtonEnabled
                                ? LinearGradient(
                                    colors: [
                                      Colors.deepOrange.shade900,
                                      Colors.deepOrangeAccent.shade700
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  )
                                : const LinearGradient(
                                    colors: [
                                      Color.fromARGB(255, 156, 154, 154),
                                      Color.fromARGB(255, 209, 209, 209)
                                    ],
                                  ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 7,
                                offset: const Offset(0, 3),
                              ),
                            ],
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                            child: isLoading
                                ? const CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  )
                                : const Text(
                                    'Log In',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      )),
    );
  }

  void login() async {
    if (_formkey.currentState!.validate()) {
      String username = usernameController.text.trim();
      String password = passwordController.text.trim();

      if (username.isNotEmpty && password.isNotEmpty) {
        // Call submitData and get the response
        dataModel? data = await submitData(username, password, context);

        setState(() {
          if (data != null) {
            _dataModel = data;
            print('Login successful! Data: $_dataModel');
          } else {
            _dataModel = null;
            print('Login failed. No data returned.');
          }
          isLoading = false;
          _isButtonEnabled = true;
        });
      }
    }
  }

  // to check the user is logged in or not
  // void checkIfAlreadyLogin() async {
  //   prefs = await SharedPreferences.getInstance();
  //   newUser = (prefs!.getBool('login') ?? true);

  //   print(newUser);
  //   if (newUser == false) {
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => const HomeScreen(),
  //       ),
  //     );
  //   }
  // }

  @override
  void dispose() {
    usernameController.removeListener(_updateButtonState);
    passwordController.removeListener(_updateButtonState);
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
