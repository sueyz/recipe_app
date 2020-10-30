import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'collapsing_layout.dart';
import 'db/model/Recipe.dart';
import 'db/repository/repository_service_recipe.dart';
import 'package:image_picker/image_picker.dart';

class NewRecipe extends StatefulWidget {
  NewRecipe({Key key, this.toolbar}) : super(key: key);

  final ThemeData toolbar;
  final arraySpinner = [
    'Mediterranean',
    'Asian',
    'American',
    'European',
    'Vegan'
  ];

  @override
  _NewRecipeState createState() => _NewRecipeState();
}

class _NewRecipeState extends State<NewRecipe> {
  var titleController = TextEditingController();
  var ingController = TextEditingController();
  var stepsController = TextEditingController();

  File _image;
  final picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  String newValue = "Mediterranean";
  String initialValue = "Mediterranean";

  int current = 0;

  bool newRecipe = true;
  bool editRecipe = true;
  bool button = false;

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

  String setTitle(args) {
    if (args.type == 1) {
      return "Recipe Details";
    } else {
      return "Add New Recipe";
    }
  }

  bool checkDiff(ScreenArguments args, button) {
    if (args.type == 0) {
      return true;
    }
    if (titleController.text != args.recipe.name ||
        ingController.text != args.recipe.ingredients ||
        stepsController.text != args.recipe.steps ||
        button) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {

    final ScreenArguments args = ModalRoute.of(context).settings.arguments;
    if (newRecipe) {
      current = args.current;
      newValue = widget.arraySpinner[args.current];
      initialValue = widget.arraySpinner[args.current];
      newRecipe = false;
    }
    if (args.type == 1 && editRecipe) {
      titleController = TextEditingController(text: args.recipe.name);
      ingController = TextEditingController(text: args.recipe.ingredients);
      stepsController = TextEditingController(text: args.recipe.steps);
      editRecipe = false;
    }

    if (_image != null) {
      button = true;
    }

    return Theme(
        data: widget.toolbar.copyWith(primaryColor: Colors.lightGreen),
        child: Scaffold(
            appBar: AppBar(
              title: Text(setTitle(args)),
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
                              : args.recipe != null && args.recipe.picture != ''
                                  ? ClipRRect(
                                      child: Image.file(
                                        File(args.recipe.picture),
                                        width:
                                            MediaQuery.of(context).size.width,
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
                        Padding(
                          padding:
                              EdgeInsets.only(top: 40, left: 50, right: 50),
                          child: Container(
                            width: 270,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              border:
                                  Border.all(color: Colors.black, width: 5.0),
                            ),
                            child: Material(
                              child: InkWell(
                                onTap: () {},
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    isDense: true,
                                    onChanged: (String changedValue) {
                                      if (initialValue != changedValue) {
                                        button = true;
                                      } else {
                                        button = false;
                                      }

                                      newValue = changedValue;
                                      if (changedValue ==
                                          widget.arraySpinner[0]) {
                                        current = 0;
                                      } else if (changedValue ==
                                          widget.arraySpinner[1]) {
                                        current = 1;
                                      } else if (changedValue ==
                                          widget.arraySpinner[2]) {
                                        current = 2;
                                      } else if (changedValue ==
                                          widget.arraySpinner[3]) {
                                        current = 3;
                                      } else {
                                        current = 4;
                                      }
                                      setState(() {});
                                    },
                                    value: newValue,
                                    items:
                                        widget.arraySpinner.map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                              color: Colors.transparent,
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
                              56, // button height, so could scroll underlapping area
                        ),
                      ],
                    ),
                  )),
                ),
                checkDiff(args, button)
                    ? Positioned(
                        child: Align(
                            alignment: FractionalOffset.bottomCenter,
                            child: ButtonTheme(
                              minWidth: MediaQuery.of(context).size.width,
                              height: 56,
                              child: RaisedButton(
                                onPressed: () async {
                                  int count = await RepositoryServiceRecipe
                                      .recipeCount();
                                  if (_formKey.currentState.validate()) {

                                    if (args.type == 0) {
                                      if (_image == null) {
                                        Navigator.of(context).pop(Recipe(
                                            count,
                                            current,
                                            titleController.text,
                                            "",
                                            ingController.text,
                                            stepsController.text,
                                            false));
                                      } else {
                                        Navigator.of(context).pop(Recipe(
                                            count,
                                            current,
                                            titleController.text,
                                            _image.path,
                                            ingController.text,
                                            stepsController.text,
                                            false));
                                      }
                                    } else {
                                      //dont put image keep default
                                      if (_image == null &&
                                          args.recipe.picture == "") {
                                        Navigator.of(context).pop(Recipe(
                                            args.recipe.id,
                                            current,
                                            titleController.text,
                                            "",
                                            ingController.text,
                                            stepsController.text,
                                            false));
                                      } else if (_image != null &&
                                          args.recipe.picture == "") {
                                        //default to put image
                                        Navigator.of(context).pop(Recipe(
                                            args.recipe.id,
                                            current,
                                            titleController.text,
                                            _image.path,
                                            ingController.text,
                                            stepsController.text,
                                            false));
                                      } else if (_image != null &&
                                          args.recipe.picture != "") {
                                        //kept image to another new image
                                        Navigator.of(context).pop(Recipe(
                                            args.recipe.id,
                                            current,
                                            titleController.text,
                                            _image.path,
                                            ingController.text,
                                            stepsController.text,
                                            false));
                                      } else {
                                        //kept image to no change
                                        {
                                          Navigator.of(context).pop(Recipe(
                                              args.recipe.id,
                                              current,
                                              titleController.text,
                                              args.recipe.picture,
                                              ingController.text,
                                              stepsController.text,
                                              false));
                                        }
                                      }
                                    }
                                  }
                                  // Navigate back to the first screen by popping the current route
                                  // off the stack.
                                },
                                child: Text('Submit'),
                              ),
                            )),
                      )
                    : Container()
              ],
            )));
  }
}
