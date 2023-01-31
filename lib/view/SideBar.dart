import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:homestay/config.dart';
import 'package:homestay/model/user.dart';
import 'package:homestay/view/sellerPage.dart';
import 'package:homestay/view/displayPersonal.dart';
import 'package:http/http.dart' as http;
import 'buyerPage.dart';


class SideBar extends StatefulWidget {

   SideBar({Key? key, required this.user}) :super(key:key);
    late User user;

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
 List userlist =[];
@override
  void initState() {
   
    super.initState();
       _loadUser();
  }

  @override
  Widget build(BuildContext context) {
    var email = widget.user.email;
    var name = widget.user.name;
    return Drawer(
    
      width: 220,
      child: ListView(
        padding: EdgeInsets.zero,
        
        children:  [
          UserAccountsDrawerHeader(
            accountName: Text('$name'), 
            accountEmail: Text('$email'),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.asset('assets/images/defaultUser.jpg',
                width: 200,
                height: 200,
                fit: BoxFit.cover,
                )
              ),
            ),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.jpg'),
                fit: BoxFit.cover,
              )
            ),
            ),
          ListTile(
            leading: const Icon(Icons.account_circle),
            title: const Text("Buyer"),
            onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => BuyerPage(user:widget.user))),
        ),
          
          ListTile(
             leading: const Icon(Icons.sell),
            title:  const Text("Seller"),
            onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => SellerPage(user:widget.user))),
          ),
          ListTile(
             leading: const Icon(Icons.info),
            title: const Text("Account Info"),
            onTap: ()=> Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => DisplayPersonal(user: widget.user,))),
          )
        ],
      ),
    );
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

        ;
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