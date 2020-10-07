import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recipe_app/src/db/model/Recipe.dart';
import 'package:recipe_app/src/db/repository/repository_service_recipe.dart';
import 'package:recipe_app/src/recipe_list.dart';
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
  List wow = [0,0,0,0,0];

  int current = 0;

  List itemsDummy = getDummyList(0);
  List itemsDummy1 = getDummyList(0);
  List itemsDummy2 = getDummyList(0);
  List itemsDummy3 = getDummyList(0);
  List itemsDummy4 = getDummyList(0);

  final _formKey = GlobalKey<FormState>();
  Future<List<Recipe>> future;
  String name;
  String picture;
  String ingredients;
  String steps;
  int id;

  int items = sharedPrefs.list;

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

  void createTodo(Recipe todo, int current) async {
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
    final result = await Navigator.pushNamed(context, '/add');
    int count = await RepositoryServiceRecipe.recipeCount();

    setState(() {
      switch (current) {
        case 0:
          {
            wow[0]++;
            itemsDummy = getDummyList(wow[0]);
            if (wow[0] >= 7) {
              items += result;
              sharedPrefs.list = items;
            }
            createTodo(
                Recipe(count, current, "rice", "sadad", "asdsadas", "adasd",
                    false),
                current);
          }
          break;
        case 1:
          {
            wow[1]++;
            itemsDummy1 = getDummyList(wow[1]);
            if (wow[1] >= 7) {
              items += result;
              sharedPrefs.list = items;
            }
            createTodo(
                Recipe(count, current, "Noodle", "sadad", "asdsadas", "adasd",
                    false),
                current);
          }
          break;
        case 2:
          {
            wow[2]++;
            itemsDummy2 = getDummyList(wow[2]);
            if (wow[2] >= 7) {
              items += result;
              sharedPrefs.list = items;
            }
          }
          break;
        case 3:
          {
            wow[3]++;
            itemsDummy3 = getDummyList(wow[3]);
            if (wow[3] >= 7) {
              items += result;
              sharedPrefs.list = items;
            }
          }
          break;
        case 4:
          {
            wow[4]++;
            itemsDummy4 = getDummyList(wow[4]);
            if (wow[4] >= 7) {
              items += result;
              sharedPrefs.list = items;
            }
          }
          break;
      }
    });
  }

  Card buildItem(Recipe todo, int position) {
    if (todo.typPos == position) {
      return Card(
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
                          items--;
                          wow[position]--;
                          sharedPrefs.list = items;
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
            color: getPos(current),
            height: 100.0,
            child: Row(
              children: <Widget>[
                Container(
                  height: 100.0,
                  width: 70.0,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                              "https://is2-ssl.mzstatic.com/image/thumb/Video2/v4/e1/69/8b/e1698bc0-c23d-2424-40b7-527864c94a8e/pr_source.lsr/268x0w.png"))),
                ),
                Container(
                  height: 100,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(10, 2, 0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          todo.name,
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 3, 0, 3),
                          child: Container(
                            width: 30,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.teal),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Text(
                              "3D",
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 5, 0, 2),
                          child: Container(
                            width: 260,
                            child: Text(
                              "His genius finally recognized by his idol Chester",
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Color.fromARGB(255, 48, 48, 54)),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    } else
      return Card(
        margin: EdgeInsets.zero,
      );
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
                              padding: EdgeInsets.only(top: 10),
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

  static List getDummyList(temp) {
    List list = List.generate(temp, (i) {
      return "Item ${i + 1}";
    });
    return list;
  }

  MaterialAccentColor getPos(pos) {
    if (pos == 0) return Colors.orangeAccent;
    if (pos == 1) return Colors.blueAccent;
    if (pos == 2) return Colors.deepPurpleAccent;
    if (pos == 3)
      return Colors.purpleAccent;
    else {
      return Colors.lightGreenAccent;
    }
  }

  void _incrementCounter() {
    setState(() {
      if (items < 0) {
        items = 0;
        sharedPrefs.list = 0;
      }

      baru = height * items;
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
