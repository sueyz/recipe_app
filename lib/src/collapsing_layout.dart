import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recipe_app/src/db/model/Recipe.dart';
import 'package:recipe_app/src/db/repository/repository_service_recipe.dart';
import 'sliver_fab.dart';
import 'package:recipe_app/src/utils/shared_prefs.dart';

class CollapsingLayout extends StatefulWidget {
  CollapsingLayout({Key key, this.toolbar}) : super(key: key);

  final ThemeData toolbar;
  final arraySpinner = [
    'Mediterranean',
    'Asian',
    'American',
    'European',
    'Vegan'
  ];

  @override
  _CollapsingLayoutState createState() => _CollapsingLayoutState();
}

class _CollapsingLayoutState extends State<CollapsingLayout> {
  String newValue = "Mediterranean";
  PageController controller = PageController();
  ScrollController scrollControllerTop;
  List wow = [
    sharedPrefs.getList("Mediterranean"),
    sharedPrefs.getList("Asian"),
    sharedPrefs.getList("American"),
    sharedPrefs.getList("European"),
    sharedPrefs.getList("Vegan")
  ];

  int current = 0;

  Future<List<Recipe>> future;
  String name;
  String picture;
  String ingredients;
  String steps;
  int id;
  File _image;

  // int items = sharedPrefs.getList("Mediterranean");
  int temp = 0;

  double height = 110;

  double baru = 0;

  @override
  void initState() {
    super.initState();
    future = RepositoryServiceRecipe.getAllRecipe();
    controller = PageController(initialPage: 0);
    scrollControllerTop = ScrollController();
    scrollControllerTop.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    scrollControllerTop.dispose();
    controller.dispose();
    super.dispose();
  }

  void readData(int current) async {
    final todo = await RepositoryServiceRecipe.getRecipe(current);
    print(todo.name);
  }

  addTodo(Recipe recipe) async {
    await RepositoryServiceRecipe.addRecipe(recipe);
    setState(() {
      future = RepositoryServiceRecipe.getAllRecipe();
      print(future);
    });
  }

  updateTodo(Recipe recipe) async {
    recipe.name = 'Nasi';
    await RepositoryServiceRecipe.updateRecipe(recipe);
    setState(() {
      future = RepositoryServiceRecipe.getAllRecipe();
    });
  }

  deleteTodo(Recipe recipe) async {
    await RepositoryServiceRecipe.deleteRecipe(recipe);
    setState(() {
      id = null;
      future = RepositoryServiceRecipe.getAllRecipe();
    });
  }

  void createTodo(Recipe todo) async {
    // if (_formKey.currentState.validate()) {
    //   _formKey.currentState.save();
    var what = todo;
    await RepositoryServiceRecipe.addRecipe(what);
    setState(() {
      id = what.id;
      future = RepositoryServiceRecipe.getAllRecipe();
    });
    print(what.id);
    // }
  }

  _navigateToNewRecipe(BuildContext context) async {
    final result =
        await Navigator.pushNamed(context, '/add', arguments: current);
    // 'Mediterranean',
    // 'Asian',
    // 'American',
    // 'European',
    // 'Vegan'

    if (result != null) {
      setState(() {
        switch (current) {
          case 0:
            {
              wow[0]++;
              sharedPrefs.list("Mediterranean", wow[0]);
              log("aaaaaaaaa${wow[0]}");
              createTodo(result);
            }
            break;
          // case 1:
          //   {
          //     wow[1] += result;
          //     sharedPrefs.list("Asian", wow[1]);
          //     createTodo(
          //         Recipe(count, current, "Noodle", "sadad", "asdsadas", "adasd",
          //             false),
          //         current);
          //   }
          //   break;
          // case 2:
          //   {
          //     wow[2]++;
          //     if (wow[2] >= 7) {
          //       items += result;
          //       sharedPrefs.list = items;
          //     }
          //   }
          //   break;
          // case 3:
          //   {
          //     wow[3]++;
          //     if (wow[3] >= 7) {
          //       items += result;
          //       sharedPrefs.list = items;
          //     }
          //   }
          //   break;
          // case 4:
          //   {
          //     wow[4]++;
          //     if (wow[4] >= 7) {
          //       items += result;
          //       sharedPrefs.list = items;
          //     }
          //   }
          //   break;
        }
      });
    }
  }

