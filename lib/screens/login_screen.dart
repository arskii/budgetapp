import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:budgetapp/api/api_client.dart';
import 'package:budgetapp/components/main_button.dart';
import 'package:budgetapp/screens/pincode_screen.dart';
import 'package:budgetapp/screens/recovery_screen.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';

import '../components/main_textfield.dart';
import '../components/title_screen.dart';
import '../constants.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
// final controller
  final usernameController = TextEditingController();

  final passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  String? _email, _password;

  bool isHidden = true;

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: h,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: const [
                  mainColor,
                  secondColor,
                ]),
          ),
          child: SafeArea(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Expanded(flex: 2, child: TitleScreen(title: 'Welcome back')),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        MainTexfield(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter email';
                            }
                            return null;
                          },
                          onSaved: (input) => _email = input!,
                          keyboardType: TextInputType.emailAddress,
                          controller: usernameController,
                          labelText: 'Email',
                          obscureText: false,
                        ),

                        const SizedBox(height: 20),

                        // password

                        MainTexfield(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter password';
                            }
                            return null;
                          },
                          onSaved: (input) => _password = input!,
                          keyboardType: TextInputType.visiblePassword,
                          controller: passwordController,
                          labelText: 'Password',
                          obscureText: isHidden,
                          suffixIcon: InkWell(
                            onTap: _togglePasswordView,
                            child: Align(
                              widthFactor: 1.0,
                              heightFactor: 1.0,
                              child: Icon(
                                color: Colors.black,
                                Icons.remove_red_eye,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        TextButton(
                          onPressed: () {
                            Get.to(RecoveryScreen());
                          },
                          child: Text(
                            'Forgot your password?',
                            style: TextStyle(
                                fontFamily: 'Jost',
                                fontSize: 18.0,
                                color: Colors.black),
                          ),
                        ),
                        MainButton(
                          onTap: () {
                            _submit();
                          },
                          text: 'Log in',
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _togglePasswordView() {
    setState(() {
      isHidden = !isHidden;
    });
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Map<String, dynamic> datauser = {
        'username': _email,
        'password': _password
      };
      dynamic res = await ApiClient().login(datauser);
      print('Email: $_email, Password: $_password');
      if (res['detail'] == null) {
        Get.off(() => PinCodeScreen());
      } else {
        //if error is present, display a snackbar showing the error messsage
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${res['detail']}'),
          backgroundColor: Colors.red.shade300,
        ));
      }
    }
  }
}
