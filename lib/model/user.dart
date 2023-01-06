class User {
  String? id;
  String? name;
  String? email;
  String? regdate;

  User(
      {required this.id,
      required this.name,
      required this.email,
      required this.regdate,
      });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    regdate = json['regdate'];
   
  }

  String toString() {
    return "($id,$name,$email,$regdate)";
}


 
}