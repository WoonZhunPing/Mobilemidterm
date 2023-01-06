import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:homestay/model/user.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:homestay/view/sellerPage.dart';
import 'package:http/http.dart'as http;
import 'package:ndialog/ndialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import 'package:homestay/config.dart';



class AddHomeStay extends StatefulWidget {
    final Position position;
 final List<Placemark> placemarks;
  const AddHomeStay({Key? key, required this.user, required this.position,
        required this.placemarks}) : super(key: key);
  final User user;

  @override
  State<AddHomeStay> createState() => _AddHomeStayState();
}

class _AddHomeStayState extends State<AddHomeStay> {


    
 

  final _formKey = GlobalKey<FormState>();
  File? image;
  File? image1;
  File? image2;
  var pathAsset = "assets/images/sampleRoom.jpg";

  String? dropdownvalueCategory;
  String? dropdownvalueProperty;

  var category = [
    'Shared Room',
    'Private Room',
    'Whole Place',
  ];

  var property = ['Landed house', 'Bungolow', 'Apartment', 'Others'];

  final focusPlaceName = FocusNode();
  final focusPlaceDesc = FocusNode();
  final focusState = FocusNode();
  final focusLocality = FocusNode();
  final focusPrice = FocusNode();

  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _descriptionController = TextEditingController();

  final TextEditingController _stateController = TextEditingController();

  final TextEditingController _localityController = TextEditingController();

  final TextEditingController _priceController = TextEditingController();

  var _lat, _lng;

   @override
  void initState() {
    super.initState();
    
     _lat = widget.position.latitude.toString();
    _lng = widget.position.longitude.toString();

    _stateController.text = widget.placemarks[0].administrativeArea.toString();
    _localityController.text = widget.placemarks[0].locality.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(24, 24, 32, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(24, 24, 32, 1),
        title: const Text('Add Home Stay'),
      ),
      body: Center(
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                       Container(
                        width: 300,
                        height: 150,
                         child: GestureDetector(
                              onTap: selectImage,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                                child: Card(
                                  child: Container(
                                      decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: image == null
                                          ? AssetImage(pathAsset)
                                          : FileImage(image!) as ImageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  )),
                                ),
                              ),  
                            ),
                       ),
                     