  Padding buildItem(Recipe todo, int position) {
    _image = File(todo.picture);

    if (todo.typPos == position) {
      return Padding(
        padding: EdgeInsets.only(top: 5),
        child: Card(
          elevation: 5,
          child: Dismissible(
            key: Key(todo.id.toString()),
            background: Container(
              alignment: Alignment.centerRight,
              color: Colors.red,
              child: Padding(
                padding: EdgeInsets.only(right: 20),
                child: Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
            ),
            confirmDismiss: (DismissDirection direction) async {
              return await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: new Text("Are you sure?"),
                    actions: <Widget>[
                      // usually buttons at the bottom of the dialog
                      FlatButton(
                        child: new Text("Cancel"),
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                      ),
                      FlatButton(
                        child: new Text("Delete"),
                        onPressed: () {
                          deleteTodo(todo);
                          setState(() {
                            wow[position]--;
                            switch (position) {
                              case 0:
                                sharedPrefs.list(
                                    "Mediterranean", wow[position]);
                                break;
                              case 1:
                                sharedPrefs.list("Asian", wow[position]);
                                break;
                              case 2:
                                sharedPrefs.list("American", wow[position]);
                                break;
                              case 3:
                                sharedPrefs.list("European", wow[position]);
                                break;
                              case 4:
                                sharedPrefs.list("Vegan", wow[position]);
                                break;
                            }
                          });
                          Navigator.of(context).pop(true);
                        },
                      ),
                    ],
                  );
                },
              );
            },
            direction: DismissDirection.endToStart,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.orangeAccent,
                border: Border.all(color: getPos(current), width: 5.0),
              ),
              height: 100.0,
              child: Stack(
                children: <Widget>[
                  Container(
                      height: 100.0,
                      width: MediaQuery.of(context).size.width,
                      child: _image.path == ''
                          ? ClipRRect(
                              child: Image.asset(
                                "assets/images/vegies.jpg",
                                fit: BoxFit.cover,
                              ),
                            )
                          : ClipRRect(
                              child: Image.file(
                                _image,
                                width: MediaQuery.of(context).size.width,
                                height: 300,
                                fit: BoxFit.cover,
                              ),
                            )),
                  Positioned(
                      child: Align(
                          alignment: FractionalOffset.bottomRight,
                          child: Padding(
                            padding: EdgeInsets.only(right: 10, bottom: 5),
                            child: Text(
                              todo.name,
                              style: TextStyle(
                                  fontSize: 27.0,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic),
                            ),
                          )))
                ],
              ),
            ),
          ),
        ),
      );
    } else
      return Padding(
          padding: EdgeInsets.zero,
          child: Card(
            margin: EdgeInsets.zero,
          ));
  }

  @override
  Widget build(BuildContext context) {
    _incrementCounter();

    return Theme(
      data: widget.toolbar.copyWith(primaryColor: Colors.lightGreen),
      child: Scaffold(
        backgroundColor: widget.toolbar.backgroundColor,
        body: SliverContainer(
          floatingActionButton: Material(
            elevation: 4.0,
            shape: CircleBorder(),
            clipBehavior: Clip.hardEdge,
            color: Colors.orangeAccent,
            child: Ink(
              height: 55.0,
              width: 55.0,
              child: InkWell(
                onTap: () => _navigateToNewRecipe(context),
                child: Icon(
                  Icons.add,
                  color: Colors.black,
                  size: 30,
                ),
              ),
            ),
          ),
          slivers: <Widget>[
            SliverAppBar(
              floating: false,
              iconTheme: IconThemeData(color: Colors.white),
              expandedHeight: 200.0,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: EdgeInsets.only(left: 20, bottom: 15),
                title: Container(
                    alignment: Alignment.center,
                    height: 30,
                    width: 130,
                    decoration: BoxDecoration(
                      color: Colors.orangeAccent,
                      border: Border.all(color: Colors.black, width: 3.0),
                    ),
                    child: Text(
                      "RecipeApp",
                      style: TextStyle(
                          color: Colors.black,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    )),
                background: Image.asset(
                  "assets/images/vegies.jpg",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SliverPersistentHeader(
                pinned: true,
                delegate: StickyTabBarDelegate(
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: widget.toolbar.backgroundColor,
                          blurRadius: 2.0,
                          spreadRadius: 10.0,
                        )
                      ],
                    ),
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.only(top: 50, left: 50, right: 50),
                      child: Container(
                        width: 270,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          border: Border.all(color: Colors.black, width: 5.0),
                        ),
                        child: Material(
                          child: InkWell(
                            onTap: () {},
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                isDense: true,
                                onChanged: (String changedValue) {
                                  newValue = changedValue;
                                  if (changedValue == widget.arraySpinner[0]) {
                                    current = 0;
                                    this.controller.jumpToPage(0);
                                  } else if (changedValue ==
                                      widget.arraySpinner[1]) {
                                    current = 1;
                                    this.controller.jumpToPage(1);
                                  } else if (changedValue ==
                                      widget.arraySpinner[2]) {
                                    current = 2;
                                    this.controller.jumpToPage(2);
                                  } else if (changedValue ==
                                      widget.arraySpinner[3]) {
                                    current = 3;
                                    this.controller.jumpToPage(3);
                                  } else {
                                    current = 4;
                                    this.controller.jumpToPage(4);
                                  }
                                  setState(() {});
                                },
                                value: newValue,
                                items: widget.arraySpinner.map((String value) {
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
                  ),
                )),
            SliverFixedExtentList(
              itemExtent: itemArea(wow[current]),
              delegate: SliverChildListDelegate([
                PageView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  controller: this.controller,
                  itemCount: 5,
                  itemBuilder: (context, position) {
                    // future = RepositoryServiceRecipe.getspe(position);
                    // readData(position);
                    return FutureBuilder<List<Recipe>>(
                      future: future,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Padding(
                              padding:
                                  EdgeInsets.only(top: 5, left: 15, right: 15),
                              child: Column(
                                  children: snapshot.data
                                      .map((todo) => buildItem(todo, position))
                                      .toList()));
                        } else {
                          return SizedBox();
                        }
                      },
                    );
                  },
                ),
              ]),
            ),
          ],
          scrollController: this.scrollControllerTop,
        ),
      ),
    );
  }

  double itemArea(int temp) {
    if (temp >= 7) {
      return MediaQuery.of(context).size.height + baru;
    } else if (temp == 6) {
      return MediaQuery.of(context).size.height;
    } else if (temp == 5) {
      return MediaQuery.of(context).size.height - 115;
    }
    return MediaQuery.of(context).size.height - 160;
  }

  MaterialAccentColor getPos(pos) {
    if (pos == 0) return Colors.orangeAccent;
    if (pos == 1) return Colors.redAccent;
    if (pos == 2) return Colors.blueAccent;
    if (pos == 3)
      return Colors.purpleAccent;
    else {
      return Colors.greenAccent;
    }
  }

  void _incrementCounter() {
    setState(() {
      if (wow[current] < 0) {
        wow[current] = 0;
        switch (current) {
          case 0:
            sharedPrefs.list("Mediterranean", 0);
            break;
          case 1:
            sharedPrefs.list("Asian", 0);
            break;
          case 2:
            sharedPrefs.list("American", 0);
            break;
          case 3:
            sharedPrefs.list("European", 0);
            break;
          case 4:
            sharedPrefs.list("Vegan", 0);
            break;
        }
      }

      baru = height * (wow[current] - 6);
    });
  }
}

class StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final Container child;

  StickyTabBarDelegate({@required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return this.child;
  }

  @override
  double get maxExtent => 80;

  @override
  double get minExtent => 80;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
