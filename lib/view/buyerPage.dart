import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:homestay/config.dart';
import 'package:homestay/model/room.dart';
import 'package:homestay/model/user.dart';
import 'package:homestay/view/addHomeStay.dart';
import 'package:http/http.dart' as http;
import 'package:ndialog/ndialog.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class BuyerPage extends StatefulWidget {
  const BuyerPage({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  State<BuyerPage> createState() => _BuyerPageState();
}

class _BuyerPageState extends State<BuyerPage> {
 
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

    return Scaffold(
        backgroundColor: const Color.fromRGBO(24, 24, 32, 1),
        appBar: AppBar(
            backgroundColor: const Color.fromRGBO(24, 24, 32, 1),
            title: const Text("Buyer"),
            
            ),
        body: roomlist.isEmpty 
              ? Center(
                  child: Text(titlecenter,
                      style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)))
              : Column(
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
                                const SizedBox(
                                  height: 5,
                                ),
                                Flexible(
                                  flex: 5,
                                  child: CachedNetworkImage(
                                    width: resWidth / 2,
                                    fit: BoxFit.cover,
                                    imageUrl: "${Config.server}/homestay/assets/roomImages/${roomlist[index].roomId}_1.png",
                                    placeholder: (context, url) =>
                                        const LinearProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                ),
                                Flexible(
                                    flex: 4,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Text(
                                            truncateString(
                                                roomlist[index]
                                                    .roomName
                                                    .toString(),
                                                15),
                                            style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                              "RM ${double.parse(roomlist[index].roomPrice.toString()).toStringAsFixed(2)}"),
                                          Text(df.format(DateTime.parse(
                                              roomlist[index]
                                                  .roomRegDate
                                                  .toString()))),
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
        );
  }

  String truncateString(String str, int size) {
    if (str.length > size) {
      str = str.substring(0, size);
      return "$str...";
    } else {
      return str;
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
          "${Config.server}/homestay/php/loadAllRoom.php"),
    )
        .then((response) {
  
      // wait for response from the request
      if (response.statusCode == 200) {
        //if statuscode OK
        var jsondata = jsonDecode(response.body);
       
        //decode response body to jsondata array
        if (jsondata['status'] == 'success') {
          //check if status data array is success
          var extractdata = jsondata['data']; //extract data from jsondata array
          if (extractdata['rooms'] != null) {
            //check if  array object is not null
            roomlist = <Room>[]; //complete the array object definition
            extractdata['rooms'].forEach((v) {
              //traverse products array list and add to the list object array productList
              roomlist.add(Room.fromJson(
                  v)); //add each product array to the list object array productList
            });
            titlecenter = "Found";
          } else {
            titlecenter =
                "No Room Available"; //if no data returned show title center
            roomlist.clear();
          }
        } else {
          titlecenter = "No Room Available";
        }
      } else {
        titlecenter = "No Room Available"; //status code other than 200
        roomlist.clear(); //clear productList array
      }
      setState(() {}); //refresh UI
    });
  }
}
