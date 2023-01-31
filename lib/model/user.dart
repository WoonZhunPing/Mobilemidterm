class User {
  String? id;
  String? name;
  String? email;
  String? regdate;
  String? telephone;

  User(
      {required this.id,
      required this.name,
      required this.email,
      required this.regdate,
      required this.telephone,
      });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    regdate = json['regdate'];
    telephone = json['telephone'];
   
  }

  @override
  String toString() {
    return "($id,$name,$email,$regdate)";
}


 
}