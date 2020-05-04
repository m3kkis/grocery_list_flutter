import 'package:flutter/material.dart';
import '../helpers/database_helper.dart';
import '../models/product_model.dart';

class AddProductScreen extends StatefulWidget {
  final Function updateProductList;
  final Product product;
  AddProductScreen({this.updateProductList, this.product});

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {

  final _formKey = GlobalKey<FormState>();

  String _name = '';
  String _quantity = '';
  String _priority;

  final List<String> _priorities = ['Not Important','Important'];

  @override
  void initState(){
    super.initState();

    if(widget.product != null){
      _name = widget.product.name;
      _quantity = widget.product.quantity;
      _priority = widget.product.priority;
    }

  }

  _delete(){
    DatabaseHelper.instance.deleteProduct(widget.product.id);
    widget.updateProductList();
    Navigator.pop(context);
  }

  _remove(){

    Product product = Product(name: _name, quantity: _quantity, priority: _priority);

    product.id = widget.product.id;
    product.status = widget.product.status;
    product.toBuy = 0;
    DatabaseHelper.instance.updateProduct(product);
    widget.updateProductList();
    Navigator.pop(context);

  }

  _submit(){
    if(_formKey.currentState.validate()){
      _formKey.currentState.save();
      print('$_name,$_quantity,$_priority');

      Product product = Product(name: _name, quantity: _quantity, priority: _priority);
      if(widget.product == null){
        //insert the product
        product.status = 0;
        product.toBuy = 1;
        DatabaseHelper.instance.insertProduct(product);
      } else {
        //update the product
        product.id = widget.product.id;
        product.status = widget.product.status;
        DatabaseHelper.instance.updateProduct(product);
      }

      widget.updateProductList();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: 40.0,
                vertical: 80.0
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                      Icons.arrow_back,
                    size: 30.0,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                SizedBox(height: 20.0),
                Text(
                    widget.product == null ? 'Add Product' : 'Update Product',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold,
                    ),
                ),
                SizedBox(height: 10.0),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.0),
                        child: TextFormField(
                          style: TextStyle(fontSize: 18.0),
                          decoration: InputDecoration(
                            labelText: 'Name',
                            labelStyle: TextStyle(fontSize: 18.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          validator: (input) => input.trim().isEmpty ? 'Please enter product name' : null,
                          onSaved: (input)=> _name = input,
                          initialValue: _name,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.0),
                        child: TextFormField(
                          style: TextStyle(fontSize: 18.0),
                          decoration: InputDecoration(
                            labelText: 'Quantity',
                            labelStyle: TextStyle(fontSize: 18.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          validator: (input) => input.trim().isEmpty ? 'Please enter quantity amount' : null,
                          onSaved: (input)=> _quantity = input,
                          initialValue: _quantity,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.0),
                        child: DropdownButtonFormField(
                          isDense: true,
                          icon: Icon(Icons.arrow_drop_down_circle),
                          iconSize: 22.0,
                          iconEnabledColor: Theme.of(context).primaryColor,
                          items: _priorities.map((String priority){
                            return DropdownMenuItem(
                              value: priority,
                              child: Text(
                                priority,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.0
                                ),
                              ),
                            );
                          }).toList(),
                          style: TextStyle(fontSize: 18.0),
                          decoration: InputDecoration(
                            labelText: 'Priority',
                            labelStyle: TextStyle(fontSize: 18.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          validator: (input) => _priority == null ? 'Please select a priority level' : null,
                          onChanged: (value){
                            setState(() {
                              _priority = value;
                            });
                          },
                          value: _priority,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 20.0),
                        height: 60.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(30.0)
                        ),
                        child: FlatButton(
                          child: Text(
                            widget.product == null ? 'Add' : 'Update',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0
                            ),
                          ),
                          onPressed: _submit,
                        ),
                      ),
                      widget.product != null ? Container(
                        margin: EdgeInsets.symmetric(vertical: 20.0),
                        height: 60.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(30.0)
                        ),
                        child: FlatButton(
                          child: Text(
                            'Remove',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0
                            ),
                          ),
                          onPressed: _remove, //_delete
                        ),
                      ) : SizedBox.shrink(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
