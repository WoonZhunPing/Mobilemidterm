import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:homestay/config.dart';
import 'package:homestay/model/room.dart';
import 'package:homestay/model/user.dart';
import 'package:homestay/view/addHomeStay.dart';
import 'package:homestay/view/editSellerRoom.dart';
import 'package:http/http.dart' as http;
import 'package:ndialog/ndialog.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class SellerPage extends StatefulWidget {
  const SellerPage({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  State<SellerPage> createState() => _SellerPageState();
}

class _SellerPageState extends State<SellerPage> {
  var _lat, _lng;
  late Position _position;
  var placemarks;
  int rowcount = 2;
  late double screenHeight, screenWidth, resWidth;

  final df = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
    _loadHomestays();
  }

  List roomlist = [];
  String titlecenter = "Loading data...";

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth <= 600) {
      resWidth = screenWidth;
      rowcount = 2;
    } else {
      resWidth = screenWidth * 0.75;
      rowcount = 3;
    }

    var email = widget.user.email;
    var name = widget.user.name;
    return Scaffold(
        backgroundColor: const Color.fromRGBO(24, 24, 32, 1),
        appBar: AppBar(
            backgroundColor: const Color.fromRGBO(24, 24, 32, 1),
            title: const Text("Seller"),
            actions: <Widget>[
              Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                    onTap: () => _gotoNewHomestay(),
                    child: const Icon(
                      Icons.add,
                      size: 26.0,
                    ),
                  )),
            ]),
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
            SizedBox(
              height: 100,
              child: UserAccountsDrawerHeader(
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(24, 24, 32, 1),
                ),
                accountName: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$name',
                      style: const TextStyle(
                          fontSize: 26, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                accountEmail: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$email',
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(
              height: 5,
              thickness: 5,
              indent: 0,
              endIndent: 0,
              color: Colors.black,
            ),
            roomlist.isEmpty
                ? Center(
                    child: Text(titlecenter,
                        style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)))
                : SizedBox(
                    height: 450,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Your current available rooms (${roomlist.length} found)",
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                        Expanded(
                          child: GridView.count(
                            crossAxisCount: rowcount,
                            children: List.generate(roomlist.length, (index) {
                              return Card(
                                elevation: 8,
                                child: InkWell(
                                  onTap: null,
                                  onLongPress: null,
                                  child: Column(children: [
                                    const SizedBox(),
                                    Flexible(
                                      flex: 5,
                                      child: CachedNetworkImage(
                                        width: resWidth / 2,
                                        fit: BoxFit.cover,
                                        imageUrl:
                                            "${Config.server}/homestay/assets/roomImages/${roomlist[index].roomId}_1.png",
                                        placeholder: (context, url) =>
                                            const LinearProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ),
                                    ),
                                    Flexible(
                                        flex: 7,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              Text(
                                                truncateString(
                                                    roomlist[index]
                                                        .roomName
                                                        .toString(),
                                                    13),
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                  "RM ${double.parse(roomlist[index].roomPrice.toString()).toStringAsFixed(2)}"),
                                              Text(df.format(DateTime.parse(
                                                  roomlist[index]
                                                      .roomRegDate
                                                      .toString()))),
                                              Row(
                                                children: [
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            right: 7),
                                                    width: resWidth / 5,
                                                    child: GestureDetector(
                                                      onTap: () =>
                                                          _editHomeStay(index),
                                                      child: const Icon(
                                                        Icons.edit,
                                                        size: 20.0,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: resWidth / 5,
                                                    child: GestureDetector(
                                                      onTap: () =>
                                                          _deleteRoom(index),
                                                      child: const Icon(
                                                        Icons.delete,
                                                        size: 20.0,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ))
                                  ]),
                                ),
                              );
                            }),
                          ),
                        )
                      ],
                    ),
                  ),
          ])),
        ));
  }

  String truncateString(String str, int size) {
    if (str.length > size) {
      str = str.substring(0, size);
      return "$str...";
    } else {
      return str;
    }
  }

