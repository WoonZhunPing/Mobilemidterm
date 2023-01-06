import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:homestay/model/user.dart';
import 'package:homestay/view/mainPage.dart';
import 'package:http/http.dart' as http;
import 'package:ndialog/ndialog.dart';

import '../config.dart';
import 'registerPage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscureText = true;
  final focusEmail = FocusNode();
  final focusPass = FocusNode();
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _passEditingController = TextEditingController();
  late final User user;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(24, 24, 32, 1),
      body: Center(
        child: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Sign in',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(10, 40, 10, 10),
                  child: TextFormField(
                    textInputAction: TextInputAction.next,
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
                  margin: const EdgeInsets.fromLTRB(10, 10, 10, 20),
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
                  margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                  child: SizedBox(
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
                      onPressed: goHomePage,
                      child: const Text("Sign In",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          )),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Dont have an account? ',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                    GestureDetector(
                        onTap: () => {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          const RegisterPage()))
                            },
                        child: const Text('Create Account',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ))),
                  ],
                ),
                Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: const Text(
                      "Forget Password?",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  void goHomePage() {
    FocusScope.of(context).requestFocus(FocusNode());
    String email = _emailEditingController.text;
    String pass = _passEditingController.text;
    http.post(Uri.parse("${Config.server}/homestay/php/login_user.php"),
        body: {
          "email": email,
          "password": pass,
        }).then((response) {
          
          var data = jsonDecode(response.body);
          //print(data);
      if (response.statusCode == 200 && response.body != "failed" && data['status'] == 'success') {
        final jsonResponse = json.decode(response.body);
        User user = User.fromJson(jsonResponse['data']);
        
        ProgressDialog progressDialog = ProgressDialog(context,
            message: const Text("Please wait.."),
            title: const Text("Login user"));
        progressDialog.show();
        Future.delayed(const Duration(seconds: 3)).then((value) {
           Fluttertoast.showToast(
            msg: "Login Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
            
 progressDialog.dismiss();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => MainPage(user:user)));
         },);
       
      }else{
        
         ProgressDialog progressDialog = ProgressDialog(context,
            message: const Text("Please wait.."),
            title: const Text("Login user"));
        progressDialog.show();
        Future.delayed(const Duration(seconds: 3)).then((value) {
           Fluttertoast.showToast(
            msg: "Login Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
             progressDialog.dismiss();
        });
      
      }
    });
  }
}
