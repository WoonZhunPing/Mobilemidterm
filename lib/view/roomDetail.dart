import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../config.dart';
import '../model/room.dart';
import '../model/user.dart';

class RoomDetail extends StatelessWidget {
  RoomDetail({Key? key, required this.user, required this.room})
      : super(key: key);

  final Room room;

  final User user;
  final df = DateFormat('dd/MM/yyyy');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(24, 24, 32, 1),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(24, 24, 32, 1),
        title: const Text("Room Information"),
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 5,
            ),
            Flexible(
              flex: 5,
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl:
                    "${Config.server}/homestay/assets/roomImages/${room.roomId}_1.png",
                placeholder: (context, url) => const LinearProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
            Flexible(
              flex: 6,
              child: Container(
                padding: const EdgeInsets.only(left: 5.0),
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 5.0, top: 8.0, right: 8.0, bottom: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          room.roomName.toString(),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 13,
                        ),
                        RichText(
                          text: TextSpan(
                            text: 'Owner : ',
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 15),
                            children: <TextSpan>[
                              TextSpan(
                                // later change to username using query 
                                  text: room.userId.toString(),
                                  style: const TextStyle(
                                      color: Color.fromRGBO(44, 107, 242, 1))),
                            ],
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            text: 'Registered Date : ',
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 15),
                            children: <TextSpan>[
                              TextSpan(
                                  text: room.roomRegDate.toString(),
                                  style: const TextStyle(
                                      color: Color.fromRGBO(44, 107, 242, 1))),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          room.roomDesc.toString(),
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const Text(
                          "REVIEW",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Container(
                          padding: const EdgeInsets.all(3),
                          margin: const EdgeInsets.only(top: 1),
                          width: MediaQuery.of(context).size.width,
                          decoration: const BoxDecoration(
                            color: Color.fromRGBO(31, 57, 77, 0.5),
                          ),
                          height: 30,
                          child: RichText(
                            text: const TextSpan(
                              text: 'Mostly Positive : ',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 15),
                              children: <TextSpan>[
                                TextSpan(
                                    text: "(87% of 20) All Time",
                                    style: TextStyle(
                                        color:
                                            Color.fromRGBO(44, 107, 242, 1))),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                          child: Padding(
                            padding: EdgeInsets.only(top: 10.0),
                            child: Text(
                              "Location",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 15),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(3),
                          margin: const EdgeInsets.only(top: 1),
                          width: MediaQuery.of(context).size.width,
                          decoration: const BoxDecoration(
                            color: Color.fromRGBO(31, 57, 77, 0.5),
                          ),
                          height: 45,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                  text: 'State : ',
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 15),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: room.roomState.toString(),
                                        style: const TextStyle(
                                            color: Color.fromRGBO(
                                                44, 107, 242, 1))),
                                  ],
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  text: 'Locality : ',
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 15),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: room.roomLocality.toString(),
                                        style: const TextStyle(
                                            color: Color.fromRGBO(
                                                44, 107, 242, 1))),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(
                          height: 30,
                          child: Padding(
                            padding: EdgeInsets.only(top: 10.0),
                            child: Text(
                              "More Room Info",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 15),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(3),
                          margin: const EdgeInsets.only(top: 1),
                          width: MediaQuery.of(context).size.width,
                          decoration: const BoxDecoration(
                            color: Color.fromRGBO(31, 57, 77, 0.5),
                          ),
                          height: 45,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                  text: 'Category : ',
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 15),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: room.roomCategory.toString(),
                                        style: const TextStyle(
                                            color: Color.fromRGBO(
                                                44, 107, 242, 1))),
                                  ],
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  text: 'Property : ',
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 15),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: room.roomProperty.toString(),
                                        style: const TextStyle(
                                            color: Color.fromRGBO(
                                                44, 107, 242, 1))),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        //if got time change to a box that have a reserve button
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Price per day: RM ${double.parse(room.roomPrice.toString()).toStringAsFixed(2)}",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 15),
                        ),

                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          
                        "More information, please contact :" ,
                          style: TextStyle(
                              color: Colors.white, fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ]),
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
}
