import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/src/db/repository/database_creator.dart';
import 'package:recipe_app/src/view/new_recipe.dart';
import 'package:recipe_app/src/viewmodel/recipe_list_view_model.dart';
import 'src/view/collapsing_layout.dart';
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
    return ChangeNotifierProvider(
        create: (context) => MovieListViewModel(),
        child: MaterialApp(
          debugShowCheckedModeBanner: true,
          theme: _themeData,
          initialRoute: '/',
          routes: {
            //main screen
            '/': (context) => CollapsingLayout(
                  toolbar: _themeData,
                ),
            '/add': (context) => NewRecipe(
                  toolbar: _themeData,
                ),
          },
        ));
  }
}
