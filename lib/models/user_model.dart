import 'package:am_i_cooked/models/picture_model.dart';

class UserModel {
  int? id;
  String? username;
  String? password;
  String? email;
  int? xP;
  int? lVL;
  DateTime? createdAt;
  DateTime? updatedAt;
  PictureModel? profilePicture;

  UserModel({
    this.id,
    this.username,
    this.password,
    this.email,
    this.xP,
    this.lVL,
    this.createdAt,
    this.updatedAt,
    this.profilePicture,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    password = json['password'];
    email = json['email'];
    xP = json['XP'];
    lVL = json['LVL'];
    createdAt = _parseDate(json['created_at']);
    updatedAt = _parseDate(json['updated_at']);
    if (json['profile_picture'] != null) {
      profilePicture = PictureModel.fromJson(json['profile_picture']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['password'] = password;
    data['email'] = email;
    data['XP'] = xP;
    data['LVL'] = lVL;
    data['created_at'] = createdAt?.toIso8601String();
    data['updated_at'] = updatedAt?.toIso8601String();
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
