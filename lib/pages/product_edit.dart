import 'package:flutter/material.dart';
import '../models/product.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped-models/main.dart';

class ProductEditPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ProductEditPageState();
  }
}

class _ProductEditPageState extends State<ProductEditPage> {
  final Map<String, dynamic> _formData = {
    'title': null,
    'description': null,
    'price': null,
    'image': 'assets/food.jpg'
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildTitleTextField(Product product) {
    return TextFormField(
      decoration: InputDecoration(labelText: "Title"),
      autocorrect: false,
      initialValue: product == null ? "" : product.title,
      validator: (String value) {
        if (value.isEmpty) {
          return "Title is required";
        }
      },
      onSaved: (String value) => _formData['title'] = value,
    );
  }

  Widget _buildDescriptionTextField(Product product) {
    return TextFormField(
      decoration: InputDecoration(labelText: "Description"),
      maxLines: 4,
      autocorrect: false,
      initialValue: product == null ? "" : product.description,
      validator: (String value) {
        if (value.isEmpty) {
          return "Description is required";
        }
      },
      onSaved: (String value) => _formData['description'] = value,
    );
  }

  Widget _buildPriceTextField(Product product) {
    return TextFormField(
      decoration: InputDecoration(labelText: "Price"),
      keyboardType: TextInputType.number,
      autocorrect: false,
      initialValue: product == null ? "" : product.price.toString(),
      validator: (String value) {
        String valueWithDots = value.replaceFirst(RegExp(r','), '.');
        if (value.isEmpty ||
            !RegExp(r'^(?:[1-9]\d*|0)?(?:\.\d+)?$').hasMatch(valueWithDots)) {
          return "A valid price is required";
        }
      },
      onSaved: (String value) {
        _formData['price'] =
            double.parse(value.replaceFirst(RegExp(r','), '.'));
      },
    );
  }

  Widget _buildSubmitButton() {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return model.isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : RaisedButton(
                color: Theme.of(context).accentColor,
                textColor: Colors.white,
                child: Text("Save"),
                onPressed: () => _submitForm(
                    model.addProduct,
                    model.updateProduct,
                    model.selectProduct,
                    model.selectedProductIndex),
              );
      },
    );
  }

  Widget _buildPageContent(BuildContext context, Product product) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    final double targetPadding = deviceWidth - targetWidth;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
        margin: EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: targetPadding / 2),
            children: <Widget>[
              _buildTitleTextField(product),
              _buildDescriptionTextField(product),
              _buildPriceTextField(product),
              SizedBox(
                height: 10.0,
              ),
              _buildSubmitButton()
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm(
      Function addProduct, Function updateProduct, Function setSelectedProduct,
      [int selectedProductIndex]) {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      if (selectedProductIndex == -1) {
        addProduct(_formData['title'], _formData['description'],
                _formData['image'], _formData['price'])
            .then((bool success) {
          if (success) {
            Navigator.pushReplacementNamed(context, '/products')
                .then((_) => setSelectedProduct(null));
          } else {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Something went wrong"),
                    content: Text("Please try again"),
                    actions: <Widget>[
                      FlatButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text("Okay"),
                      )
                    ],
                  );
                });
          }
        });
      } else {
        updateProduct(_formData['title'], _formData['description'],
                _formData['image'], _formData['price'])
            .then((_) => Navigator.pushReplacementNamed(context, '/products')
                .then((_) => setSelectedProduct(null)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        final Widget pageContent =
            _buildPageContent(context, model.selectedProduct);
        return model.selectedProductIndex == -1
            ? pageContent
            : Scaffold(
                appBar: AppBar(title: Text("Edit Product")),
                body: pageContent,
              );
      },
    );
  }
}
