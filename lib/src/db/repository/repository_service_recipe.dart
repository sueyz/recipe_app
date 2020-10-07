import 'package:recipe_app/src/db/model/Recipe.dart';
import 'package:recipe_app/src/db/repository/database_creator.dart';


class RepositoryServiceRecipe {
  static Future<List<Recipe>> getAllRecipe() async {
    final sql = '''SELECT * FROM ${DatabaseCreator.recipeTable}
    WHERE ${DatabaseCreator.isDeleted} = 0''';
    final data = await db.rawQuery(sql);
    List<Recipe> recipes = List();

    for (final node in data) {
      final recipe = Recipe.fromJson(node);
      recipes.add(recipe);
    }
    return recipes;
  }

  static Future<Recipe> getRecipe(int id) async {
    //final sql = '''SELECT * FROM ${DatabaseCreator.todoTable}
    //WHERE ${DatabaseCreator.id} = $id''';
    //final data = await db.rawQuery(sql);

    final sql = '''SELECT * FROM ${DatabaseCreator.recipeTable}
    WHERE ${DatabaseCreator.id} = ?''';

    List<dynamic> params = [id];
    final data = await db.rawQuery(sql, params);

    final todo = Recipe.fromJson(data.first);
    return todo;
  }

  static Future<void> addRecipe(Recipe recipe) async {
    /*final sql = '''INSERT INTO ${DatabaseCreator.todoTable}
    (
      ${DatabaseCreator.id},
      ${DatabaseCreator.name},
      ${DatabaseCreator.info},
      ${DatabaseCreator.isDeleted}
    )
    VALUES
    (
      ${todo.id},
      "${todo.name}",
      "${todo.info}",
      ${todo.isDeleted ? 1 : 0}
    )''';*/

    final sql = '''INSERT INTO ${DatabaseCreator.recipeTable}
    (
      ${DatabaseCreator.id},
      ${DatabaseCreator.name},
      ${DatabaseCreator.picture},
      ${DatabaseCreator.ingredients},
      ${DatabaseCreator.steps},
      ${DatabaseCreator.isDeleted}
    )
    VALUES (?,?,?,?,?,?)''';
    List<dynamic> params = [recipe.id, recipe.name, recipe.picture,recipe.ingredients, recipe.steps, recipe.isDeleted ? 1 : 0];
    final result = await db.rawInsert(sql, params);
    DatabaseCreator.databaseLog('Add recipe', sql, null, result, params);
  }

  static Future<void> deleteRecipe(Recipe recipe) async {
    /*final sql = '''UPDATE ${DatabaseCreator.todoTable}
    SET ${DatabaseCreator.isDeleted} = 1
    WHERE ${DatabaseCreator.id} = ${todo.id}
    ''';*/

    final sql = '''UPDATE ${DatabaseCreator.recipeTable}
    SET ${DatabaseCreator.isDeleted} = 1
    WHERE ${DatabaseCreator.id} = ?
    ''';

    List<dynamic> params = [recipe.id];
    final result = await db.rawUpdate(sql, params);

    DatabaseCreator.databaseLog('Delete todo', sql, null, result, params);
  }

  static Future<void> updateRecipe(Recipe recipe) async {
    /*final sql = '''UPDATE ${DatabaseCreator.todoTable}
    SET ${DatabaseCreator.name} = "${todo.name}"
    WHERE ${DatabaseCreator.id} = ${todo.id}
    ''';*/

    final sql = '''UPDATE ${DatabaseCreator.recipeTable}
    SET ${DatabaseCreator.name} = ?,
        ${DatabaseCreator.picture} = ?,
        ${DatabaseCreator.ingredients} = ?,
        ${DatabaseCreator.steps} = ?
    WHERE ${DatabaseCreator.id} = ?
    ''';

    List<dynamic> params = [recipe.name, recipe.picture, recipe.ingredients, recipe.steps, recipe.id];
    final result = await db.rawUpdate(sql, params);

    DatabaseCreator.databaseLog('Update recipe', sql, null, result, params);
  }

  static Future<int> recipeCount() async {
    final data = await db.rawQuery('''SELECT COUNT(*) FROM ${DatabaseCreator.recipeTable}''');

    int count = data[0].values.elementAt(0);
    int idForNewItem = count++;
    return idForNewItem;
  }
}