class UserInfo {
  int id;
  String name;
  DateTime creationDate;


  UserInfo(
      {this.id,
      this.name,
      this.creationDate,
     });

  factory UserInfo.fromMap(Map<String, dynamic> json) => UserInfo(
        id: json["id"],
        name: json["name"],
        creationDate: DateTime.parse(json["creationDate"]),

      );
  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "creationDate": creationDate.toIso8601String(),
      };
}
class UserDetailsInfo {
  int id;
  String name;
  String product;
  String condition;
  double price;
  int total;
  DateTime creationDate;


  UserDetailsInfo(
      {this.id,
        this.name,
        this.product,
        this.condition,
        this.price,
        this.total,
        this.creationDate,
      });

  factory UserDetailsInfo.fromMap(Map<String, dynamic> json) => UserDetailsInfo(
    id: json["id"],
    name: json["name"],
    product: json['product'],
    condition: json['condition'],
    price: json['price'],
    total: json['total'],
    creationDate: DateTime.parse(json["creationDate"]),

  );
  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "product":product,
    "condition": condition,
    "price": price,
    "total": total,
    "creationDate": creationDate.toIso8601String(),
  };
}