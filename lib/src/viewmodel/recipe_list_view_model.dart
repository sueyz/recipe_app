import 'package:flutter/material.dart';
import 'package:recipe_app/src/db/model/Recipe.dart';
import 'package:recipe_app/src/db/repository/repository_service_recipe.dart';

class MovieListViewModel extends ChangeNotifier {

  Future<List<Recipe>> future = RepositoryServiceRecipe.getAllRecipe();

  updateRecipe(Recipe recipe) async {
    await RepositoryServiceRecipe.updateRecipe(recipe);
    future = RepositoryServiceRecipe.getAllRecipe();
    notifyListeners();
  }

  deleteRecipe(Recipe recipe) async {
    await RepositoryServiceRecipe.deleteRecipe(recipe);
    future = RepositoryServiceRecipe.getAllRecipe();
    notifyListeners();
  }

  void createRecipe(Recipe recipe) async {
    var what = recipe;
    await RepositoryServiceRecipe.addRecipe(what);
    future = RepositoryServiceRecipe.getAllRecipe();
    notifyListeners();
  }
}
