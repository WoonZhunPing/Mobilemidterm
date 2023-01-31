import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:homestay/config.dart';
import 'package:homestay/model/room.dart';
import 'package:homestay/model/user.dart';

import 'package:homestay/view/roomDetail.dart';
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
    var numofpage, curpage = 1;
  int numberofresult = 0;
  var color;

  final df = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
   
    _loadHomestays(1);

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
          actions: <Widget>[
            Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    showSearch(
                      context: context,
                      delegate: MySearchDelegate(user: widget.user),
                    );
                  },
                  child: const Icon(
                    Icons.search,
                    size: 26.0,
                  ),
                )),
          ]),
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
                          onTap: () {
                            _showDetails(index);
                          },
                          child: Column(children: [
                            const SizedBox(
                              height: 5,
                            ),
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
                                flex: 4,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        truncateString(
                                            roomlist[index].roomName.toString(),
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
                ),
 SizedBox(
                      height: 50,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: numofpage,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          //build the list for textbutton with scroll
                          if ((curpage - 1) == index) {
                            //set current page number active
                            color = Colors.yellow;
                          } else {
                            color = Colors.white;
                          }
                          return TextButton(
                              onPressed: () =>
                                  {_loadHomestays(index + 1)},
                              child: Text(
                                (index + 1).toString(),
                                style: TextStyle(color: color, fontSize: 18),
                              ));
                        },
                      ),
                    ),

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

  _loadHomestays(int pageno) {
     curpage = pageno; 
    numofpage ?? 1;
    if (widget.user.email == "na") {
      setState(() {
        titlecenter = "Unregistered User";
      });
      return;
    }

    http
        .get(
      Uri.parse("${Config.server}/homestay/php/loadAllRoom.php?pageno=$pageno"),
    )
        .then((response) {
    
      if (response.statusCode == 200) {
       
        var jsondata = jsonDecode(response.body);

      
        if (jsondata['status'] == 'success') {
         
          var extractdata = jsondata['data']; 
          if (extractdata['rooms'] != null) {
            numofpage = int.parse(jsondata['numofpage']);
            numberofresult = int.parse(jsondata['numberofresult']);
            
            roomlist = <Room>[]; 
            extractdata['rooms'].forEach((v) {
             
              roomlist.add(Room.fromJson(
                  v)); 
            });
            titlecenter = "Found";
          } else {
            titlecenter =
                "No Room Available"; 
            roomlist.clear();
          }
        } else {
          titlecenter = "No Room Available";
        }
      } else {
        titlecenter = "No Room Available"; 
        roomlist.clear(); 
      }
      setState(() {}); 
    });
  }

// This method is used to pass room id and display the room information in the next screen
  _showDetails(int index) async {
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
      title: const Text('Redirecting to room info'),
    );
    progressDialog.show();
    Timer(const Duration(seconds: 1), () {
      progressDialog.dismiss();
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (content) => RoomDetail(
                    user: widget.user,
                    room: room,
                  )));

      progressDialog.dismiss();
    });
  }

}

class MySearchDelegate extends SearchDelegate {
  User user;

  MySearchDelegate({Key? key, required this.user});

  void initState() {}

  List searchlist = [];
  String titlecenter = "Loading data...";
  int rowcount = 2;
  late double screenHeight, screenWidth, resWidth;
  final df = DateFormat('dd/MM/yyyy');

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      appBarTheme: const AppBarTheme(
        backgroundColor: Color.fromRGBO(24, 24, 32, 1),

        //app bar color I wanted
      ),
    );
  }

  @override
  TextStyle get searchFieldStyle => const TextStyle(
        color: Colors.white,
      );

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          icon: const Icon(Icons.clear),
          onPressed: (() {
            if (query.isEmpty) {
              close(context, null);
            } else {
              query = '';
            }
          }))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    _loadResult(query);
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth <= 600) {
      resWidth = screenWidth;
      rowcount = 2;
    } else {
      resWidth = screenWidth * 0.75;
      rowcount = 3;
    }

    // display result put query here
    return Scaffold(
      backgroundColor: const Color.fromRGBO(24, 24, 32, 1),
      body: searchlist.isEmpty
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
                    "Your current available rooms (${searchlist.length} found)",
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: rowcount,
                    children: List.generate(searchlist.length, (index) {
                      return Card(
                        elevation: 8,
                        child: InkWell(
                          onTap: () {
                            _showDetails(index, context, user);
                          },
                          child: Column(children: [
                            const SizedBox(
                              height: 5,
                            ),
                            Flexible(
                              flex: 5,
                              child: CachedNetworkImage(
                                width: resWidth / 2,
                                fit: BoxFit.cover,
                                imageUrl:
                                    "${Config.server}/homestay/assets/roomImages/${searchlist[index].roomId}_1.png",
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
                                            searchlist[index]
                                                .roomName
                                                .toString(),
                                            15),
                                        style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                          "RM ${double.parse(searchlist[index].roomPrice.toString()).toStringAsFixed(2)}"),
                                      Text(df.format(DateTime.parse(
                                          searchlist[index]
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

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> suggestions = ["Test", "Walao", "changlun"];

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final suggestion = suggestions[index];

        return ListTile(
          title: Text(suggestion),
          onTap: () {
            query = suggestion;
          },
        );
      },
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

  _loadResult(String querySearch) {
    http
        .get(
      Uri.parse(
          "${Config.server}/homestay/php/searchRoom.php?querySearch=$querySearch"),
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
          if (extractdata['result'] != null) {
            //check if  array object is not null
            searchlist = <Room>[]; //complete the array object definition
            extractdata['result'].forEach((v) {
              //traverse products array list and add to the list object array productList
              searchlist.add(Room.fromJson(
                  v)); //add each product array to the list object array productList
            });
            titlecenter = "Found";
          } else {
            titlecenter =
                "No Room Available"; //if no data returned show title center
            searchlist.clear();
          }
        } else {
          titlecenter = "No Room Available";
        }
      } else {
        titlecenter = "No Room Available"; //status code other than 200
        searchlist.clear(); //clear productList array
      }
      //setState(() {}); //refresh UI
    });
  }

  _showDetails(int index, BuildContext context, User user) async {
    Room room = Room.fromJson(searchlist[index].toJson());

    //todo update seller object with empty object.
    ProgressDialog progressDialog = ProgressDialog(
      context,
      blur: 5,
      message: const Text("Loading..."),
      title: const Text('Redirecting to room info'),
    );
    progressDialog.show();
    Timer(const Duration(seconds: 1), () {
      progressDialog.dismiss();
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (content) => RoomDetail(
                    user: user,
                    room: room,
                  )));

      progressDialog.dismiss();
    });
  }
}
