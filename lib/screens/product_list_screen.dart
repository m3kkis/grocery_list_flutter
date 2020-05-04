import 'package:flutter/material.dart';
import '../helpers/database_helper.dart';
import '../models/product_model.dart';
import '../screens/add_product_screen.dart';
import '../screens/all_product_screen.dart';

class TobuyListScreen extends StatefulWidget {
  @override
  _TobuyListScreenState createState() => _TobuyListScreenState();
}

class _TobuyListScreenState extends State<TobuyListScreen> {

  Future<List<Product>> _productList;

  @override
  void initState(){
    super.initState();
    _updateProductList();
  }

  _updateProductList(){
    setState(() {
      _productList = DatabaseHelper.instance.getProductToBuyList();
    });
  }

  Widget _buildProduct(Product product){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.0),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(
              product.name,
              style: TextStyle(
                  fontSize: 18.0,
                  decoration: product.status == 0 ? TextDecoration.none : TextDecoration.lineThrough,
              ),
            ),
            subtitle: Text(
              'Quantity: ${product.quantity} - ${product.priority}',
              style: TextStyle(
                fontSize: 15.0,
                decoration: product.status == 0 ? TextDecoration.none : TextDecoration.lineThrough,
              ),
            ),
            trailing: Checkbox(
              onChanged: (value){
                product.status = value ? 1 : 0;
                DatabaseHelper.instance.updateProduct(product);
                _updateProductList();
              },
              activeColor: Theme.of(context).primaryColor,
              value: product.status == 1 ? true : false,
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AddProductScreen(
                  updateProductList: _updateProductList,
                  product: product,
                ),
              )
            ),
          ),
          Divider(),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 4.0,
        icon: Icon(
            Icons.add,
            color: Colors.white,
        ),
        label: Text(
            'Add item',
            style: TextStyle(
              color: Colors.white,
            ),
        ),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => AddProductScreen(
                updateProductList: _updateProductList,
              )
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.view_list),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => AllProductScreen()
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {},
            )
          ],
        ),
      ),
      body: FutureBuilder(
        future: _productList,
        builder: (context, snapshot) {
          if(!snapshot.hasData){
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final int completedProductCount = snapshot.data.where( (Product product) => product.status == 1 ).toList().length;

          return ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 50.0),
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
                      Text(
                        'My Products',
                        style: TextStyle(
                          color: Theme
                              .of(context)
                              .primaryColor,
                          fontSize: 40.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        '$completedProductCount of ${snapshot.data.length}',
                        style: TextStyle(
                            color: Colors.black12,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600
                        ),
                      ),
                    ],
                  ),
                );
              }
              return _buildProduct(snapshot.data[index-1]);
            },
          );
        },
      ),
    );
  }
}