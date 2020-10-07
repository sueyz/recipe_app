import 'package:recipe_app/src/db/repository/database_creator.dart';

class Recipe {
  int id;
  int typPos;
  String name;
  String picture;
  String ingredients;
  String steps;
  bool isDeleted;

  Recipe(this.id, this.typPos ,this.name, this.picture, this.ingredients, this.steps, this.isDeleted);

  Recipe.fromJson(Map<String, dynamic> json) {
    this.id = json[DatabaseCreator.id];
    this.typPos = json[DatabaseCreator.typePos];
    this.name = json[DatabaseCreator.name];
    this.picture = json[DatabaseCreator.picture];
    this.ingredients = json[DatabaseCreator.ingredients];
    this.steps = json[DatabaseCreator.steps];
    this.isDeleted = json[DatabaseCreator.isDeleted] == 1;
  }
}