class IngredientModel {
  int? id;
  String? name;
  String? category;
  double? quantity;
  String? unit;

  IngredientModel({
    this.id,
    this.name,
    this.category,
    this.quantity,
    this.unit,
  });

  IngredientModel.fromJson(Map<String, dynamic> json) {
    id = json['id_ingredient'] ?? json['id'];
    name = json['name'];
    category = json['category'];
    quantity = json['quantity'] != null ? double.tryParse(json['quantity'].toString()) : null;
    unit = json['unit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (id != null) data['id_ingredient'] = id;
    data['name'] = name;
    data['category'] = category;
    data['quantity'] = quantity;
    data['unit'] = unit;
    return data;
  }
}
