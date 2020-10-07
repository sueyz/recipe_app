import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'db/model/Recipe.dart';
import 'db/repository/repository_service_recipe.dart';
import 'package:image_picker/image_picker.dart';

class NewRecipe extends StatefulWidget {
  NewRecipe({Key key, this.toolbar}) : super(key: key);

  final ThemeData toolbar;

  @override
  _NewRecipeState createState() => _NewRecipeState();
}

class _NewRecipeState extends State<NewRecipe> {

  File _image;
  final picker = ImagePicker();

  Future _imgFromCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future _imgFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        }
    );
  }


  @override
  Widget build(BuildContext context) {
    return Theme(
        data: widget.toolbar.copyWith(primaryColor: Colors.lightGreen),
        child: Scaffold(
          appBar: AppBar(
            title: Text("Add New Recipe"),
            automaticallyImplyLeading: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: Navigator.of(context).pop,
            ),
          ),
          backgroundColor: widget.toolbar.backgroundColor,
          body: Column(
              children: <Widget>[
                GestureDetector(
                    onTap: () {
                      _showPicker(context);
                    },
                    child: _image != null
                          ? ClipRRect(
                        child: Image.file(
                          _image,
                          width: MediaQuery.of(context).size.width,
                          height: 300,
                          fit: BoxFit.cover,
                        ),
                      )
                          : Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[200]),
                        width: MediaQuery.of(context).size.width,
                        height: 300,
                        child: Icon(
                          Icons.add_a_photo,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                RaisedButton(
                  onPressed: () async {
                    // Navigate back to the first screen by popping the current route
                    // off the stack.
                    int count = await RepositoryServiceRecipe.recipeCount();

                    Navigator.of(context).pop( Recipe(count, ModalRoute.of(context).settings.arguments, "rice", "sadad", "asdsadas", "adasd",
                        false));
                  },
                  child: Text('Go back!'),
                ),
              ],
            )
          ),
        );
  }
}
