import 'package:am_i_cooked/models/picture_model.dart';
import 'package:am_i_cooked/models/ingredient_model.dart';

class RecipeModel {
  int? id;
  String? name;
  String? description;
  int? cookingTime;
  int? preparationTime;
  String? difficulty;
  int? xpWinnable;
  int? idPicture;
  int? idUser;
  DateTime? createdAt;
  DateTime? updatedAt;
  PictureModel? recipePicture;
  List<IngredientModel>? ingredients;

  String get displayName => name ?? 'Nom Indisponible';

  RecipeModel({
    this.id,
    this.name,
    this.description,
    this.cookingTime,
    this.preparationTime,
    this.difficulty,
    this.xpWinnable,
    this.idPicture,
    this.idUser,
    this.createdAt,
    this.updatedAt,
    this.recipePicture,
    this.ingredients,
  });

  RecipeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    cookingTime = json['cooking_time'];
    preparationTime = json['preparation_time'];
    difficulty = json['difficulty'];
    xpWinnable = json['XP_winnable'];
    idPicture = json['id_picture'];
    idUser = json['id_user'];
    createdAt = _parseDate(json['created_at']);
    updatedAt = _parseDate(json['updated_at']);
    if (json['recipe_picture'] != null) {
      recipePicture = PictureModel.fromJson(json['recipe_picture']);
    }
    if (json['ingredients'] != null) {
      ingredients = (json['ingredients'] as List)
          .map((i) => IngredientModel.fromJson(i))
          .toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['cooking_time'] = cookingTime;
    data['preparation_time'] = preparationTime;
    data['difficulty'] = difficulty;
    data['XP_winnable'] = xpWinnable;
    data['id_picture'] = idPicture;
    data['id_user'] = idUser;
    data['created_at'] = createdAt?.toIso8601String();
    data['updated_at'] = updatedAt?.toIso8601String();
    if (recipePicture != null) {
      data['recipe_picture'] = recipePicture!.toJson();
    }
    if (ingredients != null) {
      data['ingredients'] = ingredients!.map((i) => i.toJson()).toList();
    }
    return data;
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is DateTime) {
      return value;
    }

    if (value is String && value.isNotEmpty) {
      return DateTime.tryParse(value);
    }

    return null;
  }
}
