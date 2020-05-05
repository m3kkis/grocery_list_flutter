class Product {

  int id;
  String name;
  String quantity;
  String priority;
  int status;
  int toBuy;
  String imagePath;

  Product({this.name, this.quantity, this.priority, this.status, this.toBuy, this.imagePath});

  Product.withId({this.id, this.name, this.quantity, this.priority, this.status, this.toBuy, this.imagePath});

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
    map['imagePath'] = imagePath;

    return map;
  }


  factory Product.fromMap( Map<String, dynamic> map ){
    return  Product.withId(
        id: map['id'],
        name: map['name'],
        quantity: map['quantity'],
        priority: map['priority'],
        status: map['status'],
        toBuy: map['toBuy'],
        imagePath: map['imagePath']
    );
  }

}