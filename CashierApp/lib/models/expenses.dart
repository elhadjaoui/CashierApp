class Expenses {
  int id;
  double price;
  String name;
  DateTime creationDate;


  Expenses(
      {this.id,
        this.price,
        this.name,
        this.creationDate,
      });

  factory Expenses.fromMap(Map<String, dynamic> json) => Expenses(
    id: json["id"],
    price: json["price"],
    name: json["name"],
    creationDate: DateTime.parse(json["creationDate"]),

  );
  Map<String, dynamic> toMap() => {
    "id": id,
    "price": price,
    "name": name,
    "creationDate": creationDate.toIso8601String(),
  };
}