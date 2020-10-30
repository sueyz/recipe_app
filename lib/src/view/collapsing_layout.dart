import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recipe_app/src/db/model/Recipe.dart';
import 'package:recipe_app/src/viewmodel/recipe_list_view_model.dart';
import 'sliver_fab.dart';
import 'package:recipe_app/src/utils/shared_prefs.dart';
import 'package:provider/provider.dart';


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

class ScreenArguments {
  final int type;
  final Recipe recipe;
  final int current;

  ScreenArguments(this.type, this.recipe, this.current);
}

class _CollapsingLayoutState extends State<CollapsingLayout> {
  String newValue = "Mediterranean";
  PageController controller = PageController();
  ScrollController scrollControllerTop;
  List recipeCardSpace = [
    sharedPrefs.getList(0.toString()),
    sharedPrefs.getList(1.toString()),
    sharedPrefs.getList(2.toString()),
    sharedPrefs.getList(3.toString()),
    sharedPrefs.getList(4.toString())
  ];

  int current = 0;
  int previous = 0;

  File _image;

  int temp = 0;

  double height = 110;

  double newCardSpace = 0;

  @override
  void initState() {
    super.initState();
    // future = RepositoryServiceRecipe.getAllRecipe();
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



  _navigateToNewRecipe(BuildContext context, MovieListViewModel vm) async {
    final result = await Navigator.pushNamed(context, '/add',
        arguments: ScreenArguments(0, null, current));

    Recipe test = result;

    if (result != null) {
      setState(() {
        current = test.typPos;
        this.controller.jumpToPage(test.typPos);
        newValue = widget.arraySpinner[test.typPos];
        switch (current) {
          case 0:
            {
              recipeCardSpace[0]++;
              sharedPrefs.list(0.toString(), recipeCardSpace[0]);
              vm.createRecipe(result);
            }
            break;
          case 1:
            {
              recipeCardSpace[1]++;
              sharedPrefs.list(1.toString(), recipeCardSpace[1]);
              vm.createRecipe(result);
            }
            break;
          case 2:
            {
              recipeCardSpace[2]++;
              sharedPrefs.list(2.toString(), recipeCardSpace[2]);
              vm.createRecipe(result);
            }
            break;
          case 3:
            {
              recipeCardSpace[3]++;
              sharedPrefs.list(3.toString(), recipeCardSpace[3]);
              vm.createRecipe(result);
            }
            break;
          case 4:
            {
              recipeCardSpace[4]++;
              sharedPrefs.list(4.toString(), recipeCardSpace[4]);
              vm.createRecipe(result);
            }
            break;
        }
      });
    }
  }

  _navigateToEditRecipe(BuildContext context, Recipe recipe, MovieListViewModel vm ) async {
    final result = await Navigator.pushNamed(context, '/add',
        arguments: ScreenArguments(1, recipe, current));

    Recipe test = result;

    if (result != null) {
      setState(() {
        previous = current;
        current = test.typPos;
        this.controller.jumpToPage(test.typPos);
        newValue = widget.arraySpinner[test.typPos];
        switch (current) {
          case 0:
            {
              recipeCardSpace[test.typPos]++;
              sharedPrefs.list(
                  test.typPos.toString(), recipeCardSpace[test.typPos]);
              recipeCardSpace[previous]--;
              sharedPrefs.list(previous.toString(), recipeCardSpace[previous]);
              vm.updateRecipe(result);
            }
            break;
          case 1:
            {
              recipeCardSpace[test.typPos]++;
              sharedPrefs.list(
                  test.typPos.toString(), recipeCardSpace[test.typPos]);
              recipeCardSpace[previous]--;
              sharedPrefs.list(previous.toString(), recipeCardSpace[previous]);
              vm.updateRecipe(result);
            }
            break;
          case 2:
            {
              recipeCardSpace[test.typPos]++;
              sharedPrefs.list(
                  test.typPos.toString(), recipeCardSpace[test.typPos]);
              recipeCardSpace[previous]--;
              sharedPrefs.list(previous.toString(), recipeCardSpace[previous]);
              vm.updateRecipe(result);
            }
            break;
          case 3:
            {
              recipeCardSpace[test.typPos]++;
              sharedPrefs.list(
                  test.typPos.toString(), recipeCardSpace[test.typPos]);
              recipeCardSpace[previous]--;
              sharedPrefs.list(previous.toString(), recipeCardSpace[previous]);
              vm.updateRecipe(result);
            }
            break;
          case 4:
            {
              recipeCardSpace[test.typPos]++;
              sharedPrefs.list(
                  test.typPos.toString(), recipeCardSpace[test.typPos]);
              recipeCardSpace[previous]--;
              sharedPrefs.list(previous.toString(), recipeCardSpace[previous]);
              vm.updateRecipe(result);
            }
            break;
        }
      });
    }
  }

  Padding buildRecipeCard(Recipe recipe, int position, MovieListViewModel vm) {

    _image = File(recipe.picture);

    if (recipe.typPos == position) {
      return Padding(
        padding: EdgeInsets.only(top: 5),
        child: Card(
            elevation: 5,
            child: GestureDetector(
              onTap: () {
                _navigateToEditRecipe(context, recipe, vm);
              },
              child: Dismissible(
                key: Key(recipe.id.toString()),
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
                              vm.deleteRecipe(recipe);
                              setState(() {
                                recipeCardSpace[position]--;
                                switch (position) {
                                  case 0:
                                    sharedPrefs.list(0.toString(),
                                        recipeCardSpace[position]);
                                    break;
                                  case 1:
                                    sharedPrefs.list(1.toString(),
                                        recipeCardSpace[position]);
                                    break;
                                  case 2:
                                    sharedPrefs.list(2.toString(),
                                        recipeCardSpace[position]);
                                    break;
                                  case 3:
                                    sharedPrefs.list(3.toString(),
                                        recipeCardSpace[position]);
                                    break;
                                  case 4:
                                    sharedPrefs.list(4.toString(),
                                        recipeCardSpace[position]);
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
                                  recipe.name,
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
            )),
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
    //viewmodel
    final vm = Provider.of<MovieListViewModel>(context);

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
                onTap: () => _navigateToNewRecipe(context, vm),
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
              itemExtent: cardSpace(recipeCardSpace[current]),
              delegate: SliverChildListDelegate([
                PageView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  controller: this.controller,
                  itemCount: 5,
                  itemBuilder: (context, position) {
                    return FutureBuilder<List<Recipe>>(
                      future: vm.future,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Padding(
                              padding:
                                  EdgeInsets.only(top: 5, left: 15, right: 15),
                              child: Column(
                                  children: snapshot.data
                                      .map((recipe) =>
                                          buildRecipeCard(recipe, position, vm))
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

  double cardSpace(int temp) {
    if (temp >= 7) {
      return MediaQuery.of(context).size.height + newCardSpace;
    } else if (temp == 6) {
      return MediaQuery.of(context).size.height;
    } else if (temp == 5) {
      return MediaQuery.of(context).size.height - 115;
    }
    return MediaQuery.of(context).size.height / 1.29;
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
      if (recipeCardSpace[current] < 0) {
        recipeCardSpace[current] = 0;
        switch (current) {
          case 0:
            sharedPrefs.list(0.toString(), 0);
            break;
          case 1:
            sharedPrefs.list(1.toString(), 0);
            break;
          case 2:
            sharedPrefs.list(2.toString(), 0);
            break;
          case 3:
            sharedPrefs.list(3.toString(), 0);
            break;
          case 4:
            sharedPrefs.list(4.toString(), 0);
            break;
        }
      }

      newCardSpace = height * (recipeCardSpace[current] - 6);
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
