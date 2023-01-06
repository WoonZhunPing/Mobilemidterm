import 'package:flutter/material.dart';
import 'package:homestay/model/user.dart';
import 'package:homestay/view/sellerPage.dart';

import 'buyerPage.dart';


class SideBar extends StatelessWidget {
  final User user;
  const SideBar({Key? key, required this.user}) :super(key:key);


  @override
  Widget build(BuildContext context) {
    var email = user.email;
    var name = user.name;
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
                image: NetworkImage(
                  "https://thumbs.dreamstime.com/b/great-view-out-hotel-room-night-helsinki-espoo-finland-amazing-hotelroom-vacation-goals-contrast-wallpaper-177156999.jpg"
                ),
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
                builder: (BuildContext context) => BuyerPage(user:user))),
        ),
          
          ListTile(
             leading: const Icon(Icons.sell),
            title:  const Text("Seller"),
            onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => SellerPage(user:user))),
          ),
          ListTile(
             leading: const Icon(Icons.info),
            title: const Text("Account Info"),
            onTap: ()=> null,
          )
        ],
      ),
    );
  }
}