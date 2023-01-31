class Room {
  String? roomId;
  String? roomName;
  String? roomDesc;
  String? roomCategory;
  String? roomProperty; 
  String? roomPrice;
  String? roomState;
  String? roomLocality;
  String? roomLatitude;
  String? roomLongitude;
  String? roomRegDate;
  String? userId;
  

  Room(
      {required this.roomId,
      required this.roomName,
      required this.roomDesc,
      required this.roomCategory,
      required this.roomProperty,
      required this.roomPrice,
      required this.roomState,
      required this.roomLocality,
      required this.roomRegDate,
      required this.roomLatitude,
      required this.roomLongitude,
      required this.userId,
      });

  Room.fromJson(Map<String, dynamic> json) {
    roomId = json['roomId'];
    roomName = json['roomName'];
    roomDesc = json['roomDesc'];
    roomCategory = json['roomCategory'];
    roomProperty = json['roomProperty'];
    roomPrice = json['roomPrice'];
    roomState = json['roomState'];
    roomLocality = json['roomLocality'];
    roomLatitude = json['roomLatitude'];
    roomLongitude = json['roomLongitude'];
    roomRegDate = json['roomRegDate'];
    userId = json['userId'];
    
   
  }
    Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['roomId'] = roomId;
    data['roomName'] = roomName;
    data['roomDesc'] = roomDesc;
    data['roomCategory'] = roomCategory;
    data['roomProperty'] = roomProperty;
    data['roomPrice'] = roomPrice;
    data['roomState'] = roomState;
    data['roomLocality'] = roomLocality;
    data['roomLatititude'] = roomLatitude;
    data['roomLongtitude'] = roomLongitude;
    data['roomRegDate'] = roomRegDate;
    data['userId'] = userId;
    
    return data;
  }

  @override
  String toString() {
    return "($roomId,$roomName,$roomDesc,$roomCategory,$roomProperty,$roomPrice,$roomState,$roomLocality,$roomRegDate)";
}


 
}