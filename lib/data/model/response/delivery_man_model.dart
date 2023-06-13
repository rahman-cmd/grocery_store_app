class DeliveryManModel {
  int? id;
  String? fName;
  String? lName;
  String? phone;
  String? email;
  String? identityNumber;
  String? identityType;
  List<String>? identityImage;
  String? image;
  bool? status;
  int? active;
  int? earning;
  String? type;
  int? ordersCount;
  double? avgRating;
  int? ratingCount;
  double? cashInHands;

  DeliveryManModel(
      {this.id,
        this.fName,
        this.lName,
        this.phone,
        this.email,
        this.identityNumber,
        this.identityType,
        this.identityImage,
        this.image,
        this.status,
        this.active,
        this.earning,
        this.type,
        this.ordersCount,
        this.avgRating,
        this.ratingCount,
        this.cashInHands});

  DeliveryManModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fName = json['f_name'];
    lName = json['l_name'];
    phone = json['phone'];
    email = json['email'];
    identityNumber = json['identity_number'];
    identityType = json['identity_type'];
    identityImage = json['identity_image'].cast<String>();
    image = json['image'];
    status = json['status'];
    active = json['active'];
    earning = json['earning'];
    type = json['type'];
    ordersCount = json['orders_count'];
    avgRating = json['avg_rating'].toDouble();
    ratingCount = json['rating_count'];
    cashInHands = json['cash_in_hands'].toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['f_name'] = fName;
    data['l_name'] = lName;
    data['phone'] = phone;
    data['email'] = email;
    data['identity_number'] = identityNumber;
    data['identity_type'] = identityType;
    data['identity_image'] = identityImage;
    data['image'] = image;
    data['status'] = status;
    data['active'] = active;
    data['earning'] = earning;
    data['type'] = type;
    data['orders_count'] = ordersCount;
    data['avg_rating'] = avgRating;
    data['rating_count'] = ratingCount;
    data['cash_in_hands'] = cashInHands;
    return data;
  }
}