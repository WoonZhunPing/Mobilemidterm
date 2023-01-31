import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:homestay/config.dart';
import 'package:homestay/view/editUserPersonal.dart';
import 'package:http/http.dart' as http;


import '../model/user.dart';

// ignore: must_be_immutable
class DisplayPersonal extends StatefulWidget {
  DisplayPersonal({Key? key, required this.user}) : super(key: key);

  late User user;

  @override
  State<DisplayPersonal> createState() => _DisplayPersonalState();
}

class _DisplayPersonalState extends State<DisplayPersonal> {


 @override
  void initState() {
    super.initState();
  
    _loadUser();
   
  }

  List userlist =[];
  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
        backgroundColor: const Color.fromRGBO(24, 24, 32, 1),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: const Color.fromRGBO(24, 24, 32, 1),
          title: const Text("User Information"),
           actions: <Widget>[
              Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                    onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => EditUserPersonal(user:widget.user))),
                    child: const Icon(
                      Icons.edit,
                      size: 26.0,
                    ),
                  )),
            ]
        ),
        body: SingleChildScrollView(
            child: Center(
          child: Column(children: [
            Container(
              height: 100,
              padding: EdgeInsets.zero,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/defaultUser.jpg"),
                  fit: BoxFit.contain,
                ),
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
            // create space between profile pic and name
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 50,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.user.name.toString(),
                        style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),

//This is for Account Detials
            Column(
              children: [
                Container(
                  height: 30,
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(94, 163, 247, 1),
                  ),
                  child: Row(
                    children: const [
                      SizedBox(width: 10),
                      Icon(
                        Icons.account_circle_rounded,
                        color: Colors.white,
                      ),
                      SizedBox(width: 10),
                      Text(
                        "ACCOUNT DETAILS",
                        style: TextStyle(
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(31, 57, 77, 0.5),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const SizedBox(
                            width: 10,
                            height: 40,
                          ),
                          RichText(
                            text: TextSpan(
                              text: 'User Name : ',
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 15),
                              children: <TextSpan>[
                                TextSpan(
                                    text: widget.user.name.toString(),
                                    style: const TextStyle(
                                        color:
                                            Color.fromRGBO(44, 107, 242, 1))),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const SizedBox(
                            width: 10,
                            height: 40,
                          ),
                          RichText(
                            text: TextSpan(
                              text: 'Joined on : ',
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 15),
                              children: <TextSpan>[
                                TextSpan(
                                    text: widget.user.regdate.toString(),
                                    style: const TextStyle(
                                        color:
                                            Color.fromRGBO(44, 107, 242, 1))),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
//This sizedbox is used to create space between two things(Account detail and contact info)
            const SizedBox(
              height: 20,
            ),

            // This is for contact information
            Column(
              children: [
                Container(
                  height: 30,
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(94, 163, 247, 1),
                  ),
                  child: Row(
                    children: const [
                      SizedBox(width: 10),
                      Icon(
                        Icons.mail,
                        color: Colors.white,
                      ),
                      SizedBox(width: 10),
                      Text(
                        "CONTACT INFO",
                        style: TextStyle(
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(31, 57, 77, 0.5),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const SizedBox(
                            width: 10,
                            height: 40,
                          ),
                          RichText(
                            text: TextSpan(
                              text: 'Email Address : ',
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 15),
                              children: <TextSpan>[
                                TextSpan(
                                    text: widget.user.email.toString(),
                                    style: const TextStyle(
                                        color:
                                            Color.fromRGBO(44, 107, 242, 1))),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const SizedBox(
                            width: 10,
                            height: 40,
                          ),
                          RichText(
                            text: TextSpan(
                              text: 'Telephone Number : ',
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 15),
                              children: <TextSpan>[
                                TextSpan(
                                    text: widget.user.telephone.toString(),
                                    style: const TextStyle(
                                        color:
                                            Color.fromRGBO(44, 107, 242, 1))),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ]),
        )));
  }

   _loadUser() {
    if (widget.user.email == "na") {
      return;
    }

    http
        .get(Uri.parse(
            "${Config.server}/homestay/php/loadUser.php?userId=${widget.user.id}"))
        .then((response) {
      // wait for response from the request
      if (response.statusCode == 200) {
        //if statuscode OK
        var jsondata = jsonDecode(response.body);

         setState(() {});
        //decode response body to jsondata array
        if (jsondata['status'] == 'success') {
          //check if status data array is success
          var extractdata = jsondata['data']; //extract data from jsondata array
          if (extractdata['users'] != null) {
            //check if  array object is not null
            userlist = <User>[]; //complete the array object definition
            extractdata['users'].forEach((v) {
              userlist.add(User.fromJson(v));
            });
          }
        } else {
          userlist.clear();
        }
        setState(() {
          widget.user = userlist[0];
        
        }); //refresh UI
      }
      });
    }
  }


