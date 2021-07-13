import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/products_provider.dart';
import 'package:shopping_app/widgets/app_drawer.dart';
import 'package:shopping_app/widgets/user_product.dart';

class UserProductScreen extends StatefulWidget {
  static const routeName = '/UserProductScreen';

  @override
  _UserProductScreenState createState() => _UserProductScreenState();
}

class _UserProductScreenState extends State<UserProductScreen> {
  bool _isLoading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Future<void> refreshPage() async {
    await Provider.of<ProductsProvider>(context, listen: false).fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<ProductsProvider>(context);
    void deleteItem(id) {
      data.deleteProduct(id).then((value) {
        setState(() {
          _isLoading = false;
        });
      }).catchError((_) {
     //   print('*******************************************$errMsg');
       _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text('Oops!! could not delete item'),
          backgroundColor: Colors.red,
          duration: Duration(milliseconds: 1500),
        ));
      });
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Manage Your Products'),
        centerTitle: true,
      ),
      drawer: CustomDrawer(),
      body: RefreshIndicator(
        onRefresh: refreshPage,
        child: ListView.builder(
          itemCount: data.items.length,
          itemBuilder: (context, index) => Column(children: [
            UserProduct(
              data.items[index].title,
              data.items[index].imageUrl,
              data.items[index].id,
              _isLoading,
              deleteItem,
            ),
            Divider()
          ]),
        ),
      ),
    );
  }
}
