class Product {

  int id;
  String name;
  String quantity;
  String priority;
  int status;
  int toBuy;

  Product({this.name, this.quantity, this.priority, this.status, this.toBuy});

  Product.withId({this.id, this.name, this.quantity, this.priority, this.status, this.toBuy});

  Map<String, dynamic> toMap(){
    final map = Map<String, dynamic>();

    if(id != null)
    {
      map['id'] = id;
    }

    map['name'] = name;
    map['quantity'] = quantity;
    map['priority'] = priority;
    map['status'] = status;
    map['toBuy'] = toBuy;

    return map;
  }


  factory Product.fromMap( Map<String, dynamic> map ){
    return  Product.withId(
        id: map['id'],
        name: map['name'],
        quantity: map['quantity'],
        priority: map['priority'],
        status: map['status'],
        toBuy: map['toBuy']
    );
  }

}