//check permission, get location, get address return false if any problem.
  Future<bool> _checkPermissionGetLoc() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Fluttertoast.showToast(
            msg: "Please allow the app to access the location",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
        Geolocator.openLocationSettings();
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(
          msg: "Please allow the app to access the location",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      Geolocator.openLocationSettings();
      return false;
    }

    _position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);

    try {
      placemarks = await placemarkFromCoordinates(
          _position.latitude, _position.longitude);
    } catch (e) {
      Fluttertoast.showToast(
          msg:
              "Error in fixing your location. Make sure internet connection is available and try again.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return false;
    }
    return true;
  }

  Future<void> _gotoNewHomestay() async {
    if (widget.user.id == "0") {
      Fluttertoast.showToast(
          msg: "Please login/register",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return;
    }

    ProgressDialog progressDialog = ProgressDialog(
      context,
      blur: 10,
      message: const Text("Searching your current location"),
      title: null,
    );
    progressDialog.show();

    if (await _checkPermissionGetLoc()) {
      progressDialog.dismiss();
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (content) => AddHomeStay(
                  position: _position,
                  user: widget.user,
                  placemarks: placemarks)));
      _loadHomestays();
    } else {
      Fluttertoast.showToast(
          msg: "Please allow the app to access the location",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
    }
  }

  _loadHomestays() {
    if (widget.user.email == "na") {
      setState(() {
        titlecenter = "Unregistered User";
      });
      return;
    }

    http
        .get(
      Uri.parse(
          "${Config.server}/homestay/php/loadRoom.php?userid=${widget.user.id}"),
    )
        .then((response) {
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);

        if (jsondata['status'] == 'success') {
          var extractdata = jsondata['data'];
          if (extractdata['rooms'] != null) {
            roomlist = <Room>[];
            extractdata['rooms'].forEach((values) {
              roomlist.add(Room.fromJson(values));
            });
            titlecenter = "Found";
          } else {
            titlecenter = "No Room Available";
            roomlist.clear();
          }
        } else {
          titlecenter = "No Room Available";
        }
      } else {
        titlecenter = "No Room Available";
        roomlist.clear();
      }
      setState(() {
        ProgressDialog progressDialog = ProgressDialog(context,
            message: const Text("Refreshing new room...."),
            title: const Text("Refresh Progress"));
        progressDialog.show();
        Future.delayed(const Duration(seconds: 3)).then(
          (value) {
            progressDialog.dismiss();

            Fluttertoast.showToast(
              msg: "Updated Completed",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 20.0,
            );
          },
        );
        return;
      });
    });
  }

  _deleteRoom(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Delete homeStay?",
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
                _deleteRoomSql(index);
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

  void _deleteRoomSql(int index) {
    String roomId = roomlist[index].roomId;

    http.post(Uri.parse("${Config.server}/homestay/php/deleteRoom.php"), body: {
      "roomId": roomId,
      "userId": widget.user.id,
    }).then((response) {
      var data = jsonDecode(response.body);

      setState(() {});
      if (response.statusCode == 200 && data['status'] == 'success') {
        Fluttertoast.showToast(
          msg: "Delete Success",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 20.0,
        );
        setState(() {
          ProgressDialog progressDialog = ProgressDialog(context,
              message: const Text("Deleting Room...."),
              title: const Text(
                  "Please wait for the deletion process to complete"));
          progressDialog.show();
          Future.delayed(const Duration(seconds: 3)).then((value) {
            progressDialog.dismiss();
            _loadHomestays();
          });
        });
        return;
      } else {
        Fluttertoast.showToast(
          msg: "Homestay delete Failed",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 20.0,
        );
        return;
      }
    });
  }

  _editHomeStay(int index) async {
    if (widget.user.id == "0") {
      Fluttertoast.showToast(
          msg: "Please register an account",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return;
    }
    Room room = Room.fromJson(roomlist[index].toJson());

    //todo update seller object with empty object.
    ProgressDialog progressDialog = ProgressDialog(
      context,
      blur: 5,
      message: const Text("Loading..."),
      title: const Text('Redirecting to edit room'),
    );
    progressDialog.show();
    if (await _checkPermissionGetLoc()) {
      progressDialog.dismiss();

      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (content) => EditSellerRoom(
                  position: _position,
                  user: widget.user,
                  placemarks: placemarks,
                  room: room)));
    } else {
      Fluttertoast.showToast(
          msg: "Please allow the app to access the location",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
    }
    // Timer(const Duration(seconds: 1), () {
    //   progressDialog.dismiss();
    //   Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //           builder: (content) => EditSellerRoom(
    //                 position: _position,
    //                 user: widget.user,
    //                 placemarks: placemarks,
    //                 room: room,
    //               )));

    progressDialog.dismiss();
  }
}
