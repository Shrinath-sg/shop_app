import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/models/product.dart';
import 'package:shopping_app/providers/products_provider.dart';

class EditOrAdd extends StatefulWidget {
  static const routeName = '/EditOrAdd';

  @override
  _EditOrAddState createState() => _EditOrAddState();
}

class _EditOrAddState extends State<EditOrAdd> {
  bool isLoading = false;
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _urlFocusNode = FocusNode();
  final _urlController = TextEditingController();
  bool isInit = true;
  var saveData = Product(
    id: null,
    price: 0.0,
    title: '',
    description: '',
    imageUrl: '',
    isFavorite: false,
  );
  final _form = GlobalKey<FormState>();
  var initValues = {
    'title': '',
    'price': '',
    'description': '',
    'imageUrl': '',
  };

  @override
  void initState() {
    _urlFocusNode.addListener(updateImage);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (isInit) {
      final prodId = ModalRoute.of(context).settings.arguments as String;
      if (prodId != null) {
        saveData = Provider.of<ProductsProvider>(context, listen: false)
            .findItemByID(prodId);
        initValues = {
          'title': saveData.title,
          'price': saveData.price.toString(),
          'description': saveData.description,
        };
      }
    }
    _urlController.text = saveData.imageUrl;
    isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _urlFocusNode.removeListener(updateImage);
    _urlController.dispose();
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _urlFocusNode.dispose();
    super.dispose();
  }

  void updateImage() {
    if (!_urlFocusNode.hasFocus) {
      //print('triggered.inside...............');
      setState(() {});
    }
  }

  String _validate(String val) {
    if (val.isEmpty) {
      return 'enter something';
    }
  }

  Future<void> saveFormData() async {


    if (_form.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      _form.currentState.save();
      if (saveData.id == null) {
        try {
         await Provider.of<ProductsProvider>(context, listen: false)
              .addProducts(saveData);
        } catch (err) {
        //  print('!!!!!!!!!!!!!!!!!!!!!!!!!!!!$err');
         return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text('something went wrong!!'),
              content: Text('try again sometime!'),
              actions: [
                ElevatedButton(onPressed: (){Navigator.pop(context);}, child: Text('ok')),
              ],
            ),
          );
        }
      } else {
       await Provider.of<ProductsProvider>(context, listen: false)
            .updateProduct(saveData.id, saveData);
      }
      Navigator.pop(context);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit'),
        actions: [
          IconButton(icon: Icon(Icons.save), onPressed: saveFormData),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Form(
                    key: _form,
                    child: Column(
                      children: [
                        TextFormField(
                          initialValue: initValues['title'],
                          onSaved: (val) {
                            saveData = Product(
                                isFavorite: saveData.isFavorite,
                                price: saveData.price,
                                id: saveData.id,
                                imageUrl: saveData.imageUrl,
                                description: saveData.description,
                                title: val);
                          },
                          validator: _validate,
                          decoration: InputDecoration(
                            labelText: "title",
                          ),
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            Focus.of(context).requestFocus(_priceFocusNode);
                          },
                        ),
                        TextFormField(
                          initialValue: initValues['price'],
                          onSaved: (val) {
                            saveData = Product(
                                isFavorite: saveData.isFavorite,
                                price: double.parse(val),
                                id: saveData.id,
                                imageUrl: saveData.imageUrl,
                                description: saveData.description,
                                title: saveData.title);
                          },
                          validator: _validate,
                          decoration: InputDecoration(
                            labelText: "price",
                          ),
                          textInputAction: TextInputAction.next,
                          focusNode: _priceFocusNode,
                          keyboardType: TextInputType.number,
                          onFieldSubmitted: (_) {
                            Focus.of(context)
                                .requestFocus(_descriptionFocusNode);
                          },
                        ),
                        TextFormField(
                          initialValue: initValues['description'],
                          onSaved: (val) {
                            saveData = Product(
                                isFavorite: saveData.isFavorite,
                                price: saveData.price,
                                id: saveData.id,
                                imageUrl: saveData.imageUrl,
                                description: val,
                                title: saveData.title);
                          },
                          validator: _validate,
                          decoration: InputDecoration(
                            labelText: "description",
                          ),
                          maxLines: 3,
                          keyboardType: TextInputType.multiline,
                          focusNode: _descriptionFocusNode,
                        ),
                        TextFormField(
                          onSaved: (val) {
                            saveData = Product(
                                isFavorite: saveData.isFavorite,
                                price: saveData.price,
                                id: saveData.id,
                                imageUrl: val,
                                description: saveData.description,
                                title: saveData.title);
                          },
                          validator: _validate,
                          decoration: InputDecoration(labelText: 'Enter URL'),
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.url,
                          controller: _urlController,
                          focusNode: _urlFocusNode,
                        ),
                        Container(
                          margin: EdgeInsets.all(14),
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey)),
                          alignment: Alignment.center,
                          child: _urlController.text.isNotEmpty
                              ? Image.network(
                                  _urlController.text,
                                  fit: BoxFit.cover,
                                )
                              : Text('No URL'),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
    );
  }
}
