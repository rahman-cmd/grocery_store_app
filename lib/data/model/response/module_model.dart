class ModuleModel {
  int? id;
  String? moduleName;
  String? moduleType;
  String? thumbnail;
  String? icon;
  int? themeId;
  String? description;
  int? storesCount;
  String? createdAt;
  String? updatedAt;

  ModuleModel(
      {this.id,
        this.moduleName,
        this.moduleType,
        this.thumbnail,
        this.storesCount,
        this.icon,
        this.themeId,
        this.description,
        this.createdAt,
        this.updatedAt,
      });

  ModuleModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    moduleName = json['module_name'];
    moduleType = json['module_type'];
    thumbnail = json['thumbnail'];
    icon = json['icon'];
    themeId = json['theme_id'];
    description = json['description'];
    storesCount = json['stores_count'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['module_name'] = moduleName;
    data['module_type'] = moduleType;
    data['thumbnail'] = thumbnail;
    data['icon'] = icon;
    data['theme_id'] = themeId;
    data['description'] = description;
    data['stores_count'] = storesCount;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}