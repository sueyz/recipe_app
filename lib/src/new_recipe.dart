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
  final _formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final ingController = TextEditingController();
  final stepsController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    titleController.dispose();
    ingController.dispose();
    stepsController.dispose();
    super.dispose();
  }

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
        });
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
            body: Stack(
              children: [
                Positioned(
                  child: SingleChildScrollView(
                      child: Form(
                    key: _formKey,
                    child: Column(
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
                                  decoration:
                                      BoxDecoration(color: Colors.grey[200]),
                                  width: MediaQuery.of(context).size.width,
                                  height: 300,
                                  child: Icon(
                                    Icons.add_a_photo,
                                    color: Colors.grey[800],
                                  ),
                                ),
                        ),
                        Container(
                          padding: EdgeInsets.only(
                              bottom: 20, right: 25, left: 15, top: 20),
                          child: Row(
                            children: [
                              Text(
                                "Name:   ",
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orangeAccent,
                                ),
                              ),
                              Expanded(
                                child: TextFormField(
                                  controller: titleController,
                                  decoration: new InputDecoration(
                                      hintText: "What is this?"),
                                  // The validator receives the text that the user has entered.
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please enter some text';
                                    }
                                    return null;
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          padding:
                              EdgeInsets.only(bottom: 20, right: 15, left: 15),
                          child: TextFormField(
                            controller: ingController,
                            decoration: new InputDecoration(
                                hintText: "What is needed?",
                                labelText: "Ingredients:"),
                            // The validator receives the text that the user has entered.
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                          ),
                        ),
                        Container(
                          padding:
                              EdgeInsets.only(bottom: 100, right: 15, left: 15),
                          child: TextFormField(
                            controller: stepsController,
                            decoration: new InputDecoration(
                                hintText: "What is needed to do?",
                                labelText: "Steps:"),
                            // The validator receives the text that the user has entered.
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                          ),
                        ),
                        Container(
                          height:
                              56, // button heigh, so could scroll underlapping area
                        ),
                      ],
                    ),
                  )),
                ),
                Positioned(
                  child: Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: ButtonTheme(
                        minWidth: MediaQuery.of(context).size.width,
                        height: 56,
                        child: RaisedButton(
                          onPressed: () async {
                            int count =
                                await RepositoryServiceRecipe.recipeCount();
                            if (_formKey.currentState.validate()) {
                              // If the form is valid, display a snackbar. In the real world,
                              // you'd often call a server or save the information in a database.

                              if (_image == null) {
                                Navigator.of(context).pop(Recipe(
                                    count,
                                    ModalRoute.of(context).settings.arguments,
                                    titleController.text,
                                    "",
                                    ingController.text,
                                    stepsController.text,
                                    false));
                              } else {
                                Navigator.of(context).pop(Recipe(
                                    count,
                                    ModalRoute.of(context).settings.arguments,
                                    titleController.text,
                                    _image.path,
                                    ingController.text,
                                    stepsController.text,
                                    false));
                              }
                            }
                            // Navigate back to the first screen by popping the current route
                            // off the stack.
                          },
                          child: Text('Create'),
                        ),
                      )),
                )
              ],
            )));
  }
}
