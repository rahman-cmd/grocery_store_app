class CampaignModel {
  int? id;
  String? title;
  String? image;
  String? description;
  String? createdAt;
  String? updatedAt;
  String? startTime;
  String? endTime;
  String? availableDateStarts;
  String? availableDateEnds;
  String? vendorStatus;
  bool? isJoined;

  CampaignModel(
      {this.id,
        this.title,
        this.image,
        this.description,
        this.createdAt,
        this.updatedAt,
        this.startTime,
        this.endTime,
        this.availableDateStarts,
        this.availableDateEnds,
        this.vendorStatus,
        this.isJoined});

  CampaignModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    image = json['image'];
    description = json['description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    availableDateStarts = json['available_date_starts'];
    availableDateEnds = json['available_date_ends'];
    vendorStatus = json['vendor_status'];
    isJoined = json['is_joined'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['image'] = image;
    data['description'] = description;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    data['available_date_starts'] = availableDateStarts;
    data['available_date_ends'] = availableDateEnds;
    data['vendor_status'] = vendorStatus;
    data['is_joined'] = isJoined;
    return data;
  }
}
