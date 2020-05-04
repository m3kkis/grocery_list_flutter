import 'package:flutter/material.dart';
import '../helpers/database_helper.dart';
import '../models/product_model.dart';

import 'package:grocery_list/screens/add_product_screen.dart';

class AllProductScreen extends StatefulWidget {
  @override
  _AllProductScreenState createState() => _AllProductScreenState();
}

class _AllProductScreenState extends State<AllProductScreen> {

  Future<List<Product>> _productList;

  @override
  void initState(){
    super.initState();
    _updateProductList();
  }

  _updateProductList(){
    setState(() {
      _productList = DatabaseHelper.instance.getProductList();
    });
  }

  _delete(Product product){
    DatabaseHelper.instance.deleteProduct(product.id);
    _updateProductList();
  }

  Widget _buildTileProduct(Product product){
    return new GestureDetector(
      child: Card(
        elevation: 5.0,
        child: Container(
          alignment: Alignment.center,
          child: Text('${product.name}'),
        ),
      ),
      onLongPress: () => {
        _delete(product)
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _productList,
        builder: (context, snapshot) {
          if(!snapshot.hasData){
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return GridView.builder(
            padding: EdgeInsets.symmetric(vertical: 50.0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemCount: 1 + snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {

              if (index == 0) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 40.0,
                      vertical: 0.0
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
                        'All Items',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 40.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10.0),
                    ],
                  ),
                );
              }
              return _buildTileProduct(snapshot.data[index-1]);
            },
          );
        },
      ),
    );
  }
}