                        Container(
                           width: 300,
                        height: 150,
                          child: GestureDetector(
                              onTap: selectImage1,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                                child: Card(
                                  child: Container(
                                      decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: image1 == null
                                          ? AssetImage(pathAsset)
                                          : FileImage(image1!) as ImageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  )),
                                ),
                              ),
                            ),
                        ),

                          Container(
                        width: 300,
                        height: 150,
                         child: GestureDetector(
                              onTap: selectImage2,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                                child: Card(
                                  child: Container(
                                      decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: image2 == null
                                          ? AssetImage(pathAsset)
                                          : FileImage(image2!) as ImageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  )),
                                ),
                              ),  
                            ),
                       ),
                     
                    ],
                  
                
              ),
            ),
            Flexible(
                flex: 6,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 10, bottom: 10),
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                if (value!.isEmpty || (value.length) <= 5) {
                                  return "Place name must longer than 5 characters";
                                }
                                return null;
                              },
                              onFieldSubmitted: (v) {
                                FocusScope.of(context)
                                    .requestFocus(focusPlaceName);
                              },
                              controller: _nameController,
                              style: const TextStyle(
                                color: Colors.grey,
                              ),
                              decoration: const InputDecoration(
                                icon: Icon(
                                  Icons.holiday_village,
                                  color: Colors.white,
                                ),
                                labelText: 'Place Name',
                                labelStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 203, 200, 200)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    borderSide: BorderSide(
                                        width: 2, color: Colors.grey)),
                                contentPadding: EdgeInsets.all(10),
                                border: OutlineInputBorder(
                                  gapPadding: 10,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10, bottom: 10),
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                if (value!.isEmpty || (value.length) <= 10) {
                                  return "Place Desciption must longer than 10 characters";
                                }
                                return null;
                              },
                              onFieldSubmitted: (v) {
                                FocusScope.of(context)
                                    .requestFocus(focusPlaceDesc);
                              },
                              controller: _descriptionController,
                              style: const TextStyle(
                                color: Colors.grey,
                              ),
                              maxLines: 3,
                              decoration: const InputDecoration(
                                icon: Icon(
                                  Icons.description,
                                  color: Colors.white,
                                ),
                                labelText: 'Place Description',
                                labelStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 203, 200, 200)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    borderSide: BorderSide(
                                        width: 2, color: Colors.grey)),
                                contentPadding: EdgeInsets.all(10),
                                border: OutlineInputBorder(
                                  gapPadding: 10,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                              ),
                            ),
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 2.0, color: Colors.grey),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5.0) //
                                      ),
                                  color: const Color.fromRGBO(24, 24, 32, 1),
                                ),
                                child: DropdownButton(
                                  hint: const Text(
                                    "Category",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5.0)),
                                  dropdownColor:
                                      const Color.fromRGBO(24, 24, 32, 1),
                                  style: const TextStyle(color: Colors.white),
                                  value: dropdownvalueCategory,

                                  icon: const Icon(Icons.keyboard_arrow_down),

                                  // Array list of items
                                  items: category.map((String items) {
                                    return DropdownMenuItem(
                                      value: items,
                                      child: Text(items),
                                    );
                                  }).toList(),

                                  // After selecting the desired option,it will
                                  // change button value to selected value
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      dropdownvalueCategory = newValue!;
                                    });
                                  },
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 2.0, color: Colors.grey),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5.0) //
                                      ),
                                  color: const Color.fromRGBO(24, 24, 32, 1),
                                ),
                                child: DropdownButton(
                                  hint: const Text(
                                    "Property",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5.0)),
                                  dropdownColor:
                                      const Color.fromRGBO(24, 24, 32, 1),
                                  style: const TextStyle(color: Colors.white),
                                  value: dropdownvalueProperty,

                                  icon: const Icon(Icons.keyboard_arrow_down),

                                  // Array list of items
                                  items: property.map((String items) {
                                    return DropdownMenuItem(
                                      value: items,
                                      child: Text(items),
                                    );
                                  }).toList(),
                                  // After selecting the desired option,it will
                                  // change button value to selected value
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      dropdownvalueProperty = newValue!;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),

                          Container(
                            margin: const EdgeInsets.only(top: 10, bottom: 10),
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Price must contain only values";
                                }
                                return null;
                              },
                              onFieldSubmitted: (v) {
                                FocusScope.of(context).requestFocus(focusPrice);
                              },
                              controller: _priceController,
                              style: const TextStyle(
                                color: Colors.grey,
                              ),
                              decoration: const InputDecoration(
                                icon: Icon(
                                  Icons.price_change_outlined,
                                  color: Colors.white,
                                ),
                                labelText: 'Price per night',
                                labelStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 203, 200, 200)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    borderSide: BorderSide(
                                        width: 2, color: Colors.grey)),
                                contentPadding: EdgeInsets.all(10),
                                border: OutlineInputBorder(
                                  gapPadding: 10,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                              ),
                            ),
                          ),

                          //row for state and locality
                          Row(
                            children: [
                              Flexible(
                          flex: 5,
                          child: TextFormField(
                              textInputAction: TextInputAction.next,
                              validator: (val) =>
                                  val!.isEmpty || (val.length < 3)
                                      ? "Current State"
                                      : null,
                              enabled: false,
                              controller: _stateController,
                                      style: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                      decoration: const InputDecoration(
                                        icon: Icon(
                                          Icons.flag_outlined,
                                          color: Colors.white,
                                        ),
                                        labelText: 'State',
                                        labelStyle: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromARGB(
                                                255, 203, 200, 200)),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                            borderSide: BorderSide(
                                                width: 2, color: Colors.grey)),
                                        contentPadding: EdgeInsets.all(10),
                                        border: OutlineInputBorder(
                                          gapPadding: 10,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                      ),
                                    ),
                                  ),

                              //locality
                              Flexible(
                                  flex: 5,
                        child: TextFormField(
                            textInputAction: TextInputAction.next,
                            enabled: false,
                            validator: (val) => val!.isEmpty || (val.length < 3)
                                ? "Current Locality"
                                : null,
                            controller: _localityController,
                            keyboardType: TextInputType.text,
                                    style: const TextStyle(
                                      color: Colors.grey,
                                    ),
                                    decoration: const InputDecoration(
                                      icon: Icon(
                                        Icons.description,
                                        color: Colors.white,
                                      ),
                                      labelText: 'Locality',
                                      labelStyle: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromARGB(
                                              255, 203, 200, 200)),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                          borderSide: BorderSide(
                                              width: 2, color: Colors.grey)),
                                      contentPadding: EdgeInsets.all(10),
                                      border: OutlineInputBorder(
                                        gapPadding: 10,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                    ),
                                  )),
                            ],
                          ),

                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: SizedBox(
                              width: 400,
                              height: 30,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      const MaterialStatePropertyAll(
                                          Color(0xff6750a4)),
                                  shape: MaterialStatePropertyAll<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                          side: const BorderSide(
                                              color: Colors.white))),
                                ),
                                onPressed: _addButton, //add method here
                                child: const Text("Add home stay",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    )),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  void _addButton() {
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

    if (image == null || image1 == null || image2 == null) {
      Fluttertoast.showToast(
          msg: "You need to provide 3 picture of your homestay",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Add new room for homeStay?",
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
                _addNewRoom();
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

  void _addNewRoom() {
    FocusScope.of(context).requestFocus(FocusNode());
    String roomName = _nameController.text;
    String roomDesc = _descriptionController.text;
    String roomCategory = '$dropdownvalueCategory';
    String roomProperty = '$dropdownvalueProperty';
    String roomPrice = _priceController.text;
    String roomState = _stateController.text;
    String roomLocality = _localityController.text;

    String base64Image = base64Encode(image!.readAsBytesSync());
    String base64Image1 = base64Encode(image1!.readAsBytesSync());
    String base64Image2 = base64Encode(image2!.readAsBytesSync());


    http.post(Uri.parse("${Config.server}/homestay/php/addRoom.php"),
    
        body: {
          "roomName": roomName,
          "roomDesc": roomDesc,
          "roomCategory": roomCategory,
          "roomProperty": roomProperty,
          "roomPrice": roomPrice,
          "roomState": roomState,
          "roomLocality": roomLocality,
          "roomLatitude" : _lat,
          "roomLongtitude": _lng,
          "userId" : widget.user.id,
          "image" : base64Image,
          "image1" : base64Image1,
          "image2" : base64Image2,
        }).then((response) {
          
          
      var data =  jsonDecode(response.body);
    

      if (response.statusCode == 200 && data['status'] == 'success') {
         Fluttertoast.showToast(
              msg: "Added Success",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 20.0,
            );

        ProgressDialog progressDialog = ProgressDialog(context,
            message: const Text("Redirecting to Seller Page...."),
            title: const Text("Add Room Success"));
        progressDialog.show();
        Future.delayed(const Duration(seconds: 3)).then(
          (value) {
           
            progressDialog.dismiss();
            Navigator.pop(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => SellerPage(user:widget.user)));
          },
        );
        return;
      } else {
        Fluttertoast.showToast(
          msg: "Homestay add Failed",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 20.0,
        );
        return;
      }
    });
  }

  void selectImage() {
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

   void selectImage1() {
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
                    _selectfromGallery1(),
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


   void selectImage2() {
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
                    _selectfromGallery2(),
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
  Future<void> _selectfromGallery1() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;
    final imageTemporary = File(image.path);
    setState(() => this.image1 = imageTemporary);

  
  }

  Future<void> _selectfromGallery2() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;
    final imageTemporary = File(image.path);
    setState(() => this.image2 = imageTemporary);
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

 
  }

 

