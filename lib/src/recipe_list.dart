import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RecipeLayout extends StatefulWidget {
  RecipeLayout({Key key, this.pos}) : super(key: key);

  final int pos;

  @override
  _RecipeLayoutState createState() => _RecipeLayoutState();
}

class _RecipeLayoutState extends State<RecipeLayout> {
  List items = getDummyList();

  String yourParam;
  Function(String) onSelectParam;


  // int listItems = sharedPrefs.list;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Card(
          elevation: 5,
          child: Dismissible(
            key: Key(items[index]),
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
            onDismissed: (direction) {
              // items--;
              // sharedPrefs.list = items;
              setState(() {
                items.removeAt(index);
              });
            },
            direction: DismissDirection.endToStart,
            child: Container(
              color: getPos(),
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
                      padding: EdgeInsets.fromLTRB(
                          10, 2, 0, 0),
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            items[index],
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                                0, 3, 0, 3),
                            child: Container(
                              width: 30,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.teal),
                                  borderRadius:
                                  BorderRadius.all(
                                      Radius.circular(
                                          10))),
                              child: Text(
                                "3D",
                                textAlign:
                                TextAlign.center,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                                0, 5, 0, 2),
                            child: Container(
                              width: 260,
                              child: Text(
                                "His genius finally recognized by his idol Chester",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Color.fromARGB(
                                        255, 48, 48, 54)),
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
      },
    );
  }

  static List getDummyList() {
    List list = List.generate(10, (i) {
      return "Item ${i + 1}";
    });
    return list;
  }

  MaterialAccentColor getPos() {
    if (widget.pos == 0) return Colors.orangeAccent;
    if (widget.pos == 1) return Colors.blueAccent;
    if (widget.pos == 2) return Colors.deepPurpleAccent;
    if (widget.pos == 3)
      return Colors.purpleAccent;
    else {
      return Colors.lightGreenAccent;
    }
  }
}
