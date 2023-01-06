import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:homestay/view/loginPage.dart';
import 'package:http/http.dart' as http;
import 'package:ndialog/ndialog.dart';

import '../config.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final focusName = FocusNode();

  final focusEmail = FocusNode();

  final focusPass = FocusNode();

  final focusRePass = FocusNode();

  final TextEditingController _nameEditingController = TextEditingController();

  final TextEditingController _emailEditingController = TextEditingController();

  final TextEditingController _passEditingController = TextEditingController();

  final TextEditingController _rePassEditingController =
      TextEditingController();

  bool _isChecked = false;
  bool _obscureText = true;
  bool _obscureText1 = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(24, 24, 32, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(24, 24, 32, 1),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(children: [
                const Text(
                  'Create your account',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 10),
                  child: TextFormField(
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value!.isEmpty || (value.length) <= 5) {
                        return "name must longer than 5 characters";
                      }
                      return null;
                    },
                    onFieldSubmitted: (v) {
                      FocusScope.of(context).requestFocus(focusName);
                    },
                    controller: _nameEditingController,
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 203, 200, 200)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(width: 2, color: Colors.grey)),
                      contentPadding: EdgeInsets.all(10),
                      border: OutlineInputBorder(
                        gapPadding: 10,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 10),
                  child: TextFormField(
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (!(value!.contains('@')) || !(value.contains('.'))) {
                        return "Enter a valid email address";
                      }
                      return null;
                    },
                    onFieldSubmitted: (v) {
                      FocusScope.of(context).requestFocus(focusEmail);
                    },
                    controller: _emailEditingController,
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 203, 200, 200)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(width: 2, color: Colors.grey)),
                      contentPadding: EdgeInsets.all(10),
                      border: OutlineInputBorder(
                        gapPadding: 10,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 10),
                  child: TextFormField(
                    obscureText: _obscureText,
                    textInputAction: TextInputAction.next,
                    validator: ((value) {
                      value = value.toString();

                      String pattern =
                          r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{10,}$';
                      RegExp regex = RegExp(pattern);
                      if (value.isEmpty) {
                        return 'Please enter password';
                      } else {
                        if (!regex.hasMatch(value)) {
                          return 'Enter valid password';
                        } else {
                          return null;
                        }
                      }
                    }),
                    onFieldSubmitted: (v) {
                      FocusScope.of(context).requestFocus(focusPass);
                    },
                    controller: _passEditingController,
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                    decoration: InputDecoration(
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                        child: Icon(_obscureText
                            ? Icons.visibility
                            : Icons.visibility_off),
                      ),
                      labelText: 'Password',
                      labelStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 203, 200, 200)),
                      enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(width: 2, color: Colors.grey)),
                      contentPadding: const EdgeInsets.all(10),
                      border: const OutlineInputBorder(
                        gapPadding: 10,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 10),
                  child: TextFormField(
                    obscureText: _obscureText1,
                    textInputAction: TextInputAction.done,
                    validator: (value) {
                      value = value.toString();
                      if (value != _passEditingController.text) {
                        return "password do not match";
                      } else {
                        return null;
                      }
                    },
                    onFieldSubmitted: (v) {
                      FocusScope.of(context).requestFocus(focusRePass);
                    },
                    controller: _rePassEditingController,
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                    decoration: InputDecoration(
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _obscureText1 = !_obscureText1;
                          });
                        },
                        child: Icon(_obscureText1
                            ? Icons.visibility
                            : Icons.visibility_off),
                      ),
                      labelText: 'Re-Password',
                      labelStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 203, 200, 200)),
                      enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(width: 2, color: Colors.grey)),
                      contentPadding: const EdgeInsets.all(10),
                      border: const OutlineInputBorder(
                        gapPadding: 10,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Checkbox(
                      side: MaterialStateBorderSide.resolveWith(
                        (states) =>
                            const BorderSide(width: 1.0, color: Colors.white),
                      ),
                      activeColor: Colors.blue,
                      checkColor: Colors.white,
                      value: _isChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          _isChecked = value!;
                        });
                      },
                    ),
                    const Text('I accept the term of the agreement',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ],
                ),
                SizedBox(
                  width: 150,
                  height: 30,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          const MaterialStatePropertyAll(Color(0xff6750a4)),
                      shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: const BorderSide(color: Colors.white))),
                    ),
                    onPressed: _registerButton,
                    child: const Text("Sign In",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        )),
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  void _registerButton() {
    if (!_formKey.currentState!.validate()) {
      Fluttertoast.showToast(
          msg: "Incompleted registration form",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          textColor: Colors.greenAccent,
          timeInSecForIosWeb: 1,
          fontSize: 20.0);
      return;
    }
    if (!_isChecked) {
      Fluttertoast.showToast(
        msg: "Please accept the Terms and Conditions",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        textColor: Colors.greenAccent,
        timeInSecForIosWeb: 1,
        fontSize: 20.0,
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Register new account?",
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          content: const Text("Are you sure?",
              style: TextStyle(
                fontSize: 16,
              )),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _registerUserAccount();
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _registerUserAccount() {
    FocusScope.of(context).requestFocus(FocusNode());
    String name = _nameEditingController.text;
    String email = _emailEditingController.text;
    String pass = _passEditingController.text;
    http.post(Uri.parse("${Config.server}/homestay/php/register_user.php"),
        body: {
          "name": name,
          "email": email,
          "password": pass,
        }).then((response) {
          print(response.body);
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == 'success') {
         Fluttertoast.showToast(
              msg: "Registeration Success",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 20.0,
            );

        ProgressDialog progressDialog = ProgressDialog(context,
            message: const Text("Redirecting to Login Page...."),
            title: const Text("Register Success"));
        progressDialog.show();
        Future.delayed(const Duration(seconds: 3)).then(
          (value) {
           
            progressDialog.dismiss();
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => const LoginPage()));
          },
        );
        return;
      } else {
        Fluttertoast.showToast(
          msg: "Registeration Failed",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 20.0,
        );
        return;
      }
    });
  }
}
