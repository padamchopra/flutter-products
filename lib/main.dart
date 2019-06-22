import 'package:flutter/material.dart';
import './scoped-models/main.dart';
import 'package:scoped_model/scoped_model.dart';
import './pages/auth.dart';
import './pages/product_admin.dart';
import './pages/products.dart';
import './pages/product.dart';
import './models/product.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  final MainModel model = MainModel();
  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
      model: model,
      child: MaterialApp(
        theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.deepOrange,
            accentColor: Colors.deepPurple,
            fontFamily: 'ProductSans'),
        //home: AuthPage(),
        routes: {
          '/': (BuildContext context) => AuthPage(),
          '/products': (BuildContext context) => ProductsPage(model),
          '/admin': (BuildContext context) => ProductsAdminPage(model),
        },
        onGenerateRoute: (RouteSettings settings) {
          final List<String> pathElements = settings.name.split('/');
          if (pathElements[0] != '') {
            return null;
          } else {
            if (pathElements[1] == 'product') {
              final String productId = pathElements[2];
              final Product product = model.allProducts.firstWhere((Product product){
                return product.id == productId;
              });
              return MaterialPageRoute<bool>(
                builder: (BuildContext context) =>
                    ProductPage(product),
              );
            }
          }
        },
        onUnknownRoute: (RouteSettings settings) {
          return MaterialPageRoute(
              builder: (BuildContext context) => ProductsPage(model));
        },
      ),
    );
  }
}
