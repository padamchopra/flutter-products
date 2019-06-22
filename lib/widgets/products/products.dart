import 'package:flutter/material.dart';
import '../../models/product.dart';
import './product_card.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../scoped-models/main.dart';

class Products extends StatelessWidget {
  
  Widget _buildProductList(List<Product> products) {
    Widget productCard = Center(
      child: Text("No products found. Please add some."),
    );
    if (products.length > 0) {
      productCard = ListView.builder(
        itemBuilder: (BuildContext context, int index) => ProductCard(products[index], index),
        itemCount: products.length,
      );
    }
    return productCard;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ScopedModelDescendant<MainModel>(builder: (BuildContext context, Widget child, MainModel model){
      return _buildProductList(model.displayedProducts);
    },);
  }
}
