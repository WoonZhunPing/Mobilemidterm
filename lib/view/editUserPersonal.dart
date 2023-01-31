import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:homestay/config.dart';
import 'package:homestay/view/displayPersonal.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ndialog/ndialog.dart';
import 'package:http/http.dart' as http;

import '../model/user.dart';

class EditUserPersonal extends StatefulWidget {
  EditUserPersonal({Key? key, required this.user}) : super(key: key);

  late User user;

  @override
  State<EditUserPersonal> createState() => _EditPersonalState();
}

class _EditPersonalState extends State<EditUserPersonal> {
  List userlist = [];
  File? image;

  final _formKey = GlobalKey<FormState>();
  final focusName = FocusNode();

  final focusEmail = FocusNode();

  final focusTele = FocusNode();

  final TextEditingController _nameEditingController = TextEditingController();

  final TextEditingController _emailEditingController = TextEditingController();

  final TextEditingController _teleEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _nameEditingController.text = widget.user.name.toString();
    _emailEditingController.text = widget.user.email.toString();
    _teleEditingController.text = widget.user.telephone.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(24, 24, 32, 1),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: const Color.fromRGBO(24, 24, 32, 1),
          title: const Text("Edit User Information"),
        ),
        body: SingleChildScrollView(
            child: Center(
                child: Column(children: [
          Container(
            constraints:
                const BoxConstraints(maxHeight: 100.0, maxWidth: 100.0),
            padding: EdgeInsets.zero,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: image == null
                    ? const AssetImage("assets/images/defaultUser.jpg")
                    : FileImage(image!) as ImageProvider,
                fit: BoxFit.contain,
              ),
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Stack(
              children: [
                Positioned(
                  right: 0,
                  bottom: 0.0,
                  child: Container(
                    constraints:
                        const BoxConstraints(maxHeight: 50.0, maxWidth: 50.0),
                    decoration: const BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Color(0xFFdedede), offset: Offset(2, 2)),
                      ],
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: GestureDetector(
                      onTap: () => selectUserImage(),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.photo_camera,
                          size: 20,
                          color: Color(0xFF00cde7),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          Padding(
              padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
              child: SingleChildScrollView(
                  child: Form(
                key: _formKey,
                child: Column(children: [
                  // This is for name
                  Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 10),
                    child: TextFormField(
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty || (value.length) <= 5) {
                          return "Name must longer than 5 characters";
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
                        icon: Icon(
                          Icons.account_box_sharp,
                          color: Colors.white,
                        ),
                        labelText: 'User Name',
                        labelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 203, 200, 200)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide:
                                BorderSide(width: 2, color: Colors.grey)),
                        contentPadding: EdgeInsets.all(10),
                        border: OutlineInputBorder(
                          gapPadding: 10,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                    ),
                  ),

                  //This is for email address
                  Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 10),
                    child: TextFormField(
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (!(value!.contains('@')) || !(value.contains('.'))) {
                          return "A valid email address must contain @ and dot.";
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
                        icon: Icon(
                          Icons.email,
                          color: Colors.white,
                        ),
                        labelText: 'Email Address',
                        labelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 203, 200, 200)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide:
                                BorderSide(width: 2, color: Colors.grey)),
                        contentPadding: EdgeInsets.all(10),
                        border: OutlineInputBorder(
                          gapPadding: 10,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                    ),
                  ),

                  //This is for phone numbers
                  Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 10),
                    child: TextFormField(
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty || (value.length) <= 9) {
                          return "Phone Number must at least 9 numbers";
                        }
                        return null;
                      },
                      onFieldSubmitted: (v) {
                        FocusScope.of(context).requestFocus(focusTele);
                      },
                      controller: _teleEditingController,
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                      decoration: const InputDecoration(
                        icon: Icon(
                          Icons.phone_in_talk_outlined,
                          color: Colors.white,
                        ),
                        labelText: 'Telephone Number',
                        labelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 203, 200, 200)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide:
                                BorderSide(width: 2, color: Colors.grey)),
                        contentPadding: EdgeInsets.all(10),
                        border: OutlineInputBorder(
                          gapPadding: 10,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                    ),
                  ),

                  //This is edit button
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: SizedBox(
                      width: 400,
                      height: 30,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              const MaterialStatePropertyAll(Color(0xff6750a4)),
                          shape: MaterialStatePropertyAll<
                                  RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: const BorderSide(color: Colors.white))),
                        ),
                        onPressed: editProfile,
                        child: const Text("Edit Profile",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            )),
                      ),
                    ),
                  ),
                ]),
              )))
        ]))));
  }

  void editProfile() async {
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

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Edit personal information?",
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
                _editUserInfo();
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

  void _editUserInfo() {
    FocusScope.of(context).requestFocus(FocusNode());
    String name = _nameEditingController.text;
    String email = _emailEditingController.text;
    String telephone = _teleEditingController.text;

    //image ??= File('${Config.server}/homestay/assets/userProfileImages/defaultUser.jpg');
    //String base64Image = base64Encode(image!.readAsBytesSync());

    http.post(Uri.parse("${Config.server}/homestay/php/editUserProfile.php"),
        body: {
          "userName": name,
          "userEmail": email,
          "telephone": telephone,
          //"image": base64Image,
          "userId": widget.user.id,
        }).then((response) {
      var data = jsonDecode(response.body);
 
      if (response.statusCode == 200 && data['status'] == 'success') {
        Fluttertoast.showToast(
          msg: "Edit Success",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 20.0,
        );

        ProgressDialog progressDialog = ProgressDialog(context,
            message: const Text("Redirecting to User Profile Page...."),
            title: const Text("Edit Profile Success"));
        progressDialog.show();
        Future.delayed(const Duration(seconds: 3)).then(
          (value) {
             _loadUser();
           
           
            progressDialog.dismiss();
             
         
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        DisplayPersonal(user: widget.user)));
          }
          
        );
        return;
      } else {
        Fluttertoast.showToast(
          msg: "Profile Edit Failed",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 20.0,
        );
        return;
      }
    });
  }

  void selectUserImage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
            title: const Text(
              "Select from",
              style: TextStyle(),
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(fixedSize: const Size(90, 100)),
                  child: const Text('Gallery'),
                  onPressed: () => {
                    Navigator.of(context).pop(),
                    _selectfromGallery(),
                  },
                ),
                ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(fixedSize: const Size(90, 100)),
                  child: const Text('Camera'),
                  onPressed: () => {
                    Navigator.of(context).pop(),
                    _selectFromCamera(),
                  },
                )
              ],
            ));
      },
    );
  }

  Future<void> _selectfromGallery() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;
    final imageTemporary = File(image.path);
    setState(() => this.image = imageTemporary);
  }

  Future<void> _selectFromCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 800,
      maxWidth: 800,
    );
    if (pickedFile != null) {
      //_image = File(pickedFile.path);
    } else {
      print('No image selected.');
    }
  }

  _loadUser() async {
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
