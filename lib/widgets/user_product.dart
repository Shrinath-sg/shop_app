import 'package:flutter/material.dart';
import 'package:shopping_app/screens/edit_or_add.dart';

class UserProduct extends StatefulWidget {
  final String imgUrl;
  final String title;
  final String id;
  Function _delete;
  bool isLoading;

  UserProduct(this.title, this.imgUrl, this.id, this.isLoading, [this._delete]);

  @override
  _UserProductState createState() => _UserProductState();
}

class _UserProductState extends State<UserProduct> with TickerProviderStateMixin{

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(widget.imgUrl),
      ),
      title: Text(widget.title),
      trailing: Container(
        width: 120,
        child: FittedBox(
          child: Row(
            children: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, EditOrAdd.routeName,
                        arguments: widget.id);
                  },
                  child: Icon(Icons.edit)),
              SizedBox(
                width: 10,
              ),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      widget.isLoading=true;
                    });
                    widget._delete(widget.id);
                  },
                  child:widget.isLoading?Container(height: 20,width: 20,child: CircularProgressIndicator(strokeWidth: 2,
                     // backgroundColor: Colors.yellowAccent,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white)
                  ),
                  ): Icon(Icons.delete))
            ],
          ),
        ),
      ),
    );
  }
}
