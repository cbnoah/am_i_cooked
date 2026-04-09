class UserModel {
  int? id;
  String? username;
  String? password;
  String? email;
  int? xP;
  int? lVL;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? token;

  UserModel({
    this.id,
    this.username,
    this.password,
    this.email,
    this.xP,
    this.lVL,
    this.createdAt,
    this.updatedAt,
    this.token,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    password = json['password'];
    email = json['email'];
    xP = json['XP'];
    lVL = json['LVL'];
    createdAt = DateTime.parse(json['created_at']);
    updatedAt = DateTime.parse(json['updated_at']);
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['password'] = password;
    data['email'] = email;
    data['XP'] = xP;
    data['LVL'] = lVL;
    data['created_at'] = createdAt.toString();
    data['updated_at'] = updatedAt;
    data['token'] = token;
    return data;
  }
}
