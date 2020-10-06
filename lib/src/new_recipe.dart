import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewRecipe extends StatefulWidget {
  NewRecipe({Key key, this.toolbar}) : super(key: key);

  final ThemeData toolbar;

  @override
  _NewRecipeState createState() => _NewRecipeState();
}

class _NewRecipeState extends State<NewRecipe> {
  @override
  Widget build(BuildContext context) {
    return Theme(
        data: widget.toolbar.copyWith(primaryColor: Colors.lightGreen),
        child: Scaffold(
          backgroundColor: widget.toolbar.backgroundColor,
          body: Center(
            child: RaisedButton(
              onPressed: () {
                // Navigate back to the first screen by popping the current route
                // off the stack.
                Navigator.of(context).pop(1);
              },
              child: Text('Go back!'),
            ),
          ),
        ));
  }
}
