
import 'package:flutter/material.dart';
import 'package:homestay/model/user.dart';

import 'package:homestay/view/SideBar.dart';


class MainPage extends StatelessWidget {
 
  const MainPage({Key? key, required this.user}) :super(key:key);

 final User user;

  @override
  Widget build(BuildContext context) {
    
   
    return Scaffold(
     
      
       backgroundColor: const Color.fromRGBO(24, 24, 32, 1),
      drawer: SideBar(user: user),
      appBar: AppBar(
        centerTitle: true,
         backgroundColor: const Color.fromRGBO(24, 24, 32, 1),
        title: const Text("HomeStay"),
      ),
      body: const Center(
        
        child: Text("Welcome to the HomeStay Application",
        style: TextStyle(
          color: Colors.white,),
        )
      ),
    );
  }
}