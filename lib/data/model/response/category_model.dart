class CategoryModel {
  int? _id;
  String? _name;
  String? _image;

  CategoryModel(
      {int? id,
        String? name,
        int? parentId,
        int? position,
        int? status,
        String? createdAt,
        String? updatedAt,
        String? image}) {
    _id = id;
    _name = name;
    _image = image;
  }

  int? get id => _id;
  String? get name => _name;
  String? get image => _image;

  CategoryModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['name'] = _name;
    data['image'] = _image;
    return data;
  }
}
