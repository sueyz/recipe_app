import 'package:flutter/material.dart';
import 'package:recipe_app/src/db/repository/database_creator.dart';
import 'package:recipe_app/src/new_recipe.dart';
import 'src/collapsing_layout.dart';
import 'package:recipe_app/src/utils/shared_prefs.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await sharedPrefs.init();
  await DatabaseCreator().initDatabase();
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  final ThemeData _themeData = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.lightGreen,
    accentColor: Colors.orangeAccent,
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      theme: _themeData,
      initialRoute: '/',
      routes: {
        // When we navigate to the "/" route, build the FirstScreen Widget
        // '/': (context) => CollapsingTab(),
        // When we navigate to the "/profile" route, build the SecondScreen Widget
        '/': (context) => CollapsingLayout(
              toolbar: _themeData,
            ),
        '/add': (context) => NewRecipe(
              toolbar: _themeData,
            ),
      },
    );
  }
}