class UnitModel {
  int? id;
  String? unit;
  String? createdAt;
  String? updatedAt;

  UnitModel({this.id, this.unit, this.createdAt, this.updatedAt});

  UnitModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    unit = json['unit'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['unit'] = unit;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
