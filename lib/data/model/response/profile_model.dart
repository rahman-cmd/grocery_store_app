class ProfileModel {
  int? id;
  String? fName;
  String? lName;
  String? phone;
  String? email;
  String? createdAt;
  String? updatedAt;
  String? bankName;
  String? branch;
  String? holderName;
  String? accountNo;
  String? image;
  int? orderCount;
  int? todaysOrderCount;
  int? thisWeekOrderCount;
  int? thisMonthOrderCount;
  int? memberSinceDays;
  double? cashInHands;
  double? balance;
  double? totalEarning;
  double? todaysEarning;
  double? thisWeekEarning;
  double? thisMonthEarning;
  List<Store>? stores;
  List<String>? roles;
  EmployeeInfo? employeeInfo;

  ProfileModel(
      {this.id,
        this.fName,
        this.lName,
        this.phone,
        this.email,
        this.createdAt,
        this.updatedAt,
        this.bankName,
        this.branch,
        this.holderName,
        this.accountNo,
        this.image,
        this.orderCount,
        this.todaysOrderCount,
        this.thisWeekOrderCount,
        this.thisMonthOrderCount,
        this.memberSinceDays,
        this.cashInHands,
        this.balance,
        this.totalEarning,
        this.todaysEarning,
        this.thisWeekEarning,
        this.thisMonthEarning,
        this.stores,
        this.roles,
        this.employeeInfo,
      });

  ProfileModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fName = json['f_name'];
    lName = json['l_name'];
    phone = json['phone'];
    email = json['email'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    bankName = json['bank_name'];
    branch = json['branch'];
    holderName = json['holder_name'];
    accountNo = json['account_no'];
    image = json['image'];
    orderCount = json['order_count'];
    todaysOrderCount = json['todays_order_count'];
    thisWeekOrderCount = json['this_week_order_count'];
    thisMonthOrderCount = json['this_month_order_count'];
    memberSinceDays = json['member_since_days'];
    cashInHands = json['cash_in_hands'].toDouble();
    balance = json['balance'].toDouble();
    totalEarning = json['total_earning'].toDouble();
    todaysEarning = json['todays_earning'].toDouble();
    thisWeekEarning = json['this_week_earning'].toDouble();
    thisMonthEarning = json['this_month_earning'].toDouble();
    if (json['stores'] != null) {
      stores = [];
      json['stores'].forEach((v) {
        stores!.add(Store.fromJson(v));
      });
    }
    if(json['roles'] != null) {
      roles = [];
      json['roles'].forEach((v) => roles!.add(v));
    }
    if(json['employee_info'] != null){
      employeeInfo = EmployeeInfo.fromJson(json['employee_info']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['f_name'] = fName;
    data['l_name'] = lName;
    data['phone'] = phone;
    data['email'] = email;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['bank_name'] = bankName;
    data['branch'] = branch;
    data['holder_name'] = holderName;
    data['account_no'] = accountNo;
    data['image'] = image;
    data['order_count'] = orderCount;
    data['todays_order_count'] = todaysOrderCount;
    data['this_week_order_count'] = thisWeekOrderCount;
    data['this_month_order_count'] = thisMonthOrderCount;
    data['member_since_days'] = memberSinceDays;
    data['cash_in_hands'] = cashInHands;
    data['balance'] = balance;
    data['total_earning'] = totalEarning;
    data['todays_earning'] = todaysEarning;
    data['this_week_earning'] = thisWeekEarning;
    data['this_month_earning'] = thisMonthEarning;
    if (stores != null) {
      data['stores'] = stores!.map((v) => v.toJson()).toList();
    }
    data['employee_info'] = employeeInfo;
    return data;
  }
}

class Store {
  int? id;
  String? name;
  String? phone;
  String? email;
  String? logo;
  String? latitude;
  String? longitude;
  String? address;
  double? minimumOrder;
  bool? scheduleOrder;
  String? currency;
  String? createdAt;
  String? updatedAt;
  bool? freeDelivery;
  String? coverPhoto;
  bool? delivery;
  bool? takeAway;
  double? tax;
  bool? reviewsSection;
  bool? itemSection;
  double? avgRating;
  int? ratingCount;
  bool? active;
  bool? gstStatus;
  String? gstCode;
  int? selfDeliverySystem;
  bool? posSystem;
  double? minimumShippingCharge;
  double? maximumShippingCharge;
  double? perKmShippingCharge;
  String? deliveryTime;
  int? veg;
  int? nonVeg;
  int? orderPlaceToScheduleInterval;
  Module? module;
  Discount? discount;
  List<Schedules>? schedules;

  Store(
      {this.id,
        this.name,
        this.phone,
        this.email,
        this.logo,
        this.latitude,
        this.longitude,
        this.address,
        this.minimumOrder,
        this.scheduleOrder,
        this.currency,
        this.createdAt,
        this.updatedAt,
        this.freeDelivery,
        this.coverPhoto,
        this.delivery,
        this.takeAway,
        this.tax,
        this.reviewsSection,
        this.itemSection,
        this.avgRating,
        this.ratingCount,
        this.active,
        this.gstStatus,
        this.gstCode,
        this.selfDeliverySystem,
        this.posSystem,
        this.minimumShippingCharge,
        this.maximumShippingCharge,
        this.perKmShippingCharge,
        this.deliveryTime,
        this.veg,
        this.nonVeg,
        this.orderPlaceToScheduleInterval,
        this.module,
        this.discount,
        this.schedules,
      });

  Store.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    logo = json['logo'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    address = json['address'];
    minimumOrder = json['minimum_order'].toDouble();
    scheduleOrder = json['schedule_order'];
    currency = json['currency'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    freeDelivery = json['free_delivery'];
    coverPhoto = json['cover_photo'];
    delivery = json['delivery'];
    takeAway = json['take_away'];
    tax = json['tax'].toDouble();
    reviewsSection = json['reviews_section'];
    itemSection = json['item_section'];
    avgRating = json['avg_rating'].toDouble();
    ratingCount = json['rating_count'];
    active = json['active'];
    gstStatus = json['gst_status'];
    gstCode = json['gst_code'];
    selfDeliverySystem = json['self_delivery_system'];
    posSystem = json['pos_system'];
    minimumShippingCharge = json['minimum_shipping_charge'] != null ? json['minimum_shipping_charge'].toDouble() : 0.0;
    maximumShippingCharge = json['maximum_shipping_charge']?.toDouble();
    perKmShippingCharge = json['per_km_shipping_charge'] != null ? json['per_km_shipping_charge'].toDouble() : 0.0;
    deliveryTime = json['delivery_time'];
    veg = json['veg'];
    nonVeg = json['non_veg'];
    orderPlaceToScheduleInterval = json['order_place_to_schedule_interval'];
    module = json['module'] != null ? Module.fromJson(json['module']) : null;
    discount = json['discount'] != null ? Discount.fromJson(json['discount']) : null;
    if (json['schedules'] != null) {
      schedules = <Schedules>[];
      json['schedules'].forEach((v) {
        schedules!.add(Schedules.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['phone'] = phone;
    data['email'] = email;
    data['logo'] = logo;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['address'] = address;
    data['minimum_order'] = minimumOrder;
    data['schedule_order'] = scheduleOrder;
    data['currency'] = currency;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['free_delivery'] = freeDelivery;
    data['cover_photo'] = coverPhoto;
    data['delivery'] = delivery;
    data['take_away'] = takeAway;
    data['tax'] = tax;
    data['reviews_section'] = reviewsSection;
    data['item_section'] = itemSection;
    data['avg_rating'] = avgRating;
    data['rating_count '] = ratingCount;
    data['active'] = active;
    data['gst_status'] = gstStatus;
    data['gst_code'] = gstCode;
    data['self_delivery_system'] = selfDeliverySystem;
    data['pos_system'] = posSystem;
    data['minimum_shipping_charge'] = minimumShippingCharge;
    data['maximum_shipping_charge'] = maximumShippingCharge;
    data['per_km_shipping_charge'] = perKmShippingCharge;
    data['delivery_time'] = deliveryTime;
    data['veg'] = veg;
    data['non_veg'] = nonVeg;
    data['order_place_to_schedule_interval'] = orderPlaceToScheduleInterval;
    if (module != null) {
      data['module'] = module!.toJson();
    }
    if (discount != null) {
      data['discount'] = discount!.toJson();
    }
    if (schedules != null) {
      data['schedules'] = schedules!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
class EmployeeInfo {
  int? id;
  String? fName;
  String? lName;
  String? phone;
  String? email;
  String? image;
  int? employeeRoleId;
  int? storeId;

  EmployeeInfo(
      {this.id,
        this.fName,
        this.lName,
        this.phone,
        this.email,
        this.image,
        this.employeeRoleId,
        this.storeId,
      });

  EmployeeInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fName = json['f_name'];
    lName = json['l_name'];
    phone = json['phone'];
    email = json['email'];
    image = json['image'];
    employeeRoleId = json['employee_role_id'];
    storeId = json['store_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['f_name'] = fName;
    data['l_name'] = lName;
    data['phone'] = phone;
    data['email'] = email;
    data['image'] = image;
    data['employee_role_id'] = employeeRoleId;
    data['store_id'] = storeId;
    return data;
  }
}

class Discount {
  int? id;
  String? startDate;
  String? endDate;
  String? startTime;
  String? endTime;
  double? minPurchase;
  double? maxDiscount;
  double? discount;
  String? discountType;
  int? storeId;
  String? createdAt;
  String? updatedAt;

  Discount(
      {this.id,
        this.startDate,
        this.endDate,
        this.startTime,
        this.endTime,
        this.minPurchase,
        this.maxDiscount,
        this.discount,
        this.discountType,
        this.storeId,
        this.createdAt,
        this.updatedAt});

  Discount.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    minPurchase = json['min_purchase'].toDouble();
    maxDiscount = json['max_discount'].toDouble();
    discount = json['discount'].toDouble();
    discountType = json['discount_type'];
    storeId = json['store_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    data['min_purchase'] = minPurchase;
    data['max_discount'] = maxDiscount;
    data['discount'] = discount;
    data['discount_type'] = discountType;
    data['store_id'] = storeId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Schedules {
  int? id;
  int? storeId;
  int? day;
  String? openingTime;
  String? closingTime;

  Schedules(
      {this.id,
        this.storeId,
        this.day,
        this.openingTime,
        this.closingTime});

  Schedules.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    storeId = json['store_id'];
    day = json['day'];
    openingTime = json['opening_time'].substring(0, 5);
    closingTime = json['closing_time'].substring(0, 5);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['store_id'] = storeId;
    data['day'] = day;
    data['opening_time'] = openingTime;
    data['closing_time'] = closingTime;
    return data;
  }
}

class Module {
  int? id;
  String? moduleName;
  String? moduleType;
  String? thumbnail;
  String? status;
  int? storesCount;
  String? createdAt;
  String? updatedAt;

  Module(
      {this.id,
        this.moduleName,
        this.moduleType,
        this.thumbnail,
        this.status,
        this.storesCount,
        this.createdAt,
        this.updatedAt});

  Module.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    moduleName = json['module_name'];
    moduleType = json['module_type'];
    thumbnail = json['thumbnail'];
    status = json['status'];
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
    data['status'] = status;
    data['stores_count'] = storesCount;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}