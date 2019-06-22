import 'package:flutter/material.dart';
import 'package:flutter_course/pages/product_edit.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped-models/main.dart';

class ProductListPage extends StatefulWidget {
  final MainModel model;
  ProductListPage(this.model);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ProductListPageState();
  }
}

class _ProductListPageState extends State<ProductListPage>{
  @override
  initState(){
    super.initState();
    widget.model.fetchProducts();
  }

  Widget _buildEditButton(
      BuildContext context, int index, MainModel model) {
    return IconButton(
      icon: Icon(Icons.edit),
      onPressed: () {
        model.selectProduct(model.allProducts[index].id);
        Navigator.of(context).push(
          MaterialPageRoute(builder: (BuildContext context) {
            return ProductEditPage();
          }),
        ).then((_) => model.selectProduct(null));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
              direction: DismissDirection.endToStart,
              onDismissed: (DismissDirection direction) {
                model.selectProduct(model.allProducts[index].id);
                model.deleteProduct();
              },
              background: Container(
                padding: EdgeInsets.only(left: 15.0, right: 15.0),
                color: Colors.red,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[Icon(Icons.delete)],
                ),
              ),
              key: Key(model.allProducts[index].title),
              child: Column(
                children: <Widget>[
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(model.allProducts[index].image),
                    ),
                    title: Text(model.allProducts[index].title),
                    subtitle:
                        Text('\$' + model.allProducts[index].price.toString()),
                    trailing: _buildEditButton(context, index, model),
                  ),
                  Divider()
                ],
              ),
            );
          },
          itemCount: model.allProducts.length,
        );
      },
    );
  }
}
