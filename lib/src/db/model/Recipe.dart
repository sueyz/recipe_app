import 'package:recipe_app/src/db/repository/database_creator.dart';

class Recipe {
  int id;
  String name;
  String picture;
  String ingredients;
  String steps;
  bool isDeleted;

  Recipe(this.id, this.name, this.picture, this.ingredients, this.steps, this.isDeleted);

  Recipe.fromJson(Map<String, dynamic> json) {
    this.id = json[DatabaseCreator.id];
    this.name = json[DatabaseCreator.name];
    this.picture = json[DatabaseCreator.picture];
    this.ingredients = json[DatabaseCreator.ingredients];
    this.steps = json[DatabaseCreator.steps];
    this.isDeleted = json[DatabaseCreator.isDeleted] == 1;
  }
}