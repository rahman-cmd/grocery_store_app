class CouponBody {
  int? id;
  String? title;
  String? code;
  String? startDate;
  String? expireDate;
  int? minPurchase;
  int? maxDiscount;
  int? discount;
  String? discountType;
  String? couponType;
  int? limit;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? data;
  int? totalUses;
  String? createdBy;
  List<String>? customerId;
  String? slug;
  int? restaurantId;

  CouponBody(
      {this.id,
        this.title,
        this.code,
        this.startDate,
        this.expireDate,
        this.minPurchase,
        this.maxDiscount,
        this.discount,
        this.discountType,
        this.couponType,
        this.limit,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.data,
        this.totalUses,
        this.createdBy,
        this.customerId,
        this.slug,
        this.restaurantId});

  CouponBody.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    code = json['code'];
    startDate = json['start_date'];
    expireDate = json['expire_date'];
    minPurchase = json['min_purchase'];
    maxDiscount = json['max_discount'];
    discount = json['discount'];
    discountType = json['discount_type'];
    couponType = json['coupon_type'];
    limit = json['limit'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    data = json['data'];
    totalUses = json['total_uses'];
    createdBy = json['created_by'];
    customerId = json['customer_id'].cast<String>();
    slug = json['slug'];
    restaurantId = json['restaurant_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['code'] = code;
    data['start_date'] = startDate;
    data['expire_date'] = expireDate;
    data['min_purchase'] = minPurchase;
    data['max_discount'] = maxDiscount;
    data['discount'] = discount;
    data['discount_type'] = discountType;
    data['coupon_type'] = couponType;
    data['limit'] = limit;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['data'] = this.data;
    data['total_uses'] = totalUses;
    data['created_by'] = createdBy;
    data['customer_id'] = customerId;
    data['slug'] = slug;
    data['restaurant_id'] = restaurantId;
    return data;
  }
}